import 'dart:convert';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:car_parking_reservation/model/parking_slot.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ParkingSlotCubit extends Cubit<List<ParkingSlot>> {
  ParkingSlotCubit() : super([]);

  static const String baseUrl = "https://myself-gourmet-discount-cindy.trycloudflare.com";

  Future<void> fetchAndSetSlots() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/parking_slots'));
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseJson = json.decode(response.body);
        final List<dynamic> parkingSlotList = responseJson['data'];
        final List<ParkingSlot> slots = parkingSlotList.map((slot) => ParkingSlot.fromJson(slot)).toList();
        emit(slots);
      } else {
        throw Exception('Failed to load data!');
      }
    } catch (error) {
      debugPrint("Error fetching slots: $error");
    }
  }

  Future<void> reserveSlot(ParkingSlot parking) async {
    final String url = '$baseUrl/parking_slots';
    final Map<String, String> body = {
      "slot_number": parking.slot_number,
      "floor_id": parking.floor.id,
      "status": parking.status,
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: json.encode(body),
      );
      if (response.statusCode == 200) {
        debugPrint("Slot reserved successfully!");
        fetchAndSetSlots();
      } else {
        debugPrint("Failed to reserve slot: ${response.body}");
      }
    } catch (error) {
      debugPrint("Error reserving slot: $error");
    }
  }
}