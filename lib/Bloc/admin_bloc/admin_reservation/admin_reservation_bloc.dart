import 'dart:convert';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:car_parking_reservation/model/admin/reservation.dart';
import 'package:car_parking_reservation/model/history.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

part 'admin_reservation_event.dart';
part 'admin_reservation_state.dart';

class AdminReservationBloc
    extends Bloc<AdminReservationEvent, AdminReservationState> {
  AdminReservationBloc() : super(AdminReservationInitial()) {
    on<AdminReservationOnLoad>((event, emit) async {
      emit(AdminReservationLoading());
      try {
        final data = await fetchReservation(event.date, event.order);
        emit(AdminReservationLoaded(adminReservationData: data));
      } catch (e) {
        emit(AdminReservationError(message: e.toString()));
      }
    });
  }

  final baseUrl = dotenv.env['BASE_URL'];

  Future<List<Model_History_data>> fetchReservation(
      String date, String order) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    try {
      final response = await http.get(
          Uri.parse(
              "$baseUrl/admin/dashboard/reservations?date=$date&order=$order"),
          headers: {
            "Accept": "application/json",
            "content-type": "application/json",
            "Authorization": "Bearer $token",
          });

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final List<dynamic> data = jsonData["data"];
        log(data.toString());

        return data.map((e) => Model_History_data.fromJson(e)).toList();
      } else {
        log(response.body);
        throw 'Failed to load data!';
      }
    } catch (e) {
      throw e.toString();
    }
  }
}
