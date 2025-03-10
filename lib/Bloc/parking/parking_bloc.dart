import 'dart:async';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:car_parking_reservation/model/parking_slot.dart';
import 'dart:convert';

import 'package:shared_preferences/shared_preferences.dart';

part 'parking_state.dart';
part 'parking_event.dart';

class ParkingBloc extends Bloc<ParkingEvent, ParkingState> {
  Timer? _timer; // เพิ่มตัวจับเวลา

  ParkingBloc() : super(ParkingInitial()) {
    on<SetLoading>((event, emit) {
      emit(ParkingLoading());
    });

    on<OnFirstParkingSlot>((event, emit) async {
      emit(ParkingLoading());
      try {
        final parkingSlots = await onFetchData();
        emit(ParkingLoaded(parkingSlots));

        // ตั้งค่าให้รีเฟรชทุก 30 วินาที
        _startAutoRefresh();
      } catch (e) {
        if (e == 'Unauthorized!') {
          emit(ParkingError("Unauthorized!"));
        } else {
          emit(ParkingError("Now : Failed to load data!"));
        }
      }
    });

    on<RefrechParkingSlot>((event, emit) async {
      if (state is ParkingLoaded) {
        try {
          final parkingSlots = await onFetchData();
          emit(
              ParkingLoaded(parkingSlots)); // อัปเดตสถานะโดยไม่ต้องแสดง Loading
        } catch (e) {
          emit(ParkingError("Now : Failed to load data!"));
        }
      }
    });
  }

  String baseUrl = dotenv.env['BASE_URL'].toString();

  Future<List<ParkingSlot>> onFetchData() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    final response =
        await http.get(Uri.parse("$baseUrl/parking_slots"), headers: {
      "Accept": "application/json",
      "content-type": "application/json",
      "Authorization": "Bearer $token"
    });

    if (response.statusCode == 200) {
      Map<String, dynamic> decodedJson = json.decode(response.body);
      if (decodedJson.containsKey('data')) {
        List data = decodedJson['data'];
        return data.map((e) => ParkingSlot.fromJson(e)).toList();
      } else {
        throw Exception('Invalid response format!');
      }
    }
    if (response.statusCode == 401) {
      prefs.remove('token');
      prefs.remove('role');
      throw 'Unauthorized!';
    } else {
      throw Exception('Failed to load data!');
    }
  }

  void _startAutoRefresh() {
    _timer?.cancel(); // ยกเลิก Timer เดิมก่อน
    _timer = Timer.periodic(const Duration(seconds: 30), (timer) {
      add(RefrechParkingSlot()); // Trigger event ทุก 30 วินาที
    });
  }

  @override
  Future<void> close() {
    _timer?.cancel(); // ปิด Timer เมื่อ Bloc ถูกปิด
    return super.close();
  }
}
