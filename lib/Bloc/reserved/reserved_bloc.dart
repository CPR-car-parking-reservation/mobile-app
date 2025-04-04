import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:car_parking_reservation/model/car.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:shared_preferences/shared_preferences.dart';
//import 'package:car_parking_reservation/model/reservation.dart';

part 'reserved_event.dart';
part 'reserved_state.dart';

class ReservedBloc extends Bloc<ReservedEvent, ReservedState> {
  ReservedBloc() : super(ReservedInitial()) {
    on<FectchFirstReserved>((event, emit) async {
      emit(ReserveLoading());
      try {
        final currentData = await _onFetchUser();
        emit(ReservedLoaded(carData: currentData));
      } catch (e) {
        emit(ReservedError(e.toString()));
      }
    });

    on<SendReservation>((event, emit) async {
      emit(ReserveLoading());
      try {
        final response = await postData(event.car_id, event.parking_slot_id);
        final responseBody = await response.stream.bytesToString();
        final decodeResponse = json.decode(responseBody);

        if (response.statusCode == 200) {
          // ดึง reservation_id จาก response
          final reservationId = decodeResponse['data'] != null
              ? decodeResponse['data']['id'] ?? ''
              : '';
          emit(ReservCreated(
              event.car_id, event.parking_slot_id, reservationId));
          emit(ReservedSuccess(
              reservationId: reservationId,
              message: decodeResponse['message']));
        } else {
          throw Exception(
              decodeResponse['message'] ?? 'Failed to create reservation.');
        }
      } catch (e) {
        emit(ReservedError(e.toString()));
      }
    });

    // event สำหรับยกเลิกการจอง
    on<CancelReservation>((event, emit) async {
      emit(ReserveLoading());
      try {
        final response = await cancelReservation(event.reservationId);
        final responseBody = response.body;
        final decodeResponse = json.decode(responseBody);

        if (response.statusCode == 200) {
          emit(ReservationCancelled(decodeResponse['message']));
          emit(ReservedInitial());
          SharedPreferences prefs = await SharedPreferences.getInstance();
          await prefs.setString('reservation_id', '');
        } else {
          throw Exception(
              decodeResponse['message'] ?? 'Failed to cancel reservation.');
        }
      } catch (e) {
        emit(ReservedError(e.toString()));
      }
    });
  }

  String baseUrl = dotenv.env['BASE_URL'].toString();
  Future<http.StreamedResponse> postData(carId, parkingSlotId) async {
    final url = Uri.parse("$baseUrl/reservation");

    var request = http.MultipartRequest('POST', url)
      ..fields['car_id'] = carId
      ..fields['parking_slot_id'] = parkingSlotId;

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

  // ยกเลิกการจอง โดยการส่ง reservation_id ไปยัง API
  Future<http.Response> cancelReservation(String reservationId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token') ?? '';
    log(reservationId);
    final url = Uri.parse('$baseUrl/reservation/cancel/id/$reservationId');
    final response = await http.post(url, headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    });
    return response;
  }
}
