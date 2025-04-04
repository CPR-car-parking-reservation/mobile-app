import 'dart:async';

import 'package:car_parking_reservation/Bloc/admin_bloc/admin_dashboard/admin_dashboard_bloc.dart';
import 'package:car_parking_reservation/Bloc/admin_bloc/admin_graph/admin_graph_bloc.dart';
import 'package:car_parking_reservation/Bloc/admin_bloc/admin_reservation/admin_reservation_bloc.dart';
import 'package:car_parking_reservation/Login/signin.dart';
import 'package:car_parking_reservation/Widget/custom_dialog.dart';
import 'package:car_parking_reservation/admin/widgets/dashboard/barchart.dart';
import 'package:car_parking_reservation/admin/widgets/dashboard/container.dart';
import 'package:car_parking_reservation/admin/widgets/dashboard/reservation_list.dart';
import 'package:car_parking_reservation/admin/widgets/dashboard/toppic.dart';
import 'package:car_parking_reservation/mqtt/mqtt_service.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdminDashBoard extends StatefulWidget {
  const AdminDashBoard({super.key});

  @override
  State<AdminDashBoard> createState() => _AdminDashBoardState();
}

class _AdminDashBoardState extends State<AdminDashBoard> {
  final mqttService = MqttService();
  StreamSubscription<String>? mqttSubscription;
  final int initYear = 2021;
  var selectedTitle = 'Reservation';
  var selectedMonth = DateTime.now().month;
  var selectedYear = DateTime.now().year;
  TextEditingController dateCtl = TextEditingController();

  var selectedSort = "DESC";

  @override
  void initState() {
    super.initState();
    _initializeMqttAndLoadData();
    dateCtl.text = DateTime.now().toString().split(" ")[0];
  }

  Future<void> _initializeMqttAndLoadData() async {
    context.read<AdminDashboardBloc>().add(SetLoading());
    bool isConnected = await mqttService.connect();
    if (isConnected) {
      _loadGraphAndReservations();

      mqttSubscription = mqttService.messageStream.listen((message) {
        if (message == "fetch slot" ||
            message == "fetch user" ||
            message == "fetch reservation") {
          context.read<AdminDashboardBloc>().add(AdminDashboardRefresh());
        }

        if (message == "fetch reservation") {
          context.read<AdminGraphBloc>().add(AdminGraphOnRefresh());
          context.read<AdminReservationBloc>().add(AdminReservationOnRefresh());
        }
      });
    }
  }

  Future<void> _loadGraphAndReservations() async {
    await Future.delayed(Duration(milliseconds: 100));
    context.read<AdminDashboardBloc>().add(AdminDashboardOnLoad());
    await Future.delayed(Duration(milliseconds: 100));
    context.read<AdminGraphBloc>().add(AdminGraphOnLoad(
        month: selectedMonth, year: selectedYear, type: "Reservation"));
    await Future.delayed(Duration(milliseconds: 100));
    context
        .read<AdminReservationBloc>()
        .add(AdminReservationOnLoad(date: dateCtl.text, order: selectedSort));
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AdminDashboardBloc, AdminDashboardState>(
      listener: (context, state) {
        if (state is AdminDashboardError ||
            context.read<AdminGraphBloc>().state is AdminGraphError) {
          final errorMessage = state is AdminDashboardError
              ? state.message
              : (context.read<AdminGraphBloc>().state as AdminGraphError)
                  .message;

          if (state is AdminDashboardError) {
            if (state.message == "Unauthorized!") {
              Future.delayed(Duration.zero, () {
                Navigator.pushAndRemoveUntil(
                  context,
                  MaterialPageRoute(builder: (context) => Signin()),
                  (route) => false,
                );
              });
            }
            showCustomDialogError(context, errorMessage);
          }
        }
      },
      child: Scaffold(
        body: SingleChildScrollView(
          child: Padding(
            padding:
                const EdgeInsets.only(left: 10, right: 10, top: 0, bottom: 10),
            child: Column(
              children: [
                Text(
                  "DashBoard",
                  style: TextStyle(
                      fontFamily: "Amiko",
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                      color: Colors.black),
                ),
                Divider(
                  height: 10,
                  endIndent: 60,
                  indent: 60,
                  color: const Color(0xFF03174C),
                ),
                BlocBuilder<AdminDashboardBloc, AdminDashboardState>(
                  builder: (context, state) {
                    if (state is AdminDashboardLoading) {
                      return Column(children: [
                        TopicDashboard(title: "Parking Status"),
                        Container(
                          height: 220,
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                        TopicDashboard(title: "Total"),
                        Container(
                          height: 220,
                          child: Center(
                            child: CircularProgressIndicator(),
                          ),
                        ),
                      ]);
                    }
                    if (state is AdminDashboardError) {
                      return Center(child: Text(state.message));
                    }
                    if (state is AdminDashboardLoaded) {
                      return Column(children: [
                        TopicDashboard(title: "Parking Status"),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomContainer(
                                // ignore: deprecated_member_use
                                color:
                                    const Color(0xFF29CE79).withOpacity(0.75),
                                icon: Icons.info_rounded,
                                title: "    IDLE",
                                value: state.adminDashboardData[0].idle
                                    .toString()),
                            CustomContainer(
                                // ignore: deprecated_member_use
                                color: Colors.red.withOpacity(0.75),
                                icon: Icons.directions_car_rounded,
                                title: "   FULL",
                                value: state.adminDashboardData[0].full
                                    .toString()),
                          ],
                        ),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomContainer(
                                // ignore: deprecated_member_use
                                color:
                                    const Color(0xFFFFA600).withOpacity(0.75),
                                icon: Icons.info_rounded,
                                title: "RESERVED",
                                value: state.adminDashboardData[0].reserved
                                    .toString()),
                            CustomContainer(
                                // ignore: deprecated_member_use
                                color: Colors.grey.withOpacity(0.75),
                                icon: Icons.cancel,
                                title: "MAINTAIN",
                                value: state.adminDashboardData[0].maintenance
                                    .toString()),
                          ],
                        ),
                        TopicDashboard(title: "Total"),
                        Column(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            CustomLongContainer(
                                color: const Color(0xFF03174C),
                                icon: Icons.supervisor_account_rounded,
                                title: "Total User",
                                value: state.adminDashboardData[0].total_user
                                    .toString()),
                            CustomLongContainer(
                                color: const Color(0xFF03174C),
                                icon: Icons.attach_money_rounded,
                                title: "Total Cash",
                                value: state.adminDashboardData[0].total_cash
                                    .toString()),
                          ],
                        ),
                      ]);
                    } else {
                      return SizedBox.shrink();
                    }
                  },
                ),
                Column(
                  children: [
                    TopicDashboard(title: "Statistic"),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: 131,
                            child: DropdownButtonFormField<String>(
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(color: Colors.white),
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                      color: const Color.fromARGB(255, 0, 0, 0),
                                      width: 1),
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                      color: const Color.fromARGB(255, 0, 0, 0),
                                      width: 1.5),
                                ),
                                contentPadding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                              ),
                              value: selectedTitle,
                              items: [
                                DropdownMenuItem(
                                    value: "Reservation",
                                    child: Text("Reservation")),
                                DropdownMenuItem(
                                    value: "Cash", child: Text("Cash")),
                              ],
                              onChanged: (newValue) {
                                setState(() {
                                  selectedTitle = newValue!;
                                });
                                context.read<AdminGraphBloc>().add(
                                    AdminGraphOnLoad(
                                        month: selectedMonth,
                                        year: selectedYear,
                                        type: selectedTitle));
                              },
                            ),
                          ),
                          SizedBox(
                            width: 124,
                            child: DropdownButtonFormField<String>(
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                      color:
                                          Colors.white), // เปลี่ยนสีขอบเป็นขาว
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                      color: const Color.fromARGB(255, 0, 0, 0),
                                      width: 1), // ขอบสีขาวเมื่อไม่ได้โฟกัส
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                      color: const Color.fromARGB(255, 0, 0, 0),
                                      width: 1.5), // ขอบสีเหลืองเมื่อโฟกัส
                                ),
                                contentPadding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                              ),
                              value: selectedMonth.toString(),
                              items: [
                                DropdownMenuItem(
                                    value: "1", child: Text("January")),
                                DropdownMenuItem(
                                    value: "2", child: Text("February")),
                                DropdownMenuItem(
                                    value: "3", child: Text("March")),
                                DropdownMenuItem(
                                    value: "4", child: Text("April")),
                                DropdownMenuItem(
                                    value: "5", child: Text("May")),
                                DropdownMenuItem(
                                    value: "6", child: Text("June")),
                                DropdownMenuItem(
                                    value: "7", child: Text("July")),
                                DropdownMenuItem(
                                    value: "8", child: Text("August")),
                                DropdownMenuItem(
                                    value: "9", child: Text("September")),
                                DropdownMenuItem(
                                    value: "10", child: Text("October")),
                                DropdownMenuItem(
                                    value: "11", child: Text("November")),
                                DropdownMenuItem(
                                    value: "12", child: Text("December"))
                              ],
                              onChanged: (newValue) {
                                setState(() {
                                  selectedMonth = int.parse(newValue!);
                                });
                                context.read<AdminGraphBloc>().add(
                                    AdminGraphOnLoad(
                                        month: selectedMonth,
                                        year: selectedYear,
                                        type: selectedTitle));
                              },
                            ),
                          ),
                          SizedBox(
                            width: 81,
                            child: DropdownButtonFormField<String>(
                              decoration: InputDecoration(
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                      color:
                                          Colors.white), // เปลี่ยนสีขอบเป็นขาว
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                      color: const Color.fromARGB(255, 0, 0, 0),
                                      width: 1), // ขอบสีขาวเมื่อไม่ได้โฟกัส
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                      color: const Color.fromARGB(255, 0, 0, 0),
                                      width: 1.5), // ขอบสีเหลืองเมื่อโฟกัส
                                ),
                                contentPadding:
                                    const EdgeInsets.symmetric(horizontal: 10),
                              ),
                              value: selectedYear.toString(),
                              // ป้องกัน null
                              items: List.generate(
                                (DateTime.now().year - initYear + 1)
                                    .clamp(1, 100), // ป้องกันค่าติดลบ
                                (index) {
                                  int currentYear = initYear + index;
                                  return DropdownMenuItem(
                                    value: currentYear.toString(),
                                    child: Text(currentYear.toString()),
                                  );
                                },
                              ),
                              onChanged: (newValue) {
                                setState(() {
                                  selectedYear = int.parse(newValue!);
                                });
                                context.read<AdminGraphBloc>().add(
                                    AdminGraphOnLoad(
                                        month: selectedMonth,
                                        year: selectedYear,
                                        type: selectedTitle));
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    BlocBuilder<AdminGraphBloc, AdminGraphState>(
                      builder: (context, state) {
                        if (state is AdminGraphLoading) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 8, bottom: 4),
                            child: SizedBox(
                                height: 600,
                                child:
                                    Center(child: CircularProgressIndicator())),
                          );
                        }
                        if (state is AdminGraphError) {
                          return Center(child: Text(state.message));
                        }
                        if (state is AdminGraphLoaded) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 8, bottom: 4),
                            child: SizedBox(
                                height: 600,
                                child: BarChartSample2(
                                    data: state.adminGraphData,
                                    title: selectedTitle)),
                          );
                        }
                        return SizedBox.shrink();
                      },
                    ),
                    TopicDashboard(title: "Reservations"),
                    //date picker
                    Padding(
                      padding: const EdgeInsets.only(top: 5),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceBetween,
                        children: [
                          SizedBox(
                            width: 160,
                            child: TextField(
                              controller: dateCtl,
                              decoration: InputDecoration(
                                  hintStyle: TextStyle(
                                      fontFamily: "Amiko",
                                      fontSize: 16,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w700),
                                  labelText: 'DATE',
                                  labelStyle: TextStyle(
                                      fontFamily: "Amiko",
                                      fontSize: 16,
                                      color: Colors.black,
                                      fontWeight: FontWeight.w700),
                                  filled: true,
                                  prefixIcon: Icon(Icons.calendar_today),
                                  border: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                  ),
                                  enabledBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                      color: Color(0xFF03174C),
                                    ),
                                  ),
                                  focusedBorder: OutlineInputBorder(
                                    borderRadius: BorderRadius.circular(10),
                                    borderSide: BorderSide(
                                      color: Color(0xFF03174C),
                                    ),
                                  ),
                                  contentPadding: const EdgeInsets.symmetric(
                                      horizontal: 10, vertical: 0),
                                  fillColor:
                                      const Color.fromARGB(255, 255, 255, 255)),
                              readOnly: true,
                              onTap: _selectDate,
                              onChanged: (newValue) {
                                context.read<AdminReservationBloc>().add(
                                    AdminReservationOnLoad(
                                        date: dateCtl.text,
                                        order: selectedSort));
                              },
                            ),
                          ),
                          SizedBox(
                            width: 10,
                          ),
                          SizedBox(
                            width: 170,
                            child: DropdownButtonFormField<String>(
                              decoration: InputDecoration(
                                filled: true, // เปิดใช้งานสีพื้นหลัง
                                fillColor: const Color.fromARGB(255, 255, 255,
                                    255), // เปลี่ยนสีพื้นหลัง (น้ำเงินเข้ม)
                                border: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                      color:
                                          Colors.white), // เปลี่ยนสีขอบเป็นขาว
                                ),
                                enabledBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                      color: const Color.fromARGB(255, 0, 0, 0),
                                      width: 1), // ขอบสีขาวเมื่อไม่ได้โฟกัส
                                ),
                                focusedBorder: OutlineInputBorder(
                                  borderRadius: BorderRadius.circular(10),
                                  borderSide: BorderSide(
                                      color: const Color.fromARGB(255, 0, 0, 0),
                                      width: 1.5), // ขอบสีเหลืองเมื่อโฟกัส
                                ),
                                contentPadding: const EdgeInsets.symmetric(
                                    horizontal: 8,
                                    vertical: 0), // เพิ่ม padding ให้สูงขึ้น
                              ),
                              isDense: false, // ปิด isDense เพื่อให้สูงขึ้น
                              value: selectedSort,
                              items: [
                                DropdownMenuItem(
                                    value: "ASC",
                                    child: Text("Oldest to Newest")),
                                DropdownMenuItem(
                                    value: "DESC",
                                    child: Text("Newest to Oldest")),
                              ],
                              onChanged: (newValue) {
                                setState(() {
                                  selectedSort = newValue!;
                                });
                                context.read<AdminReservationBloc>().add(
                                    AdminReservationOnLoad(
                                        date: dateCtl.text,
                                        order: selectedSort));
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                    BlocBuilder<AdminReservationBloc, AdminReservationState>(
                      builder: (context, state) {
                        if (state is AdminReservationLoading) {
                          return Padding(
                            padding: const EdgeInsets.only(top: 8, bottom: 4),
                            child: SizedBox(
                                height: 500,
                                child:
                                    Center(child: CircularProgressIndicator())),
                          );
                        }
                        if (state is AdminReservationError) {
                          return Center(child: Text(state.message));
                        }
                        if (state is AdminReservationLoaded) {
                          if (state.adminReservationData.isEmpty) {
                            return Padding(
                              padding:
                                  const EdgeInsets.only(top: 30, bottom: 20),
                              child: Center(
                                  child: Text(
                                "No reservation found",
                                style: TextStyle(
                                    fontFamily: "Amiko",
                                    fontSize: 20,
                                    fontWeight: FontWeight.w700),
                              )),
                            );
                          }
                          return Padding(
                            padding: const EdgeInsets.only(top: 0, bottom: 0),
                            child: SizedBox(
                              height: 500,
                              child: AdminListViewHistory(
                                  History: state.adminReservationData),
                            ),
                            // child: Reservatiob_list(
                            //     context, state.adminReservationData)),
                          );
                        }
                        return SizedBox.shrink();
                      },
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }

  Future<void> _selectDate() async {
    DateTime? _picked = await showDatePicker(
      context: context,
      initialDate: DateTime.now(),
      firstDate: DateTime(initYear),
      lastDate: DateTime(DateTime.now().year + 1),
    );

    if (_picked != null) {
      setState(() {
        dateCtl.text = _picked.toString().split(" ")[0];
      });
    }
    context
        .read<AdminReservationBloc>()
        .add(AdminReservationOnLoad(date: dateCtl.text, order: selectedSort));
  }
}
