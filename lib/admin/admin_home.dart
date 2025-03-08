//AdminHomePage
import 'package:car_parking_reservation/Bloc/admin_bloc/admin_dashboard/admin_dashboard_bloc.dart';
import 'package:car_parking_reservation/Bloc/admin_bloc/admin_graph/admin_graph_bloc.dart';
import 'package:car_parking_reservation/Bloc/admin_bloc/admin_reservation/admin_reservation_bloc.dart';
import 'package:car_parking_reservation/Bloc/admin_bloc/admin_user/admin_user_bloc.dart';
import 'package:car_parking_reservation/Bloc/admin_bloc/admin_parking/admin_parking_bloc.dart';
import 'package:car_parking_reservation/Bloc/admin_bloc/admin_navigator/admin_navigator_bloc.dart';
import 'package:car_parking_reservation/admin/admin_parking.dart';
import 'package:car_parking_reservation/admin/admin_setting.dart';
import 'package:car_parking_reservation/admin/admin_users.dart';
import 'package:car_parking_reservation/admin/dashboard.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdminHomePage extends StatelessWidget {
  const AdminHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => AdminNavigatorBloc(),
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
                child: () {
                  switch (state.index) {
                    case 0:
                      return MultiBlocProvider(
                        providers: [
                          BlocProvider(
                            create: (context) => AdminDashboardBloc(),
                          ),
                          BlocProvider(
                            create: (context) => AdminGraphBloc(),
                          ),
                          BlocProvider(
                            create: (context) => AdminReservationBloc(),
                          ),
                        ],
                        child: AdminDashBoard(),
                      );
                    case 1:
                      return BlocProvider(
                        create: (context) => AdminUserBloc(),
                        child: AdminUserPage(),
                      );
                    case 2:
                      return BlocProvider(
                        create: (context) => AdminParkingBloc(),
                        child: AdminParkingPage(),
                      );
                    case 3:
                      return AdminSettingPage();
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
                  selectedItemColor: const Color.fromRGBO(3, 23, 76, 1),
                  unselectedItemColor: const Color.fromARGB(128, 2, 21, 73),
                  items: const <BottomNavigationBarItem>[
                    BottomNavigationBarItem(
                        icon: Icon(Icons.bar_chart_sharp), label: 'Dashboard'),
                    BottomNavigationBarItem(
                        icon: Icon(Icons.supervised_user_circle),
                        label: 'Users'),
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
              ),
            );
          }
          return const SizedBox();
        },
      ),
    );
  }
}
