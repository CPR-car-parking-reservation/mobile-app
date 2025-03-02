import 'dart:async';
import 'dart:convert';
import 'package:bloc/bloc.dart';
import 'package:car_parking_reservation/model/car.dart';
import 'package:car_parking_reservation/model/profile.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;
import 'setting_event.dart';
import 'setting_state.dart';
// ignore: depend_on_referenced_packages
import 'package:http_parser/http_parser.dart';

class SettingBloc extends Bloc<SettingEvent, SettingState> {
  final String? baseUrl = dotenv.env['BASE_URL'];
  final String userId = '93eb832a-d699-441b-bde7-f279bbbb9d50';
  final String token =
      'eyJhbGciOiJIUzI1NiJ9.eyJpZCI6IjkzZWI4MzJhLWQ2OTktNDQxYi1iZGU3LWYyNzliYmJiOWQ1MCIsImV4cCI6MTc0MDk5MTE0OX0.0pKwjndqpbW7QnyBYMGqTwvZUap9z_C_wvCKVpthL_U';

  SettingBloc() : super(SettingInitial()) {
    on<LoadCars>(_onLoadCars);
    on<AddCar>(_onAddCar);
    on<UpdateCar>(_onUpdateCar);
    on<DeleteCar>(_onDeleteCar);
    on<FetchCarById>(_onFetchCarById);
    on<LoadUserAndCars>(_onLoadUserAndCars);
    on<LoadUser>(_onLoadUser);
    on<UpdateProfile>(_onUpdateProfile);
    on<UpdatePassword>(_onUpdatePassword);
  }

  Future<void> _onLoadUserAndCars(
      LoadUserAndCars event, Emitter<SettingState> emit) async {
    emit(SettingLoading());

    try {
      final userResponse = await http.get(
        Uri.parse('$baseUrl/profile/cars'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (userResponse.statusCode == 200) {
        final Map<String, dynamic> userJson = json.decode(userResponse.body);
        final profile = Profile_data.fromJson(userJson);

        final cars = profile.cars
            .map<car_data>((car) => car_data.fromJson(car.toJson()))
            .toList();
        emit(UserAndCarsLoaded(profile: profile, cars: cars));
      } else {
        emit(SettingError(message: 'Error fetching user or car data'));
      }
    } catch (e) {
      emit(SettingError(message: e.toString()));
    }
  }

  Future<void> _onLoadUser(LoadUser event, Emitter<SettingState> emit) async {
    emit(SettingLoading());

    try {
      final userResponse = await http.get(
        Uri.parse('$baseUrl/profile'),
        headers: {
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        },
      );

      if (userResponse.statusCode == 200) {
        final Map<String, dynamic> userJson = json.decode(userResponse.body);
        final profile = Profile_data.fromJson(userJson);

        emit(ProfileLoaded(profile: profile));
      } else {
        emit(SettingError(message: 'Error fetching user data'));
      }
    } catch (e) {
      emit(SettingError(message: e.toString()));
    }
  }

  Future<void> _onLoadCars(LoadCars event, Emitter<SettingState> emit) async {
    emit(SettingLoading());
    try {
      final response = await http
          .get(Uri.parse('$baseUrl/cars/get_cars_by_user_id/$userId'));

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> responseJson = json.decode(response.body);
        final List<dynamic>? carsList = responseJson['data'];
        if (carsList != null) {
          final cars =
              carsList.map((carJson) => car_data.fromJson(carJson)).toList();
          emit(SettingLoaded(cars: cars));
        } else {
          emit(SettingLoaded(cars: [])); // Handle case where data is null
        }
      } else {
        emit(SettingError(message: 'Error fetching car data'));
      }
    } catch (e) {
      emit(SettingError(message: e.toString()));
    }
  }

  // ignore: non_constant_identifier_names
  Future<car_data> fetch_cars(String carId) async {
    final response = await http.get(Uri.parse('$baseUrl/cars/id/$carId'));

    if (response.statusCode == 200) {
      final Map<String, dynamic> responseJson = json.decode(response.body);
      final List<dynamic> carsList = responseJson['data'];
      return car_data.fromJson(carsList[0]);
    } else {
      throw Exception('error fetching data');
    }
  }

  Future<void> _onFetchCarById(
      FetchCarById event, Emitter<SettingState> emit) async {
    emit(SettingLoading());
    try {
      final car = await fetch_cars(event.carId);
      emit(SettingLoaded(cars: [car]));
      add(LoadUserAndCars());
    } catch (e) {
      emit(SettingError(message: e.toString()));
    }
  }

  Future<void> _onAddCar(AddCar event, Emitter<SettingState> emit) async {
    emit(SettingLoading());
    try {
      final url = Uri.parse('$baseUrl/cars');
      var request = http.MultipartRequest('POST', url);
      request.fields['car_number'] = event.plate;
      request.fields['car_model'] = event.model;
      request.fields['car_type'] = event.type;
      request.fields['user_id'] = userId;
      request.files.add(await http.MultipartFile.fromPath(
        'image',
        event.imageFile.path,
        contentType: MediaType('image', 'jpeg'),
      ));

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
          emit(SettingError(
              message: 'An error : The returned data is invalid.'));
        }
      } else {
        String errorMessage = responseJson['message'] ?? 'Failed to add ';
        emit(SettingError(message: errorMessage));
      }
    } catch (e) {
      emit(SettingError(message: 'Error: ${e.toString()}'));
    }
  }

  Future<void> _onUpdateCar(UpdateCar event, Emitter<SettingState> emit) async {
    emit(SettingLoading());
    try {
      final url = Uri.parse('$baseUrl/cars/id/${event.id}');
      var request = http.MultipartRequest('PUT', url);
      request.fields['car_number'] = event.plate;
      request.fields['car_model'] = event.model;
      request.fields['car_type'] = event.type;
      if (event.imageFile != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'image',
          event.imageFile!.path,
          contentType: MediaType('image', 'jpeg'),
        ));
      }

      var response = await request.send();
      final responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        add(LoadUserAndCars());
        emit(SettingSuccess(message: 'Update successful!'));
      } else {
        emit(SettingError(message: 'Failed to update car: $responseBody'));
      }
    } catch (e) {
      emit(SettingError(message: 'Error: ${e.toString()}'));
    }
  }

  Future<void> _onDeleteCar(DeleteCar event, Emitter<SettingState> emit) async {
    emit(SettingLoading());
    try {
      final response = await http.delete(
        Uri.parse('$baseUrl/cars/id/${event.id}'),
      );

      if (response.statusCode == 200) {
        add(LoadUserAndCars()); // Reload user and cars data
        emit(SettingSuccess(message: 'Deleted successfully!'));
      } else {
        emit(SettingError(message: 'Failed to delete car: ${response.body}'));
      }
    } catch (e) {
      emit(SettingError(message: 'Error: ${e.toString()}'));
    }
  }

  Future<void> _onUpdateProfile(
      UpdateProfile event, Emitter<SettingState> emit) async {
    emit(SettingLoading());
    try {
      final url = Uri.parse('$baseUrl/profile');
      final request = http.MultipartRequest('PUT', url)
        ..headers.addAll({
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        });
      request.fields['name'] = event.name;
      if (event.imageFile != null) {
        request.files.add(await http.MultipartFile.fromPath(
          'image',
          event.imageFile!.path,
          contentType: MediaType('image', 'jpeg'),
        ));
      }

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        add(LoadUserAndCars());
        emit(SettingSuccess(message: 'Profile updated successfully!'));
      } else {
        emit(SettingError(message: 'Failed to update profile: $responseBody'));
      }
    } catch (e) {
      emit(SettingError(message: 'Error: ${e.toString()}'));
    }
  }

  Future<void> _onUpdatePassword(UpdatePassword event, Emitter<SettingState> emit) async {
    emit(SettingLoading());
    try {
      final url = Uri.parse('$baseUrl/profile/password');
      final request = http.MultipartRequest('PUT', url)
        ..headers.addAll({
          'Content-Type': 'application/json',
          'Authorization': 'Bearer $token',
        });
      request.fields['old_password'] = event.oldPassword;
      request.fields['new_password'] = event.newPassword;

      final response = await request.send();
      final responseBody = await response.stream.bytesToString();

      if (response.statusCode == 200) {
        emit(SettingSuccess(message: 'Password updated successfully!'));
      } else {
        emit(SettingError(message: 'Failed to update password: $responseBody'));
      }
    } catch (e) {
      emit(SettingError(message: 'Error: ${e.toString()}'));
    }
  }

  

}
