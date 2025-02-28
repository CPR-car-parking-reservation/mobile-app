import 'package:car_parking_reservation/admin/admin_parking.dart';
import 'package:car_parking_reservation/admin/admin_setting.dart';
import 'package:car_parking_reservation/admin/admin_users.dart';
import 'package:car_parking_reservation/admin/dashboard.dart';
import 'package:car_parking_reservation/bloc/admin_bloc/admin_navigator/admin_navigator_bloc.dart';
import 'package:car_parking_reservation/bloc/admin_bloc/admin_parking/admin_parking_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdminHomePage extends StatelessWidget {
  const AdminHomePage({super.key});
  static final List<Widget> _widgetOptions = <Widget>[
    AdminDashBoard(),
    AdminUserPage(),
    AdminParkingPage(),
    AdminSettingPage(),
  ];

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider(create: (context) => AdminNavigatorBloc()),
        BlocProvider(
            create: (context) => AdminParkingBloc()..add(OnPageLoad())),
      ],
      child: BlocBuilder<AdminNavigatorBloc, AdminNavigatorState>(
        builder: (context, state) {
          if (state is AdminNavigatorInitial) {
            return Scaffold(
              appBar: AppBar(
                automaticallyImplyLeading: false,
                title: Row(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Image.asset("assets/images/LogoCARPAKING.png", height: 50),
                  ],
                ),
              ),
              body: Center(
                child: _widgetOptions
                    .elementAt(state.index), // ← แก้ให้ state อัปเดตตลอด
              ),
              bottomNavigationBar: BottomNavigationBar(
                type: BottomNavigationBarType.fixed,
                selectedItemColor: const Color.fromRGBO(3, 23, 76, 1),
                unselectedItemColor: const Color.fromARGB(128, 2, 21, 73),
                items: const <BottomNavigationBarItem>[
                  BottomNavigationBarItem(
                      icon: Icon(Icons.bar_chart_sharp), label: 'Dashboard'),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.supervised_user_circle), label: 'Users'),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.local_parking), label: 'Parking'),
                  BottomNavigationBarItem(
                      icon: Icon(Icons.settings), label: 'Setting'),
                ],
                currentIndex: state.index,
                onTap: (index) {
                  context
                      .read<AdminNavigatorBloc>()
                      .add(OnChangeIndex(index: index));
                },
              ),
            );
          }

          return const SizedBox();
        },
      ),
    );
  }
}
