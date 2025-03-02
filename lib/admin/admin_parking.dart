import 'dart:developer';

import 'package:car_parking_reservation/admin/widgets/parking/dialog/add_parking.dart';
import 'package:car_parking_reservation/admin/widgets/parking/dialog/filter_parking.dart';
import 'package:car_parking_reservation/admin/widgets/parking/list_view.dart';
import 'package:car_parking_reservation/bloc/admin_bloc/admin_parking/admin_parking_bloc.dart';
import 'package:car_parking_reservation/model/admin/parking.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdminParkingPage extends StatefulWidget {
  const AdminParkingPage({super.key});

  @override
  State<AdminParkingPage> createState() => _AdminParkingPageState();
}

class _AdminParkingPageState extends State<AdminParkingPage> {
  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    context.read<AdminParkingBloc>().add(OnPageLoad());
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AdminParkingBloc, AdminParkingState>(
      listener: (context, state) {
        if (state is AdminParkingSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: const Color(0xFF29CE79),
              duration: Duration(milliseconds: 1500),
              content: Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Row(
                  children: [
                    Icon(
                      Icons.check_circle,
                      color: Colors.white,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Text(
                        state.message,
                        style: TextStyle(
                            fontFamily: "Amiko",
                            fontSize: 18,
                            fontWeight: FontWeight.w700,
                            color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
              action: SnackBarAction(
                label: '',
                onPressed: () {
                  // Code to execute.
                },
              ),
              padding: EdgeInsets.all(2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              behavior: SnackBarBehavior.floating,
            ),
          );
        } else if (state is AdminParkingError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              backgroundColor: Colors.red,
              duration: Duration(milliseconds: 1500),
              content: Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Row(
                  children: [
                    Icon(
                      Icons.check_circle,
                      color: Colors.white,
                    ),
                    Padding(
                      padding: const EdgeInsets.only(left: 20),
                      child: Text(
                        state.message,
                        style: TextStyle(
                            fontFamily: "Amiko",
                            fontSize: 12,
                            fontWeight: FontWeight.w700,
                            color: Colors.white),
                      ),
                    ),
                  ],
                ),
              ),
              action: SnackBarAction(
                label: '',
                onPressed: () {
                  // Code to execute.
                },
              ),
              padding: EdgeInsets.all(2),
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(30),
              ),
              behavior: SnackBarBehavior.floating,
            ),
          );
        }
      },
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.green,
          onPressed: () => {showAddParkingDialog(context)},
          child: const Icon(
            Icons.add,
            size: 30,
            color: Colors.white,
          ),
        ),
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              "Parking",
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
              color: Colors.black,
            ),

            // 🔹 Search & Filter UI (คงอยู่ตลอดเวลา)
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
              child: SizedBox(
                height: 47,
                child: Row(
                  children: [
                    Flexible(
                      flex: 4, // 80% ของพื้นที่ทั้งหมด
                      child: SizedBox(
                        height: 40,
                        child: TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            hintStyle: TextStyle(
                                color: Colors.blueGrey,
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                fontFamily: "Amiko"),
                            hintText: "Search by name",
                            prefixIcon: Icon(Icons.search),
                            border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(width: 2, color: Colors.blueGrey),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(100)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(width: 2, color: Colors.blueGrey),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(100)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  width: 1.2, color: Colors.blueGrey),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(100)),
                            ),
                          ),
                          onChanged: (value) {
                            context
                                .read<AdminParkingBloc>()
                                .add(OnSearch(search: value));
                          },
                        ),
                      ),
                    ),
                    // ระยะห่างระหว่าง TextField กับ Filter Button
                    ElevatedButton(
                      onPressed: () => showFilterParkingDialog(context),
                      style: ElevatedButton.styleFrom(
                        shape: const CircleBorder(),
                        padding: const EdgeInsets.all(4),
                        backgroundColor: Colors.transparent,
                        shadowColor: Colors.transparent,
                        foregroundColor: Colors.black,
                      ),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(Icons.filter_list_alt,
                              size: 25, color: Colors.blueGrey),
                          Text("Filter",
                              style: TextStyle(
                                  fontSize: 10,
                                  color: Colors.blueGrey,
                                  fontFamily: "Amiko",
                                  fontWeight: FontWeight.bold)),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),

            // 🔹 BlocBuilder: โหลดเฉพาะ Parking List
            Expanded(
              child: BlocBuilder<AdminParkingBloc, AdminParkingState>(
                builder: (context, state) {
                  if (state is AdminParkingLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is AdminParkingError) {
                    return Center(child: Text(state.message));
                  } else if (state is AdminParkingLoaded) {
                    return AdminListViewParking(
                      parkings: state.parkings,
                      floors: state.floors,
                    );
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
