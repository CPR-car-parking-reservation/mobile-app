import 'dart:convert';

import 'package:bloc/bloc.dart';
import 'package:car_parking_reservation/bloc/reserved/reserved_bloc.dart';
import 'package:car_parking_reservation/model/history.dart';
import 'package:car_parking_reservation/model/reservation.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:http/http.dart' as http;

part 'history_event.dart';
part 'history_state.dart';

class HistoryBloc extends Bloc<HistoryEvent, HistoryState> {
  HistoryBloc() : super(HistoryInitial()) {
    on<FetchFirstHistory>((event, emit) async{
        emit(HistoryLoading());
    });
  }

  String baseUrl = dotenv.env['BASE_URL'].toString();
  Future<List<Reservation_Model>> fetchData() async {
    debugPrint('url: $baseUrl');
    final response = await http.get(Uri.parse("$baseUrl/reservation"), headers: {
      "Accept": "application/json",
      "content-type": "application/json",
    });

    if (response.statusCode == 200) {
      // List<dynamic> data = jsonDecode(response.body);  // ok
      List data = json.decode(response.body); // ok

      return data
          .map((e) => Reservation_Model.fromJson(e))
          .toList(); // use method in class
    } else {
      debugPrint('failed loading');
      throw Exception('Failed to load data!');
    }
  }
}
