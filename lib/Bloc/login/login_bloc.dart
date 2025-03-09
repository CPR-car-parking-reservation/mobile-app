import 'dart:convert';
import 'dart:developer';

import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

part 'login_event.dart';
part 'login_state.dart';

class LoginBloc extends Bloc<LoginEvent, LoginState> {
  LoginBloc() : super(LoginInitial()) {
    on<onPageLoad>((event, emit) async {
      final res = await checkRole();
      final responseBody = res.body;
      final decodedResponse = jsonDecode(responseBody);
      if (res.statusCode != 200) {
        // emit(LoginError(decodedResponse["message"] ?? ''));
        emit(LoginInitial());
      } else {
        String role = decodedResponse["role"];
        emit(LoginSuccess(role: role));
      }
    });
    on<onSubmit>((event, emit) async {
      emit(LoginLoading());
      try {
        final res = await LoginUser(event.email, event.password);
        final responseBody = await res.stream.bytesToString();
        final decodedResponse = jsonDecode(responseBody);
        if (res.statusCode != 200) {
          throw decodedResponse["message"];
        }
        String token = decodedResponse["token"] ?? '';
        String role = decodedResponse["role"];

        SharedPreferences prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', token);

        Future.delayed(Duration(seconds: 1));
        emit(LoginSuccess(role: role));
        log("role: $role");
      } catch (e) {
        emit(LoginError(e.toString()));
      }
    });
  }
  String baseUrl = dotenv.env['BASE_URL'].toString();
  Future<http.StreamedResponse> LoginUser(email, password) async {
    final url = Uri.parse("$baseUrl/login");
    var request = http.MultipartRequest('POST', url)
      ..fields['email'] = email
      ..fields['password'] = password;
    request.headers.addAll({
      "Accept": "application/json",
      "content-type": "application/json",
    });

    var response = await request.send();
    return response;
  }

  Future<http.Response> checkRole() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token') ?? '';
    final url = Uri.parse("$baseUrl/login/check_role");
    var response = await http.get(url, headers: {
      "Accept": "application/json",
      "content-type": "application/json",
      "Authorization": "Bearer $token"
    });
    return response;
  }
}
