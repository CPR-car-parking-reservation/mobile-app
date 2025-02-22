import 'dart:convert';
import 'package:car_parking_reservation/home.dart';
import 'package:flutter/material.dart';
import '../model/parking_slot.dart';
import 'package:http/http.dart' as http;

class ParkingSlotService {
  static List<ParkingSlot> floorParkSlot = [];
}

class ParkingSlots extends StatefulWidget {
  const ParkingSlots({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ParkingSlots createState() => _ParkingSlots();

  static getStatusColor(String status) {
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

class _ParkingSlots extends State<ParkingSlots> {
  String selectedFloor = "F1";
  static const String baseUrl =
      "https://myself-gourmet-discount-cindy.trycloudflare.com";

  Future<List<ParkingSlot>> fetchAndSetSlots() async {
    try {
      final response = await http.get(Uri.parse('$baseUrl/parking_slots'));
      if (response.statusCode == 200) {
        final Map<String, dynamic> responseJson = json.decode(response.body);
        final List<dynamic> parkingSlotList = responseJson['data'];
        return parkingSlotList
            .map((slot) => ParkingSlot.fromJson(slot))
            .toList();
      } else {
        throw Exception('Failed to load data!');
      }
    } catch (error) {
      debugPrint("Error fetching slots: $error");
      return [];
    }
  }

  Future<void> reserveSlot(ParkingSlot parking) async {
    final String url = '$baseUrl/parking_slots';
    final Map<String, String> body = {
      "slot_number": parking.slot_number,
      "floor_id": parking.floor.id,
      "status": parking.status,
    };

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {"Content-Type": "application/json"},
        body: json.encode(body),
      );
      if (response.statusCode == 200) {
        debugPrint("Slot reserved successfully!");
      } else {
        debugPrint("Failed to reserve slot: ${response.body}");
      }
    } catch (error) {
      debugPrint("Error reserving slot: $error");
    }
  }

  List<ParkingSlot> getFilteredSlots() {
    return ParkingSlotService.floorParkSlot
        .where((slot) => slot.floor.floor_number == selectedFloor)
        .toList();
  }

  void changeFloor(bool next) {
    List<String> floors = ParkingSlotService.floorParkSlot
        .map((slot) => slot.floor.floor_number)
        .toSet()
        .toList();
    floors.sort();
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
    return FutureBuilder<List<ParkingSlot>>(
      future: fetchAndSetSlots(),
      builder: (context, snapshot) {
        if (snapshot.connectionState == ConnectionState.waiting) {
          return const Center(child: CircularProgressIndicator());
        } else if (snapshot.hasError) {
          return Center(child: Text("Error: ${snapshot.error}"));
        } else if (!snapshot.hasData || snapshot.data!.isEmpty) {
          return const Center(child: Text("No parking slots available"));
        }

        List<List<ParkingSlot>> leftSlots = [];
        List<List<ParkingSlot>> rightSlots = [];

        List<ParkingSlot> slots = snapshot.data!;
        List<String> floors = slots
            .map((slot) => slot.floor.floor_number)
            .toSet()
            .toList()
          ..sort();
        slots
            .where((slot) => slot.floor.floor_number == selectedFloor)
            .toList();

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
                        children: column.reversed
                            .map((slot) => ParkingSlotButton(parking: slot))
                            .toList()))
                    .toList(),
              ),
            ),
            Positioned(
              right: 20,
              top: MediaQuery.of(context).size.height * 0.29,
              child: Column(
                children: rightSlots
                    .map((column) => Column(
                        children: column.reversed
                            .map((slot) => ParkingSlotButton(parking: slot))
                            .toList()))
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
                        if (floors.indexOf(selectedFloor) == 0)
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
      },
    );
  }
}

class ParkingSlotButton extends StatelessWidget {
  final ParkingSlot parking;

  const ParkingSlotButton({required this.parking, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: 135,
          height: 72,
          child: FloatingActionButton(
            heroTag: "btn_${parking.slot_number}",
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: BorderSide(
                  width: 4, color: ParkingSlots.getStatusColor(parking.status)),
            ),
            child: Text(
              parking.slot_number,
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 22,
                  fontWeight: FontWeight.bold),
            ),
            onPressed: () {
              if (parking.status == "IDLE") {
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => Home(initialIndex: 1, slot: parking),
                  ),
                );
              }
            },
          ),
        ),
        Container(
          width: 145,
          height: 20,
          margin: const EdgeInsets.only(top: 10, bottom: 10),
          decoration: BoxDecoration(
            color: ParkingSlots.getStatusColor(parking.status),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Text(
              parking.status,
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 12,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }
}
