import 'dart:convert';

import 'package:car_parking_reservation/model/car.dart';

class ModelUsers {
  final String id;
  final String email;
  final String name;
  final String surname;
  final String image_url;
  final String role;
  final List<car_data> cars; // Change to List<car_data>

  ModelUsers({
    required this.id,
    required this.email,
    required this.name,
    required this.surname,
    required this.image_url,
    required this.role,
    required this.cars, // Updated field
  });

  factory ModelUsers.fromJson(Map<String, dynamic> json) {
    return ModelUsers(
      id: json["id"],
      email: json["email"],
      name: json["name"],
      surname: json["surname"],
      image_url: json["image_url"],
      role: json["role"],
      cars: (json["car"] as List<dynamic>) // Fix: Parse list of cars
          .map((car) => car_data.fromJson(car))
          .toList(),
    );
  }
}
