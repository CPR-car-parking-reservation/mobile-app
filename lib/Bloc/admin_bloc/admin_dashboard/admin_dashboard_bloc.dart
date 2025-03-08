import 'dart:convert';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:car_parking_reservation/model/admin/dashboard.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

part 'admin_dashboard_event.dart';
part 'admin_dashboard_state.dart';

class AdminDashboardBloc
    extends Bloc<AdminDashboardEvent, AdminDashboardState> {
  AdminDashboardBloc() : super(AdminDashboardInitial()) {
    on<AdminDashboardOnLoad>((event, emit) async {
      emit(AdminDashboardLoading());
      try {
        final data = await fetchDashboard();
        emit(AdminDashboardLoaded(adminDashboardData: data));
      } catch (e) {
        emit(AdminDashboardError(message: e.toString()));
      }
    });
    on<AdminDashboardRefresh>((event, emit) async {
      try {
        final data = await fetchDashboard();
        emit(AdminDashboardLoaded(adminDashboardData: data));
      } catch (e) {
        emit(AdminDashboardError(message: e.toString()));
      }
    });
  }

  String baseUrl = dotenv.env['BASE_URL'].toString();

  Future<List<ModelDashboard>> fetchDashboard() async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    try {
      final response =
          await http.get(Uri.parse("$baseUrl/admin/dashboard/total"), headers: {
        "Accept": "application/json",
        "content-type": "application/json",
        "Authorization": "Bearer $token",
      });

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body);
        final List<dynamic> data = jsonData["data"];

        return data.map((e) => ModelDashboard.fromJson(e)).toList();
      } else {
        log(response.body);
        throw 'Failed to load data!';
      }
    } catch (e) {
      throw e.toString();
    }
  }
}
