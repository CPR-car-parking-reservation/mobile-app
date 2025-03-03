
class ModelParkingSlot {
  final String id;
  final String slotNumber;
  final String status;
  final String createdAt;
  final String updatedAt;
  final String floorId;
  final ModelFloor floor;

  ModelParkingSlot({
    required this.id,
    required this.slotNumber,
    required this.status,
    required this.createdAt,
    required this.updatedAt,
    required this.floorId,
    required this.floor,
  });

  factory ModelParkingSlot.fromJson(Map<String, dynamic> json) {
    return ModelParkingSlot(
      id: json["id"],
      slotNumber: json["slot_number"],
      status: json["status"],
      createdAt: json["created_at"],
      updatedAt: json["updated_at"],
      floorId: json["floor_id"],
      floor: ModelFloor.fromJson(json["floor"]),
    );
  }
}

class ModelFloor {
  final String id;
  final String floorNumber;
  final String createdAt;
  final String updatedAt;

  ModelFloor({
    required this.id,
    required this.floorNumber,
    required this.createdAt,
    required this.updatedAt,
  });

  factory ModelFloor.fromJson(Map<String, dynamic> json) {
    return ModelFloor(
      id: json["id"],
      floorNumber: json["floor_number"],
      createdAt: json["created_at"],
      updatedAt: json["updated_at"],
    );
  }
}
