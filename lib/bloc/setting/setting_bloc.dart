import 'dart:async';
import 'dart:convert';
import 'dart:developer';
import 'package:bloc/bloc.dart';
import 'package:car_parking_reservation/model/car.dart';
import 'package:http/http.dart' as http;
import 'setting_event.dart';
import 'setting_state.dart';
// ignore: depend_on_referenced_packages
import 'package:http_parser/http_parser.dart';

class Profile {
  final String name;
  final String phone;
  final String avatar;

  Profile({required this.name, required this.phone, required this.avatar});
}

class SettingBloc extends Bloc<SettingEvent, SettingState> {
  
  static const String baseUrl = 'https://legend-trees-tee-shed.trycloudflare.com';

  SettingBloc() : super(SettingInitial()) {
    on<LoadCars>(_onLoadCars);
    on<AddCar>(_onAddCar);
    on<UpdateCar>(_onUpdateCar);
    on<DeleteCar>(_onDeleteCar); 
    on<FetchCarById>(_onFetchCarById);
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

  Future<void> _onLoadCars(LoadCars event, Emitter<SettingState> emit) async {
    
    emit(SettingLoading()); 
    
    try {
      final response = await http.get(Uri.parse('$baseUrl/cars'));

      if (response.statusCode == 200 || response.statusCode == 201) {
        final Map<String, dynamic> responseJson = json.decode(response.body);
        final List<dynamic> carsList = responseJson['data'];
        final cars = carsList.map((carJson) => car_data.fromJson(carJson)).toList();
        emit(SettingLoaded(cars: cars));
      } else {
        emit(SettingError(message: 'Error fetching data'));
      }
    } catch (e) {
      emit(SettingError(message: e.toString()));
    }
  }
  
  Future<void> _onFetchCarById(FetchCarById event, Emitter<SettingState> emit) async {
    
    emit(SettingLoading());
    try {
      final car = await fetch_cars(event.carId);
      emit(SettingLoaded(cars: [car]));
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
      request.fields['user_id'] = '8c87ff0d-d848-4892-af21-2c53950a539e'; 
      request.files.add(await http.MultipartFile.fromPath(
        'image',
        event.imageFile.path,
        contentType: MediaType('image', 'jpeg'),
      ));

      var response = await request.send();
      final responseBody = await response.stream.bytesToString();

      final responseJson = json.decode(responseBody);

      if (response.statusCode == 201) {
        if (responseJson.containsKey('data') && responseJson['data'] != null) {
          final car = car_data.fromJson(responseJson['data']);
          final currentState = state;

          if (currentState is SettingLoaded) {
            final updatedCars = List<car_data>.from(currentState.cars)..add(car);
            emit(SettingLoaded(cars: updatedCars));
          } else {
            add(LoadCars());
          }
          emit(SettingSuccess(message: responseJson['message'] ));
        } else {
          emit(SettingError(message: 'An error : The returned data is invalid.'));
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

    // Log the request fields and files for debugging
    log('Request fields: ${request.fields}');
    log('Request files: ${request.files.map((file) => file.filename).toList()}');

    var response = await request.send();
    final responseBody = await response.stream.bytesToString();

    if (response.statusCode == 200) {
      add(LoadCars());
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
        add(LoadCars());
        emit(SettingSuccess(message: 'Deleted successfully!'));
      } else {
        emit(SettingError(message: 'Failed to delete car: ${response.body}'));
      }
    } catch (e) {
      emit(SettingError(message: 'Error: ${e.toString()}'));
    }
  }
}