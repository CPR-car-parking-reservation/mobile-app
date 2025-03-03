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
        await prefs.setString('role', role);
        log(token);
        Future.delayed(Duration(seconds: 1));
        emit(LoginSuccess(token, role));
        // Navigator.pushNamed(event.context, '/home');
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
}
