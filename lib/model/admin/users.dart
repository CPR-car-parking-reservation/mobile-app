import 'package:car_parking_reservation/model/car.dart';

class ModelUsers {
  final String id;
  final String email;
  final String name;
  final String surname;
  final String phone;
  final String image_url;
  final String role;
  final List<car_data> cars;

  ModelUsers({
    required this.id,
    required this.email,
    required this.name,
    required this.surname,
    required this.image_url,
    required this.phone,
    required this.role,
    required this.cars,
  });

  factory ModelUsers.fromJson(Map<String, dynamic> json) {
    return ModelUsers(
      id: json["id"],
      email: json["email"],
      name: json["name"],
      surname: json["surname"],
      phone: json["phone"],
      image_url: json["image_url"],
      role: json["role"],
      cars: (json["car"] as List<dynamic>)
          .map((car) => car_data.fromJson(car))
          .toList(),
    );
  }
}
