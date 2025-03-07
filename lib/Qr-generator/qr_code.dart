import 'dart:developer';

import 'package:car_parking_reservation/Widget/custom_dialog.dart';
import 'package:car_parking_reservation/bloc/navigator/navigator_bloc.dart';
import 'package:car_parking_reservation/bloc/reserved/reserved_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GenQR extends StatefulWidget {
  final String? reservationId;
  const GenQR({super.key, this.reservationId});

  @override
  State<GenQR> createState() => _GenQRState();
}

class _GenQRState extends State<GenQR> {
  late String reservationId;

  @override
  void initState() {
    super.initState();
    reservationId = widget.reservationId ?? "";
    _loadReservationId();
  }

  void _loadReservationId() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      reservationId =
          prefs.getString('reservation_id') ?? "Not found reservation id";
    });
    log("Reservation ID: $reservationId");
  }

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ReservedBloc, ReservedState>(
      listener: (context, state) {
        if (state is ReservedSuccess) {
          // Fetch หน้าใหม่เมื่อสถานะเป็น ReservedSuccess
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(
                builder: (context) => GenQR(reservationId: reservationId)),
          );
        }
        if (state is ReservationCancelled) {
          // แสดงข้อความแสดงข้อผิดพลาดเมื่อสถานะเป็น ReservedError
          context.read<NavigatorBloc>().add(ChangeIndex(index: 0));

          showCustomDialogSucess(context, "Cancel Reserved");
        } else if (state is ReservedError) {
          // แสดงข้อความแสดงข้อผิดพลาดเมื่อสถานะเป็น ReservedError
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      builder: (context, state) {
        return Scaffold(
          backgroundColor: const Color(0xFF03174C),
          body: Center(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                const Text(
                  "Scan QR Code",
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 28,
                    fontFamily: "Amiko",
                    fontWeight: FontWeight.w700,
                  ),
                ),
                const SizedBox(height: 10),
                if (reservationId.isNotEmpty)
                  Column(
                    children: [
                      QrImageView(
                        data: reservationId,
                        version: QrVersions.auto,
                        size: 250.0,
                        backgroundColor: Colors.white,
                      ),
                      SizedBox(height: 10),
                      Text(
                        reservationId,
                        style: const TextStyle(color: Colors.white),
                      ),
                      SizedBox(height: 20),
                      ElevatedButton(
                        // Button to cancel reservation
                        onPressed: () {
                          if (reservationId.isNotEmpty) {
                            context
                                .read<ReservedBloc>()
                                .add(CancelReservation(reservationId));
                          }
                        },
                        child: Text(
                          "Cancel Reserved",
                          style: TextStyle(
                              color: Colors.white,
                              fontSize: 20,
                              fontWeight: FontWeight.w700,
                              fontFamily: "Amiko"),
                        ),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                        ),
                      ),
                    ],
                  )
                else if (state is ReservationCancelled)
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.check_circle, color: Colors.green, size: 28),
                      SizedBox(height: 10),
                      Text(
                        state.message,
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  )
                else
                  Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(Icons.error, color: Colors.red, size: 28),
                      SizedBox(height: 10),
                      Text(
                        "Not found reservation id",
                        style: TextStyle(color: Colors.white),
                      ),
                    ],
                  ),
              ],
            ),
          ),
        );
      },
    );
  }
}
