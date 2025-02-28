class History_data {
  ParkingSlot parkingSlot;
  String date;
  String start_at;
  String end_at;

  History_data({
    required this.date,
    required this.start_at,
    required this.end_at,
    required this.parkingSlot,
  });

  factory History_data.fromJson(Map<String, dynamic> json) {
    return History_data(
      date: json['date'],
      start_at: json['start_at'],
      end_at: json['end_at'],
      parkingSlot: ParkingSlot.fromJson(json['parking_slot']),
    );
  }

  Map<String, dynamic> toJson() => {
        "date": date,
        "start_at": start_at,
        "end_at": end_at,
        "parking_slot": parkingSlot.toJson(),
      };
}

class ParkingSlot {
  String id;
  String slot_number;
  String status;
  String floorId;
  Floor floor;

  ParkingSlot({
    required this.id,
    required this.slot_number,
    required this.status,
    required this.floorId,
    required this.floor,
  });

  factory ParkingSlot.fromJson(Map<String, dynamic> json) => ParkingSlot(
        id: json["id"],
        slot_number: json["slot_number"],
        status: json["status"],
        floorId: json["floor_id"],
        floor: Floor.fromJson(json['floor']),
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "slot_number": slot_number,
        "status": status,
        "floor_id": floorId,
        "floor": floor.toJson(),
      };
}

class Floor {
  String id;
  String floor_number;

  Floor({
    required this.id,
    required this.floor_number,
  });

  factory Floor.fromJson(Map<String, dynamic> json) => Floor(
        id: json["id"],
        floor_number: json["floor_number"],
      );

  Map<String, dynamic> toJson() => {
        "id": id,
        "floor_number": floor_number,
      };
}
