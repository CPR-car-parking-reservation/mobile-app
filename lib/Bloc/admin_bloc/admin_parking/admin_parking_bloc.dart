import 'dart:convert';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:car_parking_reservation/model/admin/parking.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';
import 'package:shared_preferences/shared_preferences.dart';

part 'admin_parking_event.dart';
part 'admin_parking_state.dart';

class AdminParkingBloc extends Bloc<AdminParkingEvent, AdminParkingState> {
  AdminParkingBloc() : super(AdminParkingInitial()) {
    on<OnParkingPageLoad>((event, emit) async {
      emit(AdminParkingLoading());
      try {
        List<ModelParkingSlot> data = await fetchParkingSlot("", "", "");
        List<ModelFloor> floorsData = await fetchFloor();
        emit(AdminParkingLoaded(parkings: data, floors: floorsData));
      } catch (e) {
        emit(AdminParkingError(message: e.toString()));
      }
    });
    on<OnSearch>((event, emit) async {
      final currentState = state;

      if (currentState is AdminParkingLoaded) {
        final newSearch = event.search ?? currentState.search;
        final newFloor = event.floor ?? currentState.floor;
        final newStatus = event.status ?? currentState.status;
        emit(AdminParkingLoading());

        final data = await fetchParkingSlot(newSearch, newFloor, newStatus);

        emit(AdminParkingLoaded(
          floors: currentState.floors,
          parkings: data,
          search: newSearch,
          floor: newFloor,
          status: newStatus,
        ));
      }
    });
    on<OnDelete>((event, emit) async {
      final currentState = state;
      if (currentState is AdminParkingLoaded) {
        try {
          final res = await deleteParkingSlot(event.id);
          final responseBody = jsonDecode(res.body);
          if (res.statusCode != 200) {
            throw responseBody["message"];
          }
          final data = await fetchParkingSlot("", "", "");

          emit(AdminParkingSuccess(message: responseBody["message"]));
          emit(AdminParkingLoaded(parkings: data, floors: currentState.floors));
        } catch (e) {
          emit(AdminParkingError(message: "Failed to delete data!"));
          emit(AdminParkingLoaded(
              parkings: currentState.parkings, floors: currentState.floors));
        }
      }
    });

    on<OnCreate>((event, emit) async {
      final currentState = state;

      if (currentState is AdminParkingLoaded) {
        try {
          final res =
              await createParkingSlot(event.slot_number, event.floor_number);
          final responseBody = await res.stream.bytesToString();
          final decodedResponse = jsonDecode(responseBody);
          if (res.statusCode != 200) {
            // คืนค่า message ออกจาก response
            throw decodedResponse["message"];
          }
          final data = await fetchParkingSlot("", "", "");

          emit(AdminParkingSuccess(message: decodedResponse["message"]));
          emit(AdminParkingLoaded(parkings: data, floors: currentState.floors));
        } catch (e) {
          emit(AdminParkingError(message: e.toString()));
          emit(AdminParkingLoaded(
              parkings: currentState.parkings, floors: currentState.floors));
        }
      }
    });

    on<OnUpdate>((event, emit) async {
      final currentState = state;

      if (currentState is AdminParkingLoaded) {
        try {
          final res = await updateParkingSlot(
              event.floor_number, event.slot_number, event.id);
          final responseBody = await res.stream.bytesToString();
          final decodedResponse = jsonDecode(responseBody);

          if (res.statusCode != 200) {
            // คืนค่า message ออกจาก response
            throw decodedResponse["message"];
          }
          final data = await fetchParkingSlot("", "", "");

          emit(AdminParkingSuccess(message: decodedResponse["message"]));
          emit(AdminParkingLoaded(parkings: data, floors: currentState.floors));
        } catch (e) {
          emit(AdminParkingError(message: e.toString()));
          emit(AdminParkingLoaded(
              parkings: currentState.parkings, floors: currentState.floors));
        }
      }
    });
  }
  String baseUrl = dotenv.env['BASE_URL'].toString();

  Future<List<ModelParkingSlot>> fetchParkingSlot(
      seacrhText, floor, status) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    try {
      seacrhText ??= "";
      floor ??= "";
      status ??= "";
      final response = await http.get(
          Uri.parse(
              "${baseUrl}/admin/parking_slots?search=$seacrhText&floor=$floor&status=$status"),
          headers: {
            "Accept": "application/json",
            "content-type": "application/json",
            "Authorization": "Bearer $token",
          });

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body); // Decode JSON
        final List<dynamic> data = jsonData["data"]; // เข้าถึง "data" ใน JSON

        return data.map((e) => ModelParkingSlot.fromJson(e)).toList();
      } else {
        throw 'Failed to load data!';
      }
    } catch (e) {
      throw 'Failed to load data!';
    }
  }

  Future<List<ModelFloor>> fetchFloor() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final response = await http.get(
      Uri.parse("$baseUrl/floors"),
      headers: {
        "Accept": "application/json",
        "content-type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body);
      final List<dynamic> data = jsonData["data"];

      return data.map((e) => ModelFloor.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load data!');
    }
  }

  Future<http.StreamedResponse> createParkingSlot(
      slot_number, floor_number) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final url = Uri.parse("$baseUrl/admin/parking_slots");
    var request = http.MultipartRequest('POST', url)
      ..fields['slot_number'] = slot_number
      ..fields['floor_number'] = floor_number;
    request.headers.addAll({
      "Accept": "application/json",
      "content-type": "application/json",
      "Authorization": "Bearer $token",
    });

    var response = await request.send();

    return response;
  }

  Future<http.Response> deleteParkingSlot(String id) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final response = await http.delete(
      Uri.parse("$baseUrl/admin/parking_slots/id/$id"),
      headers: {
        "Accept": "application/json",
        "content-type": "application/json",
        "Authorization": "Bearer $token",
      },
    );

    return response;
  }

  Future<http.StreamedResponse> updateParkingSlot(
      id, slot_number, floor_number) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    //from data
    final url = Uri.parse("$baseUrl/admin/parking_slots/id/$id");
    var request = http.MultipartRequest('PUT', url)
      ..fields['slot_number'] = slot_number
      ..fields['floor_number'] = floor_number;
    request.headers.addAll({
      "Accept": "application/json",
      "content-type": "application/json",
      "Authorization": "Bearer $token",
    });

    var response = await request.send();

    return response;
  }
}