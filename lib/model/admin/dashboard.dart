import 'dart:convert';

import 'package:car_parking_reservation/model/car.dart';

class ModelGraph {
  final day;
  final data_number;

  ModelGraph({
    required this.day,
    required this.data_number,
  });

  factory ModelGraph.fromJson(Map<String, dynamic> json) {
    return ModelGraph(
      day: json["day"],
      data_number: json["data_number"],
    );
  }
}

class ModelDashboard {
  final int idle;
  final int full;
  final int reserved;
  final int maintenance;
  final int total_user;
  final total_cash;

  ModelDashboard({
    required this.idle,
    required this.full,
    required this.reserved,
    required this.maintenance,
    required this.total_user,
    required this.total_cash,
  });

  factory ModelDashboard.fromJson(Map<String, dynamic> json) {
    return ModelDashboard(
      idle: json["idle"],
      full: json["full"],
      reserved: json["reserved"],
      maintenance: json["maintenance"],
      total_user: json["total_user"],
      total_cash: json["total_cash"],
    );
  }
}
