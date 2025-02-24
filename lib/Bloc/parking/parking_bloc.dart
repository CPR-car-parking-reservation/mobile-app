import 'dart:async';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:car_parking_reservation/model/parking_slot.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

part 'parking_event.dart';
part 'parking_state.dart';

class ParkingBloc extends Bloc<ParkingEvent, ParkingState> {
  static const String baseUrl =
      "https://shaft-sheet-scotia-sweden.trycloudflare.com";

  ParkingBloc() : super(ParkingInitial()) {
    on<FetchSlots>(_onFetchSlots);
  }

  Future<void> _onFetchSlots(
      FetchSlots event, Emitter<ParkingState> emit) async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/parking_slots'));
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseJson = json.decode(response.body);
        final List<dynamic> parkingSlotList = responseJson['data'];
        final List<ParkingSlot> slots =
            parkingSlotList.map((slot) => ParkingSlot.fromJson(slot)).toList();
        emit(SlotsLoaded(slots: slots));
      } else {
        emit(ParkingError('Failed to load data!'));
      }
    } catch (error) {
      emit(ParkingError("Error fetching slots: $error"));
    }
  }
}
