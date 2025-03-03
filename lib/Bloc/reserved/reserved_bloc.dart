import 'dart:developer';

import 'package:bloc/bloc.dart';
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
        final respones =
            await postData(event.car_id, event.parking_slot_id, event.start_at);
        if (respones.statusCode != 200) {
          final responseBody = await respones.stream.bytesToString();
          final responseJson = jsonDecode(responseBody);
          emit(ReservedError(responseJson['message']));
          throw Exception(responseJson['message']);
        }

        emit(ReservedSuccess("Reservation Success"));
        emit(ReservCreated(event.car_id, event.parking_slot_id, event.start_at));

        log("${car_data} ${event.parking_slot_id} ${event.start_at}");
      } catch (e) {
        emit(ReservedError(e.toString()));
        emit(ReservCreated(event.car_id, event.parking_slot_id, event.start_at));
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

    final responseBody = await response.stream.bytesToString();
    log("Response Status: ${response.statusCode}");
    log("Response Body: $responseBody");

    if (response.statusCode != 200) {
      throw Exception("Failed to send data! Error: $responseBody");
    }

    return response;
  }

  //get all car_data well using car_id, car_number
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
