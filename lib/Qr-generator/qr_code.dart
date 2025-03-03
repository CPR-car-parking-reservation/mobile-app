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
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ReservedBloc, ReservedState>(
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
                if (state is ReservedSuccess && reservationId.isNotEmpty)
                  Column(
                    children: [
                      QrImageView(
                        data: reservationId,
                        version: QrVersions.auto,
                        size: 250.0,
                        backgroundColor: Colors.white,
                      ),
                      const SizedBox(height: 10),
                      Text(
                        reservationId,
                        style: const TextStyle(color: Colors.white),
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
