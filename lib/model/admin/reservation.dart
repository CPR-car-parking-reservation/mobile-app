import 'package:car_parking_reservation/model/admin/parking.dart';
import 'package:car_parking_reservation/model/admin/users.dart';

class Model_History_data {
  final String id;
  final ModelParkingSlot parking_slots;
  final DateTime created_at;
  final DateTime? end_at;
  final String status;
  final price;
  final ModelUsers user;

  Model_History_data({
    required this.id,
    required this.created_at,
    this.end_at,
    required this.parking_slots,
    required this.user,
    required this.status,
    this.price,
  });

  factory Model_History_data.fromJson(Map<String, dynamic> json) {
    return Model_History_data(
      id: json['id'],
      user: ModelUsers.fromJson(json['user']),
      price: json['price'] ?? '',
      status: json['status'],
      created_at: DateTime.parse(json['created_at']),
      end_at: json['end_at'] != null ? DateTime.parse(json['end_at']) : null,
      parking_slots: ModelParkingSlot.fromJson(json['parking_slots']),
    );
  }
}
