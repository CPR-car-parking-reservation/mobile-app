import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

part 'admin_setting_event.dart';
part 'admin_setting_state.dart';

class AdminSettingBloc extends Bloc<AdminSettingEvent, AdminSettingState> {
  AdminSettingBloc() : super(AdminSettingInitial()) {
    on<OnSettingPageLoad>((event, emit) {
      emit(AdminSettingInitial());
    });
    on<OnUpdatePassword>((event, emit) async {
      emit(AdminSettingLoading());

      try {
        final response = await update_password(
            event.old_password, event.new_password, event.confirm_password);

        final responseBody = jsonDecode(await response.stream.bytesToString());
        if (response.statusCode != 200) {
          throw responseBody['message'];
          
          
        }
        emit(AdminSettingSuccess(message: responseBody['message']));
        
      } catch (e) {
        emit(AdminSettingFailed(message: e.toString()));
      }
    });
  }
  String baseUrl = dotenv.env['BASE_URL'].toString();

  Future<http.StreamedResponse> update_password(
      old_password, new_password, confirm_password) async {
    final perfs = await SharedPreferences.getInstance();
    final token = perfs.getString('token');

    final url = Uri.parse('$baseUrl/profile/reset_password');
    final request = http.MultipartRequest('PUT', url)
      ..headers.addAll({
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token'
      });

    request.fields['old_password'] = old_password;
    request.fields['new_password'] = new_password;
    request.fields['confirm_password'] = confirm_password;

    var response = await request.send();

    return response;
  }
}
