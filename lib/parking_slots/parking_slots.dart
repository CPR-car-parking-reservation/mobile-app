import 'package:car_parking_reservation/home.dart';
import 'package:car_parking_reservation/model/parking_slot.dart';
import '../parking_slots/parking_cubit.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

/// Widget หลักที่ใช้แสดงที่จอดรถทั้งหมด
class ParkingSlots extends StatefulWidget {
  const ParkingSlots({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ParkingSlots createState() => _ParkingSlots();

  // กำหนดสีของที่จอดรถตามสถานะ
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

// State ของ ParkingSlots
class _ParkingSlots extends State<ParkingSlots> {
  String selectedFloor = "F1"; // กำหนดชั้นที่เลือกเริ่มต้นเป็น F1

  // กรองเฉพาะที่จอดรถที่อยู่ในชั้นที่เลือก
  List<ParkingSlot> getFilteredSlots(List<ParkingSlot> slots) {
    return slots
        .where((slot) => slot.floor.floor_number == selectedFloor)
        .toList();
  }

  // เปลี่ยนชั้นของที่จอดรถ (ไปชั้นถัดไปหรือย้อนกลับ)
  void changeFloor(bool next, List<ParkingSlot> slots) {
    List<String> floors =
        slots.map((slot) => slot.floor.floor_number).toSet().toList();
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
    return BlocProvider(
      create: (_) => ParkingSlotCubit()..fetchAndSetSlots(),
      child: BlocBuilder<ParkingSlotCubit, List<ParkingSlot>>(
        builder: (context, slots) {
          if (slots.isEmpty) {
            return const Center(
                child: CircularProgressIndicator()); // แสดงโหลดเมื่อไม่มีข้อมูล
          }

          List<List<ParkingSlot>> leftSlots = [];
          List<List<ParkingSlot>> rightSlots = [];

          List<String> floors = slots
              .map((slot) => slot.floor.floor_number)
              .toSet()
              .toList()
            ..sort();
          List<ParkingSlot> filteredSlots = getFilteredSlots(slots);

          // จัดที่จอดรถเป็นสองฝั่ง (ซ้าย-ขวา) โดยแต่ละแถวมีไม่เกิน 3 ช่อง
          for (var slot in filteredSlots) {
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
              // แสดงที่จอดฝั่งซ้าย
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
              // แสดงที่จอดฝั่งขวา
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
              // ปุ่มเปลี่ยนชั้น (ไปชั้นก่อนหน้า/ถัดไป)
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
                              onPressed: () => changeFloor(false, slots),
                              child: const Icon(Icons.arrow_back_ios),
                            ),
                          if (floors.indexOf(selectedFloor) < floors.length - 1)
                            FloatingActionButton(
                              onPressed: () => changeFloor(true, slots),
                              child: const Icon(Icons.arrow_forward_ios),
                            ),
                        ],
                      ),
                    ],
                  ))
            ],
          );
        },
      ),
    );
  }
}

// class สำหรับปุ่มสำหรับที่จอดรถแต่ละช่อง
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
            heroTag: "btn_${parking.slot_number}", // ป้องกัน error tag ซ้ำกัน
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
                // กดแล้วไปหน้าหลัก พร้อมส่งข้อมูลช่องที่เลือกไป
                Navigator.of(context).push(
                  MaterialPageRoute(
                    builder: (context) => Home(initialIndex: 1, slot: parking),
                  ),
                );
              }
            },
          ),
        ),

        // แสดงสถานะของที่จอดรถ
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
