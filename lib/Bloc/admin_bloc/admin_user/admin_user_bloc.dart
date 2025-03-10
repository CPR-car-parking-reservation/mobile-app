import 'dart:async';
import 'dart:convert';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:car_parking_reservation/model/admin/users.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

part 'admin_user_event.dart';
part 'admin_user_state.dart';

class AdminUserBloc extends Bloc<AdminUserEvent, AdminUserState> {
  Timer? _timer;
  AdminUserBloc() : super(AdminUserInitial()) {
    on<OnUsersPageLoad>((event, emit) async {
      emit(AdminUserLoading());
      try {
        final data = await fetchUsers("");

        emit(AdminUserLoaded(users: data));
      } catch (e) {
        emit(AdminUserError(message: e.toString()));
      }
    });

    on<OnSearch>((event, emit) async {
      emit(AdminUserLoading());
      try {
        final data = await fetchUsers(event.search);
        emit(AdminUserLoaded(users: data));
      } catch (e) {
        emit(AdminUserError(message: e.toString()));
      }
    });

    on<OnRefresh>((event, emit) async {
      final currentState = state;

      if (currentState is AdminUserLoaded) {
        final newSearch = event.search ?? currentState.search;

        final data = await fetchUsers(newSearch);

        emit(AdminUserLoaded(
          users: data,
          search: newSearch,
        ));
      }
    });

    on<SetLoading>((event, emit) async {
      emit(AdminUserLoading());
    });
  }

  String baseUrl = dotenv.env['BASE_URL'].toString();

  Future<List<ModelUsers>> fetchUsers(seacrhText) async {
    final prefs = await SharedPreferences.getInstance();
    final token = prefs.getString('token');
    try {
      seacrhText ??= "";

      final response = await http
          .get(Uri.parse("$baseUrl/admin/users?search=$seacrhText"), headers: {
        "Accept": "application/json",
        "content-type": "application/json",
        "Authorization": "Bearer $token"
      });

      if (response.statusCode == 200) {
        final jsonData = json.decode(response.body); // Decode JSON
        final List<dynamic> data = jsonData["data"]; // เข้าถึง "data" ใน JSON

        return data.map((e) => ModelUsers.fromJson(e)).toList();
      } else {
        throw 'Failed to load data!';
      }
    } catch (e) {
      throw e;
    }
  }

  void _startAutoRefresh() {
    _timer?.cancel();
    _timer = Timer.periodic(const Duration(seconds: 30), (timer) {
      add(OnRefresh());
    });
  }

  @override
  Future<void> close() {
    _timer?.cancel();
    return super.close();
  }
}
