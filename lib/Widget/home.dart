import 'package:car_parking_reservation/Bloc/reserved/reserved_bloc.dart';
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

  static const List<Widget> _widgetOptions = <Widget>[
    ParkingSlots(),
    GenQR(),
    // Reserv(),
    History(),
    Setting(),
  ];

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<NavigatorBloc>(
          create: (context) => NavigatorBloc(),
        ),
        BlocProvider<ReservedBloc>(
          create: (context) => ReservedBloc(),
        ),
        BlocProvider<ParkingBloc>(
          create: (context) => ParkingBloc( )..add(OnFirstParkingSlot()),
        ),
        
      ],
      child: Scaffold(
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
        body: BlocBuilder<NavigatorBloc, NavigatorBlocState>(
          builder: (context, state) {
            if (state is NavigatorBlocStateUpdate) {
              return Center(
                child: _widgetOptions.elementAt(state.index),
              );
            }
            // กรณี state เริ่มต้น แสดงหน้าแรก
            return Center(
              child: _widgetOptions.elementAt(0),
            );
          },
        ),
        bottomNavigationBar: Container(
          height: 75,
          decoration: const BoxDecoration(
            boxShadow: [
              BoxShadow(color: Colors.black45, spreadRadius: 3, blurRadius: 10),
            ],
          ),
          child: BlocBuilder<NavigatorBloc, NavigatorBlocState>(
            builder: (context, state) {
              if (state is NavigatorBlocStateUpdate ||
                  state is NavigatorBlocStateInitial) {
                return BottomNavigationBar(
                  type: BottomNavigationBarType.fixed,
                  backgroundColor: const Color(0xFF03174C),
                  selectedItemColor: Colors.white,
                  unselectedItemColor: Colors.grey[400],
                  items: const <BottomNavigationBarItem>[
                    BottomNavigationBarItem(
                      icon: Icon(Icons.home),
                      label: 'Home',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.qr_code),
                      label: 'QR Code',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.history),
                      label: 'History',
                    ),
                    BottomNavigationBarItem(
                      icon: Icon(Icons.manage_accounts_rounded),
                      label: 'Setting',
                    ),
                  ],
                  // ใช้ค่า index จาก state
                  currentIndex:
                      state is NavigatorBlocStateUpdate ? state.index : 0,
                  onTap: (value) {
                    context
                        .read<NavigatorBloc>()
                        .add(ChangeIndex(index: value));
                  },
                );
              }
              return const CircularProgressIndicator();
            },
          ),
        ),
      ),
    );
  }
}
