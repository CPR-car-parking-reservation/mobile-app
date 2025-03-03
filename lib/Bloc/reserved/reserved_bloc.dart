import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:car_parking_reservation/model/history.dart';
import 'package:car_parking_reservation/model/reservation.dart';
//import 'package:car_parking_reservation/model/reservation.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:car_parking_reservation/bloc/parking/parking_bloc.dart';
import 'package:car_parking_reservation/model/car.dart';

import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

part 'reserved_event.dart';
part 'reserved_state.dart';

class ReservedBloc extends Bloc<ReservedEvent, ReservedState> {
  ReservedBloc() : super(ReservedInitial()) {
    on<FectchFirstReserved>((event, emit) async {
      emit(ReserveLoading());
      try {
        final currentData = await _onFetchUser();
        log("Data: $currentData");
        emit(ReservedLoaded(carData: currentData));
      } catch (e) {
        emit(ReservedError(e.toString()));
        log("Error fetching data: $e");
      }
    });

    on<SendReservation>((event, emit) async {
      emit(ReserveLoading());
      try {
        final response =
            await postData(event.car_id, event.parking_slot_id, event.start_at);
        final responseBody = await response.stream.bytesToString();
        log("Response Body: $responseBody");

        final decodeResponse = json.decode(responseBody);
        log("Decoded Response: $decodeResponse");

        if (response.statusCode == 200) {
          // ดึง reservation_id จาก response
          final reservationId = decodeResponse['data'] != null
              ? decodeResponse['data']['id'] ?? ''
              : '';

          log("Reservation ID: $reservationId");

          emit(ReservCreated(event.car_id, event.parking_slot_id,
              event.start_at, reservationId));
          emit(ReservedSuccess(
              reservationId: reservationId,
              message: decodeResponse['message']));
          
        } else {
          throw Exception(
              decodeResponse['message'] ?? 'Failed to create reservation.');
        }

        log("Sent Data: car_id=${event.car_id}, parking_slot_id=${event.parking_slot_id}, start_at=${event.start_at}");
      } catch (e) {
        log("Error: $e");
        emit(ReservedError(e.toString()));
      }
    });
  }
  String baseUrl = dotenv.env['BASE_URL'].toString();
  // Future<List<History_data>> fetchData() async {
  //   debugPrint('url: $baseUrl');
  //   final response =
  //       await http.get(Uri.parse("$baseUrl/reservation"), headers: {
  //     "Accept": "application/json",
  //     "content-type": "application/json",
  //   });

  //   if (response.statusCode == 200) {
  //     // List<dynamic> data = jsonDecode(response.body);  // ok
  //     List data = json.decode(response.body); // ok

  //     return data
  //         .map((e) => History_data.fromJson(e))
  //         .toList(); // use method in class
  //   } else {
  //     debugPrint('failed loading');
  //     throw Exception('Failed to load data!');
  //   }
  // }

  Future<http.StreamedResponse> postData(
      car_id, parking_slot_id, start_at) async {
    final url = Uri.parse("$baseUrl/reservation");

    var request = http.MultipartRequest('POST', url)
      ..fields['car_id'] = car_id
      ..fields['parking_slot_id'] = parking_slot_id
      ..fields['start_at'] = start_at;

    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token') ?? '';
    await prefs.setString('token', token);
    

    request.headers.addAll({
      "Accept": "application/json",
      "content-type": "application/json",
      "Authorization": "Bearer $token",
    });

    var response = await request.send();
    return response;
  }

  //get all car_data well using car_id, license_plate
  Future<List<car_data>> _onFetchUser() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('token') ?? '';

      final response = await http.get(
        Uri.parse("$baseUrl/profile/cars"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      log("Response Status: ${response.statusCode}");
      log("Response Body: ${response.body}");

      final jsonData = json.decode(response.body);

      // ตรวจสอบว่า response มี "data" และ "car" หรือไม่
      if (jsonData["data"] != null && jsonData["data"]["car"] is List) {
        return (jsonData["data"]["car"] as List)
            .map((e) => car_data.fromJson(e))
            .toList();
      } else {
        throw Exception("Unexpected data format: Missing 'data' or 'car' list");
      }
    } catch (e) {
      throw Exception('Error: ${e.toString()}');
    }
  }
}
