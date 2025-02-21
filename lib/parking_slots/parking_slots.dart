import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

class ParkingSlotService {
  static List<Map<String, dynamic>> floorParkSlot = [];
}

class ParkingSlots extends StatefulWidget {
  const ParkingSlots({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ParkingSlots createState() => _ParkingSlots();
}

class _ParkingSlots extends State<ParkingSlots> {
  String selectedFloor = "F1";
  static const String baseUrl =
      "https://switzerland-matrix-postage-serbia.trycloudflare.com";

  @override
  void initState() {
    super.initState();
    fetchAndSetSlots();
  }

  /// โหลดข้อมูลจาก API และเก็บไว้ใน `floorParkSlot`
  Future<void> fetchAndSetSlots() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/parking_slots'));
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseJson = json.decode(response.body);
        final List<dynamic> parkingSlotList = responseJson['data'];

        setState(() {
          ParkingSlotService.floorParkSlot = parkingSlotList.map((slot) {
            return {
              "id": slot["id"],
              "slot_number": slot["slot_number"],
              "status": slot["status"],
              "floor_number": slot["floor"]["floor_number"],
            };
          }).toList();
        });
      } else {
        throw Exception('Failed to load data!');
      }
    } catch (error) {
      debugPrint("Error fetching slots: $error");
    }
  }

  /// ดึงข้อมูลที่ตรงกับชั้นที่เลือก
  List<Map<String, dynamic>> getFilteredSlots() {
    return ParkingSlotService.floorParkSlot
        .where((slot) => slot["floor_number"] == selectedFloor)
        .toList();
  }

  /// เปลี่ยนชั้นของที่จอดรถ
  void changeFloor(bool next) {
    List<String> floors = ParkingSlotService.floorParkSlot
        .map((slot) => slot["floor_number"] as String)
        .toSet()
        .toList();
    int currentIndex = floors.indexOf(selectedFloor);

    if (next && currentIndex < floors.length - 1) {
      setState(() {
        selectedFloor = floors[currentIndex + 1];
      });
    } else if (!next && currentIndex > 0) {
      setState(() {
        selectedFloor = floors[currentIndex - 1];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> slots = getFilteredSlots();
    List<String> floors = ParkingSlotService.floorParkSlot
        .map((slot) => slot["floor_number"] as String)
        .toSet()
        .toList();
    List<List<Map<String, dynamic>>> leftSlots = [];
    List<List<Map<String, dynamic>>> rightSlots = [];

    for (var slot in slots) {
      if (leftSlots.isEmpty || leftSlots.last.length < 3) {
        if (leftSlots.isEmpty || leftSlots.last.length >= 3) {
          leftSlots.add([]);
        }
        leftSlots.last.add(slot);
      } else {
        if (rightSlots.isEmpty || rightSlots.last.length >= 3) {
          rightSlots.add([]);
        }
        rightSlots.last.add(slot);
      }
    }

    return Stack(
      children: [
        Column(
          children: [
            Text(
              'Parking Zone: $selectedFloor',
              style: const TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Amiko"),
            ),
            const Divider(
                color: Colors.white,
                thickness: 1.5,
                indent: 100,
                endIndent: 100),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/images/parkzone.png"),
                      fit: BoxFit.cover),
                ),
              ),
            ),
          ],
        ),
        Positioned(
          left: 20,
          top: MediaQuery.of(context).size.height * 0.29,
          child: Column(
            children: leftSlots
                .map((column) => Column(
                    children: column.reversed.map(buildParkingButton).toList()))
                .toList(),
          ),
        ),
        Positioned(
          right: 20,
          top: MediaQuery.of(context).size.height * 0.29,
          child: Column(
            children: rightSlots
                .map((column) => Column(
                    children: column.reversed.map(buildParkingButton).toList()))
                .toList(),
          ),
        ),
        Padding(
            padding: const EdgeInsets.all(10.0),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.end,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    if(floors.indexOf(selectedFloor) == 0)
                      const SizedBox(width: 50),
                    if (floors.indexOf(selectedFloor) > 0)
                      FloatingActionButton(
                        onPressed: () => changeFloor(false),
                        child: const Icon(Icons.arrow_back_ios),
                      ),
                    if (floors.indexOf(selectedFloor) < floors.length - 1)
                      FloatingActionButton(
                        onPressed: () => changeFloor(true),
                        child: const Icon(Icons.arrow_forward_ios),
                      ),
                  ],
                ),
              ],
            ))
      ],
    );
  }

  /// 🔹 ปุ่มแสดงสถานะของที่จอดรถ
  static Widget buildParkingButton(Map<String, dynamic> parking) {
    return Column(
      children: [
        SizedBox(
          width: 135,
          height: 72,
          child: FloatingActionButton(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: BorderSide(
                  style: BorderStyle.solid,
                  width: 4,
                  color: getStatusColor(parking["status"]!)),
            ),
            child: Text(
              parking["slot_number"],
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 22,
                  fontWeight: FontWeight.bold),
            ),
            onPressed: () {},
          ),
        ),
        Container(
          width: 145,
          height: 20,
          margin: const EdgeInsets.only(top: 10, bottom: 10),
          decoration: BoxDecoration(
            color: getStatusColor(parking["status"]!),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Text(
              parking["status"] ?? "Available",
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Amiko"),
            ),
          ),
        ),
      ],
    );
  }

  /// 🔹 เปลี่ยนสีตามสถานะ
  static Color getStatusColor(String status) {
    switch (status) {
      case "WORKING":
        return Colors.red;
      case "RESERVED":
        return Colors.amber;
      case "IDLE":
      default:
        return Colors.green;
    }
  }
}
