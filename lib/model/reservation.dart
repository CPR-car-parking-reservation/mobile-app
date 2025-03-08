class Reservation_Model {
  final String id;
  final String userId;
  final DateTime createdAt;
  final DateTime? startAt;
  final DateTime? endAt;
  final DateTime updatedAt;
  final price;
  final String parkingSlotId;
  final String carId;
  final ParkingSlot parkingSlot;
  final String status;
  final Car car;

  Reservation_Model({
    required this.id,
    required this.userId,
    required this.createdAt,
    this.startAt,
    this.endAt,
    required this.price,
    required this.updatedAt,
    required this.parkingSlotId,
    required this.carId,
    required this.parkingSlot,
    required this.status,
    required this.car,
  });

  factory Reservation_Model.fromJson(Map<String, dynamic> json) {
    return Reservation_Model(
      id: json['id'],
      userId: json['user_id'],
      createdAt: DateTime.parse(json['created_at']),
      startAt: json['created_at'] != null
          ? DateTime.tryParse(json['created_at'])
          : null,
      endAt: json['end_at'] != null ? DateTime.tryParse(json['end_at']) : null,
      updatedAt: DateTime.parse(json['updated_at']),
      parkingSlotId: json['parking_slot_id'],
      carId: json['car_id'],
      parkingSlot: ParkingSlot.fromJson(json['parking_slots']),
      status: json['status'],
      price: json['price'] ?? '',
      car: Car.fromJson(json['car']),
    );
  }

  Map<String, dynamic> toJson() => {
        'id': id,
        'user_id': userId,
        'created_at': createdAt.toIso8601String(),
        'start_at': startAt?.toIso8601String(),
        'end_at': endAt?.toIso8601String(),
        'updated_at': updatedAt.toIso8601String(),
        'parking_slot_id': parkingSlotId,
        'car_id': carId,
        'parking_slots': parkingSlot.toJson(),
        'car': car.toJson(),
      };
}

class ParkingSlot {
  final String id;
  final String slotNumber;
  final String status;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String floorId;

  ParkingSlot({
    required this.id,
    required this.slotNumber,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.floorId,
  });

  factory ParkingSlot.fromJson(Map<String, dynamic> json) => ParkingSlot(
        id: json['id'],
        slotNumber: json['slot_number'],
        status: json['status'],
        createdAt: DateTime.parse(json['created_at']),
        updatedAt: DateTime.parse(json['updated_at']),
        floorId: json['floor_id'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'slot_number': slotNumber,
        'status': status,
        'created_at': createdAt.toIso8601String(),
        'updated_at': updatedAt.toIso8601String(),
        'floor_id': floorId,
      };
}

class Car {
  final String id;
  final String licensePlate;
  final String carModel;
  final String carType;
  final String imageUrl;
  final DateTime createdAt;
  final DateTime updatedAt;
  final String userId;

  Car({
    required this.id,
    required this.licensePlate,
    required this.carModel,
    required this.carType,
    required this.imageUrl,
    required this.createdAt,
    required this.updatedAt,
    required this.userId,
  });

  factory Car.fromJson(Map<String, dynamic> json) => Car(
        id: json['id'],
        licensePlate: json['license_plate'],
        carModel: json['car_model'],
        carType: json['car_type'],
        imageUrl: json['image_url'],
        createdAt: DateTime.parse(json['created_at']),
        updatedAt: DateTime.parse(json['updated_at']),
        userId: json['user_id'],
      );

  Map<String, dynamic> toJson() => {
        'id': id,
        'license_plate': licensePlate,
        'car_model': carModel,
        'car_type': carType,
        'image_url': imageUrl,
        'created_at': createdAt.toIso8601String(),
        'updated_at': updatedAt.toIso8601String(),
        'user_id': userId,
      };
}
