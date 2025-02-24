import 'package:flutter/material.dart';
import '../Widget/parking_slots.dart';

class ParkingSlotsPage extends StatelessWidget {
  const ParkingSlotsPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: ParkingSlots(),
    );
  }
}