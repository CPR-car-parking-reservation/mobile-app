import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:car_parking_reservation/model/parking_slot.dart';
import 'dart:convert';

part 'parking_state.dart';
part 'parking_event.dart';

class ParkingBloc extends Bloc<ParkingEvent, ParkingState> {
  ParkingBloc() : super(ParkingInitial()) {
    on<OnFirstParkingSlot>((event, emit) async {
      emit(ParkingLoading());
      try {
        final parkingSlots = await onFetchData();
        emit(ParkingLoaded(parkingSlots));
      } catch (e) {
        emit(ParkingError("Now : Failed to load data!"));
      }
    });

    on<SenderParkingSlot>((event, emit) {
      if (state is ParkingLoaded) {
        final currentList =
            List<ParkingSlot>.from((state as ParkingLoaded).parkingSlots);
        currentList.add(event.parkingSlot);
        emit(ParkingLoaded(currentList));
      } else {
        emit(ParkingLoaded([event.parkingSlot]));
      }
    });

    on<SelectParkingSlotToReserv>((event, emit) {
      emit(ParkingLoading());
      log("🚗 Selected Parking Slot: ${event.selectedSlot.id}");
      log("🚗 Selected Parking Slot: ${event.selectedSlot.slot_number}");
      log("🚗 Selected Parking Slot: ${event.selectedSlot.floor.floor_number}");
      log("🚗 Selected Parking Slot: ${event.selectedSlot.status}");

      emit(ParkingSlotSelected(event.selectedSlot));

      log("🔹 State Changed to ParkingSlotSelected");
    });
  }
    String baseUrl = dotenv.env['BASE_URL'].toString();

  Future<List<ParkingSlot>> onFetchData() async {
    final response =
        await http.get(Uri.parse("$baseUrl/parking_slots"), headers: {
      "Accept": "application/json",
      "content-type": "application/json",
    });

    if (response.statusCode == 200) {
      Map<String, dynamic> decodedJson = json.decode(response.body);
      if (decodedJson.containsKey('data')) {
        List data = decodedJson['data'];
        return data.map((e) => ParkingSlot.fromJson(e)).toList();
      } else {
        throw Exception('Invalid response format!');
      }
    } else {
      throw Exception('Failed to load data!');
    }
  }
}
