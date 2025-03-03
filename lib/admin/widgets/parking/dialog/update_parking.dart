import 'dart:developer';

import 'package:car_parking_reservation/bloc/admin_bloc/admin_parking/admin_parking_bloc.dart';
import 'package:car_parking_reservation/model/admin/parking.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

showUpdateParkingDialog(BuildContext context, ModelParkingSlot parking) {
  final bloc = context.read<AdminParkingBloc>();
  final state = bloc.state;
  List<ModelFloor> floors = [];
  if (state is AdminParkingLoaded) {
    floors = state.floors;
  }
  final TextEditingController _slotNumberController = TextEditingController();
  _slotNumberController.text = parking.slotNumber;
  String? selectedFloor = parking.floor.floorNumber;
  String? selectedStatus = parking.status;
  showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            backgroundColor: Colors.white,
            title: const Text(
              "Update Parking Slot",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // 🌟 Slot Number
                  const Text(
                    "Slot Number",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                  ),
                  const SizedBox(height: 5),
                  TextField(
                    controller: _slotNumberController,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 10),
                    ),
                  ),
                  const SizedBox(height: 15),

                  // 🌟 Floor Filter
                  const Text(
                    "Floor",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                  ),
                  const SizedBox(height: 5),
                  DropdownButtonFormField<String>(
                    value: selectedFloor,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 10),
                    ),
                    items: floors.map((floor) {
                      return DropdownMenuItem(
                          value: floor.floorNumber,
                          child: Text(floor.floorNumber));
                    }).toList(),
                    onChanged: (value) {
                      setState(
                          () => selectedFloor = value); // ✅ อัปเดตค่าใน Dialog
                    },
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  log("Update Parking Slot");
                  log("id : ${parking.id}");
                  bloc.add(OnUpdate(
                      selectedFloor!, _slotNumberController.text, parking.id));
                  Navigator.of(context).pop();
                },
                child: const Text("Update", style: TextStyle(fontSize: 16)),
              ),
              TextButton(
                onPressed: () => Navigator.of(context).pop(),
                child: const Text("Close", style: TextStyle(fontSize: 16)),
              ),
            ],
          );
        },
      );
    },
  );
}
