
import 'package:car_parking_reservation/bloc/admin_bloc/admin_parking/admin_parking_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

showDeleteParkingDialog(BuildContext context, String id, String slotNumber) {
  final bloc = context.read<AdminParkingBloc>();
  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: Colors.white,
        title: Text("Delete Parking Slot $slotNumber",
            style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
        content: Text("Are you sure you want to delete this parking slot?"),
        actions: [
          TextButton(
            onPressed: () {
              bloc.add(OnDelete(id));
              Navigator.of(context).pop();
            },
            child: const Text("Delete", style: TextStyle(fontSize: 16)),
          ),

          // ✅ ปุ่มปิด Dialog
          TextButton(
            onPressed: () => Navigator.of(context).pop(),
            child: const Text("Close", style: TextStyle(fontSize: 16)),
          ),
        ],
      );
    },
  );
}
