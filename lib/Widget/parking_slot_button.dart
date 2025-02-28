import 'package:flutter/material.dart';
import 'package:car_parking_reservation/model/parking_slot.dart';
import 'package:car_parking_reservation/Widget/home.dart';
import 'parking_slots.dart';

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
                      // builder: (context) => Home(initialIndex: 1, slot: parking),
                      builder: (context) => Home()),
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
