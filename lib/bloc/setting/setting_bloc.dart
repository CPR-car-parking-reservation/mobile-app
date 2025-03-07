import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:car_parking_reservation/model/car.dart';
import 'package:car_parking_reservation/model/profile.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'setting_event.dart';
import 'setting_state.dart';
// ignore: depend_on_referenced_packages
import 'package:http_parser/http_parser.dart';

class SettingBloc extends Bloc<SettingEvent, SettingState> {
  final String? baseUrl = dotenv.env['BASE_URL'];

  SettingBloc() : super(SettingInitial()) {
    on<AddCar>(_onAddCar);
    on<UpdateCar>(_onUpdateCar);
    on<DeleteCar>(_onDeleteCar);
    on<FetchCarById>(_onFetchCarById);
    on<LoadUserAndCars>(_onLoadUserAndCars);
    on<UpdateProfile>(_onUpdateProfile);
    on<UpdatePassword>(_onUpdatePassword);
  }

  Future<void> _onLoadUserAndCars(
      LoadUserAndCars event, Emitter<SettingState> emit) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    String token = prefs.getString('token')!;

    emit(SettingLoading());

    try {
      final userResponse = await http.get(
        Uri.parse('$baseUrl/profile/cars'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );
      final responseJson = json.decode(userResponse.body);

      if (userResponse.statusCode == 200) {
        final Map<String, dynamic> userJson = json.decode(userResponse.body);
        final profile = Profile_data.fromJson(userJson);

        final cars = profile.cars
            .map<car_data>((car) => car_data.fromJson(car.toJson()))
            .toList();
        emit(UserAndCarsLoaded(profile: profile, cars: cars));
      } else {
        emit(SettingError(message: responseJson['message']));
      }
    } catch (e) {
      emit(SettingError(message: e.toString()));
    }
  }

  //--------------------------------------------------------------------------------

  // ignore: non_constant_identifier_names
  Future<car_data> fetch_cars(String carId) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token')!;
    final response =
        await http.get(Uri.parse('$baseUrl/cars/id/$carId'), headers: {
      'Content-Type': 'application/json',
      'Authorization': 'Bearer $token',
    });

    final responseJson = json.decode(response.body);
    if (response.statusCode == 200) {
      final car = car_data.fromJson(responseJson['data']);
      return car;
    } else {
      throw responseJson['message'];
    }
  }

  Future<void> _onFetchCarById(
      FetchCarById event, Emitter<SettingState> emit) async {
    emit(SettingLoading());
    try {
      final car = await fetch_cars(event.carId);

      emit(CarLoaded(car: car));
    } catch (e) {
      emit(SettingError(message: e.toString()));
    }
  }

  Future<void> _onAddCar(AddCar event, Emitter<SettingState> emit) async {
    emit(SettingLoading());
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token')!;
    try {
      final url = Uri.parse('$baseUrl/cars');
      var request = http.MultipartRequest('POST', url);
      request.fields['license_plate'] = event.plate;
      request.fields['car_model'] = event.model;
      request.fields['car_type'] = event.type;

      request.files.add(await http.MultipartFile.fromPath(
        'image',
        event.imageFile.path,
        contentType: MediaType('image', 'jpeg'),
      ));
      request.headers.addAll({
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      });

      var response = await request.send();
      final responseBody = await response.stream.bytesToString();
      final responseJson = json.decode(responseBody);

      if (response.statusCode == 200) {
        if (responseJson.containsKey('data') && responseJson['data'] != null) {
          final car = car_data.fromJson(responseJson['data']);
          final currentState = state;

          if (currentState is SettingLoaded) {
            final updatedCars = List<car_data>.from(currentState.cars)
              ..add(car);
            emit(SettingLoaded(cars: updatedCars));
          } else {
            add(LoadUserAndCars());
          }
          emit(SettingSuccess(message: responseJson['message']));
        } else {
          emit(SettingError(message: 'Error: ${responseJson['message']}'));
        }
      } else {
        String errorMessage = responseJson['message'];
        emit(SettingError(message: errorMessage));
      }
    } catch (e) {
      emit(SettingError(message: 'Error: ${e.toString()}'));
    }
  }

  Future<void> _onUpdateCar(UpdateCar event, Emitter<SettingState> emit) async {
    emit(SettingLoading());
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();
      final String token = prefs.getString('token')!;
      final url = Uri.parse('$baseUrl/cars/id/${event.id}');
      var request = http.MultipartRequest('PUT', url);
      request.fields['license_plate'] = event.plate;
      request.fields['car_model'] = event.model;
      request.fields['car_type'] = event.type;
      request.headers.addAll({
        'Content-Type': 'application/json',
        'Authorization': 'Bearer $token',
      });
      if (event.imageFile != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'image',
          event.imageFile!.path,
          contentType: MediaType('image', 'jpeg'),
        ));
      }
      var response = await request.send();
      final responseBody = await response.stream.bytesToString();
      final responseJson = json.decode(responseBody);

      if (response.statusCode == 200) {
        add(LoadUserAndCars());
        emit(SettingSuccess(message: responseJson['message']));
      } else {
        emit(SettingError(message: responseJson['message']));
      }
    } catch (e) {
      emit(SettingError(message: 'Error: ${e.toString()}'));
    }
  }

  Future<void> _onDeleteCar(DeleteCar event, Emitter<SettingState> emit) async {
    emit(SettingLoading());
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token')!;
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/cars/id/${event.id}'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      final responseJson = json.decode(response.body);
      if (response.statusCode == 200) {
        add(LoadUserAndCars());
        emit(SettingSuccess(message: responseJson['message']));
      } else {
        emit(SettingError(message: responseJson['message']));
      }
    } catch (e) {
      emit(SettingError(message: 'Error: ${e.toString()}'));
    }
  }

  //--------------------------------------------------------------------------------

  Future<void> _onUpdateProfile(
      UpdateProfile event, Emitter<SettingState> emit) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token')!;
    emit(UserLoading());
    
    try {
      final url = Uri.parse('$baseUrl/profile');
      final request = http.MultipartRequest('PUT', url)
        ..headers.addAll({
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        });
      request.fields['name'] = event.name;
      request.fields['surname'] = event.surname;
      request.fields['phone'] = event.phone;
      if (event.imageFile != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'image',
          event.imageFile!.path,
          contentType: MediaType('image', 'jpeg'),
        ));
      }

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();
      final responseJson = json.decode(responseBody);

      if (response.statusCode == 200) {
        add(LoadUserAndCars());
        emit(SettingSuccess(message: responseJson['message']));
      } else {
        throw responseJson['message'];
      }
    } catch (e) {
      emit(SettingError(message: 'Error: ${e.toString()}'));
    }
  }

  Future<void> _onUpdatePassword(
      UpdatePassword event, Emitter<SettingState> emit) async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    final String token = prefs.getString('token')!;
    emit(SettingLoading());
    try {
      final url = Uri.parse('$baseUrl/profile/reset_password');
      final request = http.MultipartRequest('PUT', url)
        ..headers.addAll({
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        });

      request.fields['old_password'] = event.oldPassword;
      request.fields['new_password'] = event.newPassword;
      request.fields['confirm_password'] = event.confirm_password;

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();
      final responseJson = json.decode(responseBody);

      if (response.statusCode == 200) {
        add(LoadUserAndCars());
        emit(EditSuccess(message: responseJson['message']));
      } else {
        log(responseJson.toString());
        add(LoadUserAndCars());
        emit(EditError(message: responseJson['message']));
      }
    } catch (e) {
      log(e.toString());
      emit(SettingError(message: 'Error: ${e.toString()}'));
    }
  }
}
