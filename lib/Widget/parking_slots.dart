import 'package:car_parking_reservation/model/parking_slot.dart';
import 'package:car_parking_reservation/reserv.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../Bloc/parking/parking_bloc.dart';

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
      create: (_) => ParkingBloc()..add(OnFirstParkingSlot()),
      child: BlocBuilder<ParkingBloc, ParkingState>(
        builder: (context, state) {
          if (state is ParkingInitial) {
            return const Center(
                child: CircularProgressIndicator()); // แสดงโหลดเมื่อไม่มีข้อมูล
          } else if (state is ParkingLoaded) {
            List<List<ParkingSlot>> leftSlots = [];
            List<List<ParkingSlot>> rightSlots = [];

            List<String> floors = state.parkingSlots
                .map((slot) => slot.floor.floor_number)
                .toSet()
                .toList()
              ..sort();
            List<ParkingSlot> filteredSlots =
                getFilteredSlots(state.parkingSlots);

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
                  top: MediaQuery.of(context).size.height * 0.27,
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
                  top: MediaQuery.of(context).size.height * 0.27,
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
                                  changeFloor(false, state.parkingSlots),
                              backgroundColor: Colors.white,
                              shape: const CircleBorder(),
                              child: const Icon(
                                Icons.arrow_back_ios,
                                color: Colors.black,
                              ),
                            ),
                          if (floors.indexOf(selectedFloor) < floors.length - 1)
                            FloatingActionButton(
                              onPressed: () =>
                                  changeFloor(true, state.parkingSlots),
                              backgroundColor: Colors.white,
                              shape: const CircleBorder(),
                              child: const Icon(
                                Icons.arrow_forward_ios,
                                color: Colors.black,
                              ),
                            ),
                        ],
                      ),
                    ],
                  ),
                )
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
                Navigator.push(context, MaterialPageRoute(builder: (context) {
                  return Reserv(
                    parking_slots_id: parking.id,
                    slot_number: parking.slot_number,
                    status: parking.status,
                    floor_number: parking.floor.floor_number,
                  );
                }));
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
