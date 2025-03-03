import 'dart:developer';

import 'package:car_parking_reservation/bloc/admin_bloc/admin_parking/admin_parking_bloc.dart';
import 'package:car_parking_reservation/model/admin/parking.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

showFilterParkingDialog(BuildContext context) {
  final bloc = context.read<AdminParkingBloc>(); // ดึง Bloc
  final state = bloc.state;

  String? selectedFloor = "";
  String? selectedStatus = "";
  List<String> floors = [];

  if (state is AdminParkingLoaded) {
    selectedFloor = state.floor ?? "";
    selectedStatus = state.status ?? "";
    floors = state.floors.map((floor) => floor.floorNumber).toList();
    floors.insert(0, "");
  }

  showDialog(
    context: context,
    builder: (context) {
      return StatefulBuilder(
        builder: (context, setState) {
          return AlertDialog(
            backgroundColor: Colors.white,
            title: const Text(
              "Filter Options",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),
            content: SingleChildScrollView(
              child: Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
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
                          value: floor,
                          child: Text(floor == "" ? "All" : floor));
                    }).toList(),
                    onChanged: (value) {
                      setState(
                          () => selectedFloor = value); // ✅ อัปเดตค่าใน Dialog
                    },
                  ),
                  const SizedBox(height: 15),

                  // 🌟 Status Filter
                  const Text(
                    "Status",
                    style: TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
                  ),
                  const SizedBox(height: 5),
                  DropdownButtonFormField<String>(
                    value: selectedStatus,
                    decoration: InputDecoration(
                      border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(10)),
                      contentPadding:
                          const EdgeInsets.symmetric(horizontal: 10),
                    ),
                    items: const [
                      DropdownMenuItem(value: "", child: Text("All")),
                      DropdownMenuItem(value: "FULL", child: Text("FULL")),
                      DropdownMenuItem(value: "IDLE", child: Text("IDLE")),
                      DropdownMenuItem(
                          value: "RESERVED", child: Text("RESERVED")),
                    ],
                    onChanged: (value) {
                      setState(() => selectedStatus = value);
                    },
                  ),
                ],
              ),
            ),
            actions: [
              TextButton(
                onPressed: () {
                  bloc.add(OnSearch(
                      floor: selectedFloor ?? "",
                      status: selectedStatus ?? ""));
                  Navigator.of(context).pop();
                },
                child: const Text("Apply", style: TextStyle(fontSize: 16)),
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
