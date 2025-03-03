import 'package:car_parking_reservation/Bloc/reserved/reserved_bloc.dart';
import 'package:car_parking_reservation/Qr-generator/qr_code.dart';
import 'package:car_parking_reservation/Widget/parking_slots.dart';
import 'package:car_parking_reservation/bloc/navigator/navigator_bloc.dart';
import 'package:car_parking_reservation/bloc/parking/parking_bloc.dart';
import 'package:car_parking_reservation/history.dart';
import 'package:car_parking_reservation/reserv.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Home extends StatelessWidget {
  Home({super.key});

  static const TextStyle optionStyle =
      TextStyle(fontSize: 30, fontWeight: FontWeight.bold);

  static const List<Widget> _widgetOptions = <Widget>[
    ParkingSlots(),
    GenQR(),
    // Reserv(),
    History(),
  ];

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
                child: IndexedStack(
                  index: state.index,
                  children: [
                    BlocProvider(
                      create: (context) => ParkingBloc(),
                      child: ParkingSlots(),
                    ),
                    GenQR(),
                    History(),
                    Setting(),
                    // BlocProvider(
                    //   create: (context) => ReservedBloc(),
                    //   child: Reserv(),
                    // ),
                  ],
                ),
              ),
              bottomNavigationBar: BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                backgroundColor: const Color(0xFF03174C),
                selectedItemColor: const Color.fromARGB(255, 231, 232, 236),
                unselectedItemColor: const Color.fromARGB(128, 255, 148, 60),
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
                  context.read<NavigatorBloc>().add(ChangeIndex(index: index));
                },
              ));
        }
        return const SizedBox();
      },
    );
  }
}
