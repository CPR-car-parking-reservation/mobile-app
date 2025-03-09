import 'dart:developer';

import 'package:car_parking_reservation/Bloc/qr_bloc/qr_bloc_bloc.dart';
import 'package:car_parking_reservation/Widget/custom_dialog.dart';
import 'package:car_parking_reservation/bloc/navigator/navigator_bloc.dart';
import 'package:car_parking_reservation/bloc/reserved/reserved_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GenQR extends StatefulWidget {
  const GenQR({super.key});

  @override
  State<GenQR> createState() => _GenQRState();
}

class _GenQRState extends State<GenQR> {
  late String reservationId;

  @override
  void initState() {
    super.initState();
    context.read<QrBloc>().add(FetchQr());
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ReservedBloc, ReservedState>(
      listener: (context, state) {
        if (state is ReservationCancelled) {
          showCustomDialogSucess(context, "Cancel Reserved");
          context.read<NavigatorBloc>().add(ChangeIndex(index: 0));
        }
        if (state is ReservedError) {
          showCustomDialogError(context, "Cancel Reserved Failed");
        }
      },
      child: Scaffold(
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
              BlocBuilder<QrBloc, QrBlocState>(
                builder: (context, state) {
                  log(state.toString());
                  if (state is QrBlocLoading) {
                    return Column(
                      children: [
                        SizedBox(height: 25),
                        const CircularProgressIndicator(),
                      ],
                    );
                  }
                  if (state is QrBlocLoaded) {
                    return Column(
                      children: [
                        QrImageView(
                          data: state.reservationId,
                          version: QrVersions.auto,
                          size: 250.0,
                          backgroundColor: Colors.white,
                        ),
                        SizedBox(height: 10),
                        SizedBox(height: 20),
                        ElevatedButton(
                          // Button to cancel reservation
                          onPressed: () {
                            context
                                .read<ReservedBloc>()
                                .add(CancelReservation(state.reservationId));
                          },
                          style: ElevatedButton.styleFrom(
                            backgroundColor: Colors.red,
                          ),
                          child: Text(
                            "Cancel Reserved",
                            style: TextStyle(
                                color: Colors.white,
                                fontSize: 20,
                                fontWeight: FontWeight.w700,
                                fontFamily: "Amiko"),
                          ),
                        ),
                      ],
                    );
                  }
                  if (state is QrBlocError) {
                    return Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Icon(Icons.error, color: Colors.red, size: 28),
                        SizedBox(height: 10),
                        Text(
                          "Not found reservation id",
                          style: TextStyle(color: Colors.white),
                        ),
                      ],
                    );
                  }
                  return const SizedBox(height: 10);
                },
              ),
            ],
          ),
        ),
      ),
    );
  }
}
