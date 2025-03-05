import 'dart:convert';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:car_parking_reservation/bloc/reserved/reserved_bloc.dart';
import 'package:car_parking_reservation/model/history.dart';
import 'package:car_parking_reservation/model/reservation.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

part 'history_event.dart';
part 'history_state.dart';

class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  HistoryBloc() : super(HistoryInitial()) {
    on<FetchFirstHistory>((event, emit) async {
      emit(HistoryLoading());
      try {
        final currentData = await fetchData();
        log("Data: $currentData");
        emit(HistoryLoaded(history: currentData));
      } catch (e) {
        emit(HistoryError(e.toString()));
        log("Error fetching data: $e");
      }
    });
  }

  String baseUrl = dotenv.env['BASE_URL'].toString();
  Future<List<Reservation_Model>> fetchData() async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      String token = prefs.getString('token') ?? '';

      final response = await http.get(
        Uri.parse("$baseUrl/reservation/user"),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      log("Response Status: ${response.statusCode}");
      log("Response Body: ${response.body}");

      final jsonData = json.decode(response.body);

      // ตรวจสอบว่า response มี "data" และ "car" หรือไม่
      if (jsonData["data"] != null && jsonData["data"] is List) {
        return (jsonData["data"] as List)
            .map((e) => Reservation_Model.fromJson(e))
            .toList();
      } else {
        throw Exception("Unexpected data format");
      }
    } catch (e) {
      throw Exception('Error: ${e.toString()}');
    }

    // if (response.statusCode == 200) {
    //   // List<dynamic> data = jsonDecode(response.body);  // ok
    //   List data = json.decode(response.body); // ok

    //   return data
    //       .map((e) => Reservation_Model.fromJson(e))
    //       .toList(); // use method in class
    // } else {
    //   debugPrint('failed loading');
    //   throw Exception('Failed to load data!');
    // }
  }
}
