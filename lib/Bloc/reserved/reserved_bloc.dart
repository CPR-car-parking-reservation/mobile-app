import 'package:bloc/bloc.dart';
import 'package:car_parking_reservation/history.dart';
import 'package:car_parking_reservation/model/history.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter/cupertino.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

part 'reserved_event.dart';
part 'reserved_state.dart';

class ReservedBloc extends Bloc<ReservedEvent, ReservedState> {
  ReservedBloc() : super(ReservedInitial()) {
    on<FectchFirstReserved>((event, emit) async {
      emit(ReserveLoading());
      try {
        final history = await fetchData();
        emit(ReservedLoaded(history));
      } catch (e) {
        emit(ReservedError("Failed  to load data!"));
      }
    });

    // on<SendReservation>((event, emit) {
    //   if (state is ReservedLoaded) {
    //     final currentList =
    //         List<History_data>.from((state as ReservedLoaded).history);
    //     currentList.add(event.history);
    //     emit(ReservedLoaded(currentList));
    //   } else {
    //     emit(ReservedLoaded([event.history]));
    //   }
    // });

    on<SendReservation>((event, emit) async {
      // emit(ReserveLoading());
      try {
        final success = await postData(event.history);
        if (success) {
          debugPrint("Data posted successfully");

          // if (state is ReservedLoaded) {
          //   final currentList =
          //       List<History_data>.from((state as ReservedLoaded).history);
          //   currentList.add(event.history);
          //   emit(ReservedLoaded(currentList));
          // } else {
          //   emit(ReservedLoaded([event.history]));
          // }
        } else {
          emit(ReservedError("Failed to post data to server."));
        }
      } catch (e) {
        emit(ReservedError(e.toString()));
      }
    });

    on<FetchAllReservation>((event, emit) async {
      emit(ReserveLoading()); // แสดง Loading Indicator ขณะดึงข้อมูล
      try {
        final history =
            await fetchData(); // เรียกใช้ API เพื่อดึงข้อมูลจาก Database
        emit(ReservedLoaded(
            history)); // อัปเดต State เพื่อให้แสดงข้อมูลในหน้า History
        debugPrint("Fetched data from database successfully");
      } catch (e) {
        emit(ReservedError("Failed to load data from server!"));
        debugPrint("Error fetching data: $e");
      }
    });
  }

  Future<List<History_data>> fetchData() async {
    String strUrl = 'https://names-celebrity-web-round.trycloudflare.com';
    debugPrint('url: $strUrl');
    final response = await http.get(Uri.parse("$strUrl/reservation"), headers: {
      "Accept": "application/json",
      "content-type": "application/json",
    });

    if (response.statusCode == 200) {
      // List<dynamic> data = jsonDecode(response.body);  // ok
      List data = json.decode(response.body); // ok

      return data
          .map((e) => History_data.fromJson(e))
          .toList(); // use method in class
    } else {
      debugPrint('failed loading');
      throw Exception('Failed to load data!');
    }
  }

  Future<bool> postData(History_data reservation) async {
    String strUrl = 'https://names-celebrity-web-round.trycloudflare.com';
    debugPrint('url: $strUrl');
    final response = await http.post(
      Uri.parse("$strUrl/reservation"),
      headers: {
        "Accept": "application/json",
        "content-type": "application/json",
      },
      body: jsonEncode(
        reservation.toJson(),
      ),
    );
    // Debug: แสดงผลลัพธ์ที่ได้จาก server
    debugPrint("POST response status: ${response.statusCode}");
    debugPrint("POST response body: ${response.body}");

    if (response.statusCode == 201) {
      return true;
    } else {
      debugPrint('failed posting');
      throw Exception('Failed to post data!');
    }
  }
}
