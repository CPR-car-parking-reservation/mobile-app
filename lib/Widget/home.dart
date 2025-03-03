// ignore_for_file: deprecated_member_use

import 'package:car_parking_reservation/Bloc/setting/setting_bloc.dart';
import 'package:car_parking_reservation/Qr-generator/qr_code.dart';
import 'package:car_parking_reservation/Widget/parking_slots.dart';
import 'package:car_parking_reservation/bloc/navigator/navigator_bloc.dart';
import 'package:car_parking_reservation/bloc/parking/parking_bloc.dart';
import 'package:car_parking_reservation/history.dart';
import 'package:car_parking_reservation/reserv.dart';
import 'package:car_parking_reservation/setting/setting_page.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Home extends StatelessWidget {
  const Home({super.key});

  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<NavigatorBloc, NavigatorBlocState>(
      builder: (context, state) {
        if (state is NavigatorBlocStateInitial) {
          return Scaffold(
            appBar: AppBar(
              backgroundColor: const Color(0xFF03174C),
              automaticallyImplyLeading: false,
              title: Row(
                mainAxisAlignment: MainAxisAlignment.end,
                children: [
                  Image.asset(
                    "assets/images/LogoCARPAKING.png",
                    height: 40,
                    width: 90,
                  ),
                ],
              ),
            ),
            body: Center(
              child: () {
                switch (state.index) {
                  case 0:
                    return BlocProvider(
                      create: (context) => ParkingBloc(),
                      child: ParkingSlots(),
                    );
                  case 1:
                    return GenQR();
                  case 2:
                    return History();
                  case 3:
                    return BlocProvider(
                        create: (context) => SettingBloc(), child: Setting());
                  default:
                    return SizedBox.shrink();
                }
              }(),
            ),
            bottomNavigationBar: Container(
                decoration: BoxDecoration(
                  boxShadow: [
                    BoxShadow(
                      // ignore: deprecated_member_us
                      color: Colors.black.withOpacity(0.5),
                      spreadRadius: 5,
                      blurRadius: 7,
                      offset: const Offset(0, 3),
                    ),
                  ],
                ),
                child: BottomNavigationBar(
                  type: BottomNavigationBarType.fixed,
                  backgroundColor: const Color(0xFF03174C),
                  selectedItemColor: Colors.red,
                  unselectedItemColor: Colors.white,
                  items: const <BottomNavigationBarItem>[
                    BottomNavigationBarItem(
                        icon: Icon(Icons.local_parking), label: 'Parking'),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.qr_code), label: 'QR Code'),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.history), label: 'History'),
                    // BottomNavigationBarItem(
                    //     icon: Icon(Icons.history), label: 'Reserved'),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.settings), label: 'Setting'),
                  ],
                  currentIndex: state.index,
                  onTap: (index) {
                    context
                        .read<NavigatorBloc>()
                        .add(ChangeIndex(index: index));
                  },
                )),
          );
        }
        return const SizedBox();
      },
    );
  }
}
