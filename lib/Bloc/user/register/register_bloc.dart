import 'dart:convert';
import 'dart:developer';

import 'package:bloc/bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

part 'register_event.dart';
part 'register_state.dart';

class RegisterBloc extends Bloc<RegisterEvent, RegisterState> {
  RegisterBloc() : super(RegisterInitial()) {
    on<OnCreateRegister>((event, emit) async {
      log("Create Register Called");
      try {
        final res = await createUser(
            event.email, event.password, event.confirm_password, event.name);

        if (res.statusCode != 200) {
          final responseBody = await res.stream.bytesToString();
          final decodedResponse = jsonDecode(responseBody);
          throw decodedResponse['message'];
        }

        emit(RegisterCreated(
          email: event.email,
          password: event.password,
          confirm_password: event.confirm_password,
          name: event.name,
        ));

        emit(RegisterSuccess("User Created"));

        log("User Created: ${event.name}, ${event.email}");
      } catch (e) {
        emit(RegisterError(message: e.toString()));
      }
    });
  }
  String baseUrl = dotenv.env['BASE_URL'].toString();

  Future<http.StreamedResponse> createUser(String email,
      String password, String confirmPassword, String name) async {
    final url = Uri.parse('$baseUrl/register');

    log("Sending request to: $url");
    log("Data: name=$name, email=$email, password=$password");

    var request = http.MultipartRequest('POST', url)
      ..fields['email'] = email
      ..fields['password'] = password
      ..fields['confirm_password'] = confirmPassword
      ..fields['name'] = name;

    request.headers.addAll({
      "Accept": "application/json",
      'Content-Type': 'application/json',
    });

    var response = await request.send();
    log("Response status: ${response.statusCode}");
    return response;
  }
}
