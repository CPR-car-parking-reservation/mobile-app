import 'dart:convert';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:car_parking_reservation/model/admin/parking.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:meta/meta.dart';

part 'admin_parking_event.dart';
part 'admin_parking_state.dart';

class AdminParkingBloc extends Bloc<AdminParkingEvent, AdminParkingState> {
  AdminParkingBloc() : super(AdminParkingInitial()) {
    on<OnPageLoad>((event, emit) async {
      emit(AdminParkingLoading());

      try {
        log("Page Load Called in try");
        List<ModelParkingSlot> data = await fetchParkingSlot("", "", "");

        log("Data: $data");
        List<ModelFloor> floorsData = await fetchFloor();
        log("Floors: $floorsData");
        emit(AdminParkingLoaded(parkings: data, floors: floorsData));
      } catch (e) {
        emit(AdminParkingError(message: e.toString()));
      }
    });
    on<OnSearch>((event, emit) async {
      // emit(AdminParkingLoading());
      final currentState = state;
      // log("event Called");
      if (currentState is AdminParkingLoaded) {
        final newSearch = event.search ?? currentState.search;
        final newFloor = event.floor ?? currentState.floor;
        final newStatus = event.status ?? currentState.status;
        emit(AdminParkingLoading());

        // เรียก API ใหม่ตามค่าที่อัปเดต
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
      log("Delete Called $event.id");
      if (currentState is AdminParkingLoaded) {
        try {
          final res = await deleteParkingSlot(event.id);
          if (res.statusCode != 200) {
            throw Exception("Failed to delete data!");
          }
          final data = await fetchParkingSlot("", "", "");

          emit(AdminParkingSuccess(message: "Deleted successfully!"));
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
      log("Create Called ${event.slot_number} ${event.floor_number}");
      if (currentState is AdminParkingLoaded) {
        try {
          final res =
              await createParkingSlot(event.slot_number, event.floor_number);
          if (res.statusCode != 200) {
            final responseBody = await res.stream.bytesToString();
            final decodedResponse = jsonDecode(responseBody);

            // คืนค่า message ออกจาก response
            throw decodedResponse["message"];
          }
          final data = await fetchParkingSlot("", "", "");

          emit(AdminParkingSuccess(message: "Created successfully!"));
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
          if (res.statusCode != 200) {
            final responseBody = await res.stream.bytesToString();
            final decodedResponse = jsonDecode(responseBody);

            // คืนค่า message ออกจาก response
            throw decodedResponse["message"];
          }
          final data = await fetchParkingSlot("", "", "");

          emit(AdminParkingSuccess(message: "Updated successfully!"));
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
    seacrhText ??= "";
    floor ??= "";
    status ??= "";
    final response = await http.get(
        Uri.parse(
            "$baseUrl/parking_slots?search=$seacrhText&floor=$floor&status=$status"),
        headers: {
          "Accept": "application/json",
          "content-type": "application/json",
        });

    if (response.statusCode == 200) {
      final jsonData = json.decode(response.body); // Decode JSON
      final List<dynamic> data = jsonData["data"]; // เข้าถึง "data" ใน JSON

      return data.map((e) => ModelParkingSlot.fromJson(e)).toList();
    } else {
      throw Exception('Failed to load data!');
    }
  }

  Future<http.Response> deleteParkingSlot(String id) async {
    final response = await http.delete(
      Uri.parse("$baseUrl/parking_slots/id/$id"),
      headers: {
        "Accept": "application/json",
        "content-type": "application/json",
      },
    );

    return response;
  }

  Future<List<ModelFloor>> fetchFloor() async {
    final response = await http.get(
      Uri.parse("$baseUrl/floors"),
      headers: {
        "Accept": "application/json",
        "content-type": "application/json",
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
    //from data
    final url = Uri.parse("$baseUrl/parking_slots");
    var request = http.MultipartRequest('POST', url)
      ..fields['slot_number'] = slot_number
      ..fields['floor_number'] = floor_number;
    request.headers.addAll({
      "Accept": "application/json",
      "content-type": "application/json",
    });

    var response = await request.send();

    return response;
  }

  Future<http.StreamedResponse> updateParkingSlot(
      id, slot_number, floor_number) async {
    log("Update Called $floor_number $slot_number $id");
    //from data
    final url = Uri.parse("$baseUrl/parking_slots/id/$id");
    var request = http.MultipartRequest('PUT', url)
      ..fields['slot_number'] = slot_number
      ..fields['floor_number'] = floor_number;
    request.headers.addAll({
      "Accept": "application/json",
      "content-type": "application/json",
    });

    var response = await request.send();

    return response;
  }
}
