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
        final res = await createUser(event.email, event.password,
            event.confirm_password, event.name, event.surname, event.phone);

        final responseBody = await res.stream.bytesToString();
        final decodedResponse = json.decode(responseBody);

        if (res.statusCode == 200) {
          emit(RegisterCreated(
              name: event.name,
              surname: event.surname,
              email: event.email,
              password: event.password,
              confirm_password: event.confirm_password,
              phone: event.phone));

          emit(RegisterSuccess(message: decodedResponse['message']));
        } 
        else {
          throw decodedResponse['message'];
          
        }

        
      } catch (e) {
        emit(RegisterError(message: e.toString()));
        log(e.toString());
      }
    });
  }
  String baseUrl = dotenv.env['BASE_URL'].toString();

  Future<http.StreamedResponse> createUser(
      String email,
      String password,
      String confirm_password,
      String name,
      String surname,
      String phone) async {
    final url = Uri.parse('$baseUrl/register');

    log("Sending request to: $url");
    log("Data: name=$name, email=$email, password=$password");

    var request = http.MultipartRequest('POST', url)
      ..fields['email'] = email
      ..fields['password'] = password
      ..fields['confirm_password'] = confirm_password
      ..fields['name'] = name
      ..fields['surname'] = surname
      ..fields['phone'] = phone;

    request.headers.addAll({
      "Accept": "application/json",
      'Content-Type': 'application/json',
    });

    var response = await request.send();
    log("Response status: ${response.statusCode}");
    return response;
  }
}