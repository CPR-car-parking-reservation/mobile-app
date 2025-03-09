import 'dart:convert';
import 'dart:developer';
import 'dart:io';

import 'package:bloc/bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

part 'qr_bloc_event.dart';
part 'qr_bloc_state.dart';

class QrBloc extends Bloc<QrBlocEvent, QrBlocState> {
  QrBloc() : super(QrBlocInitial()) {
    on<FetchQr>((event, emit) async {
      try {
        emit(QrBlocLoading());
        final res = await fetchQr();
        if (res.statusCode == 200) {
          final responseBody = jsonDecode(res.body);
          emit(QrBlocLoaded(reservationId: responseBody['data'] as String));
        } else {
          emit(QrBlocError("Not found reservation id"));
        }
      } catch (e) {
        emit(QrBlocError("Not found reservation id"));
      }
    });
  }

  String baseUrl = dotenv.env['BASE_URL'].toString();

  Future<http.Response> fetchQr() async {
    final perfs = await SharedPreferences.getInstance();
    final token = perfs.getString('token');

    final url = Uri.parse('$baseUrl/reservation/qr');
    final response = await http.get(url, headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token'
    });

    return response; // แปลงเป็น double
  }
}
