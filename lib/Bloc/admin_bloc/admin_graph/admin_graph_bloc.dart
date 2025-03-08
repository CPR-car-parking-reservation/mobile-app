import 'dart:convert';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:car_parking_reservation/model/admin/dashboard.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

part 'admin_graph_event.dart';
part 'admin_graph_state.dart';

class AdminGraphBloc extends Bloc<AdminGraphEvent, AdminGraphState> {
  AdminGraphBloc() : super(AdminGraphInitial()) {
    on<AdminGraphOnLoad>((event, emit) async {
      log("AdminGraphOnLoad ${event.month} ${event.year} ${event.type}");
      emit(AdminGraphLoading());
      try {
        final data = await fetchGraph(event.month, event.year, event.type);
        log("AdminGraphOnLoad ${data.length}");
        emit(AdminGraphLoaded(adminGraphData: data));
      } catch (e) {
        log(e.toString());
        emit(AdminGraphError(message: e.toString()));
      }
    });
  }

  final baseUrl = dotenv.env['BASE_URL'];

  Future<List<ModelGraph>> fetchGraph(int month, int year, String type) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    try {
      final response = await http.get(
          Uri.parse(
              "$baseUrl/admin/dashboard/reservation_and_cash?month=$month&year=$year&type=$type"),
          headers: {
            "Accept": "application/json",
            "content-type": "application/json",
            "Authorization": "Bearer $token",
          });

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final List<dynamic> data = jsonData["data"];

        return data.map((e) => ModelGraph.fromJson(e)).toList();
      } else {
        log(response.body);
        throw 'Failed to load data!';
      }
    } catch (e) {
      throw e.toString();
    }
  }
}
