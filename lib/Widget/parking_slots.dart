import 'package:car_parking_reservation/model/parking_slot.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../Bloc/parking/parking_bloc.dart';
import 'parking_slot_button.dart';

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
      create: (_) => ParkingBloc()..add(FetchSlots()),
      child: BlocBuilder<ParkingBloc, ParkingState>(
        builder: (context, state) {
          if (state is ParkingInitial) {
            return const Center(
                child: CircularProgressIndicator()); // แสดงโหลดเมื่อไม่มีข้อมูล
          } else if (state is SlotsLoaded) {
            List<List<ParkingSlot>> leftSlots = [];
            List<List<ParkingSlot>> rightSlots = [];

            List<String> floors = state.slots
                .map((slot) => slot.floor.floor_number)
                .toSet()
                .toList()
              ..sort();
            List<ParkingSlot> filteredSlots = getFilteredSlots(state.slots);

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
                    Container(
                      color: Color(0xFF03174C), // Set background color to black
                      padding: const EdgeInsets.only(left: 95, right: 95),
                      child: Column(
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
                          ),
                        ],
                      ),
                    ),
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
                                onPressed: () =>
                                    changeFloor(false, state.slots),
                                child: const Icon(Icons.arrow_back_ios),
                              ),
                            if (floors.indexOf(selectedFloor) <
                                floors.length - 1)
                              FloatingActionButton(
                                onPressed: () => changeFloor(true, state.slots),
                                child: const Icon(Icons.arrow_forward_ios),
                              ),
                          ],
                        ),
                      ],
                    ))
              ],
            );
          } else if (state is ParkingError) {
            return Center(child: Text(state.message));
          }
          return Container();
        },
      ),
    );
  }
}
