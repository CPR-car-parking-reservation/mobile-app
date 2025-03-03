import 'dart:developer';

import 'package:car_parking_reservation/Bloc/admin_bloc/admin_parking/admin_parking_bloc.dart';
import 'package:car_parking_reservation/Widget/custom_dialog.dart';
import 'package:car_parking_reservation/admin/widgets/parking/list_view.dart';
import 'package:car_parking_reservation/model/admin/parking.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdminParkingPage extends StatefulWidget {
  AdminParkingPage({super.key});

  @override
  State<AdminParkingPage> createState() => _AdminParkingPageState();
}

class _AdminParkingPageState extends State<AdminParkingPage> {
  @override
  void initState() {
    super.initState();
    context.read<AdminParkingBloc>().add(OnParkingPageLoad());
  }

  final TextEditingController _searchController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    showAddParkingDialog(BuildContext context) {
      final bloc = context.read<AdminParkingBloc>();
      final state = bloc.state;
      List<ModelFloor> floors = [];
      if (state is AdminParkingLoaded) {
        floors = state.floors;
      }
      final TextEditingController _slotNumberController =
          TextEditingController();
      String? selectedFloor = floors[0].floorNumber;
      showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                backgroundColor: Colors.white,
                title: const Text(
                  "Add Parking Slot",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Amiko"),
                ),
                content: SingleChildScrollView(
                  child: Column(
                    mainAxisSize: MainAxisSize.min,
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      // 🌟 Slot Number
                      const Text(
                        "Slot Number",
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 16),
                      ),
                      const SizedBox(height: 5),
                      TextField(
                        controller: _slotNumberController,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 10),
                        ),
                      ),
                      const SizedBox(height: 15),

                      // 🌟 Floor Filter
                      const Text(
                        "Floor",
                        style: TextStyle(
                            fontWeight: FontWeight.w600, fontSize: 16),
                      ),
                      const SizedBox(height: 5),
                      DropdownButtonFormField<String>(
                        value: selectedFloor,
                        decoration: InputDecoration(
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(10)),
                          contentPadding:
                              const EdgeInsets.symmetric(horizontal: 10),
                        ),
                        items: floors.map((floor) {
                          return DropdownMenuItem(
                              value: floor.floorNumber,
                              child: Text(floor.floorNumber));
                        }).toList(),
                        onChanged: (value) {
                          setState(() =>
                              selectedFloor = value); // ✅ อัปเดตค่าใน Dialog
                        },
                      ),
                    ],
                  ),
                ),
                actions: [
                  ElevatedButton(
                    onPressed: () {
                      bloc.add(
                          OnCreate(_slotNumberController.text, selectedFloor));
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      padding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text("Add",
                        style: TextStyle(
                            color: Colors.white,
                            fontSize: 16,
                            fontFamily: "Amiko",
                            fontWeight: FontWeight.bold)),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      padding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      backgroundColor: const Color.fromARGB(255, 251, 251, 251),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text("Cancel",
                        style: TextStyle(
                            fontFamily: "Amiko",
                            color: Color.fromARGB(255, 0, 0, 0),
                            fontWeight: FontWeight.bold,
                            fontSize: 16)),
                  ),
                ],
              );
            },
          );
        },
      );
    }

    showFilterParkingDialog(BuildContext context) {
      final bloc = context.read<AdminParkingBloc>();
      final state = bloc.state;

      String? selectedFloor = "";
      String? selectedStatus = "";
      List<String> floors = [];

      if (state is AdminParkingLoaded) {
        selectedFloor = state.floor ?? "";
        selectedStatus = state.status ?? "";
        floors = state.floors.map((floor) => floor.floorNumber).toList();
        floors.insert(0, "");
      }

      showDialog(
        context: context,
        builder: (context) {
          return StatefulBuilder(
            builder: (context, setState) {
              return AlertDialog(
                backgroundColor: Colors.white,
                title: const Text(
                  "Filter Parking Slot",
                  style: TextStyle(
                      fontSize: 20,
                      fontWeight: FontWeight.bold,
                      fontFamily: "Amiko"),
                ),
                content: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 🌟 Floor Filter
                    const Text(
                      "Floor",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          fontFamily: "Amiko"),
                    ),
                    const SizedBox(height: 5),
                    DropdownButtonFormField<String>(
                      value: selectedFloor,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 10),
                      ),
                      items: floors.map((floor) {
                        return DropdownMenuItem(
                            value: floor,
                            child: Text(
                              floor == "" ? "All" : floor,
                              style: TextStyle(
                                  fontFamily: "Amiko",
                                  fontSize: 16,
                                  fontWeight: FontWeight.bold),
                            ));
                      }).toList(),
                      onChanged: (value) {
                        setState(() => selectedFloor = value);
                      },
                    ),
                    const SizedBox(height: 15),

                    // 🌟 Status Filter
                    const Text(
                      "Status",
                      style: TextStyle(
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          fontFamily: "Amiko"),
                    ),
                    const SizedBox(height: 5),
                    DropdownButtonFormField<String>(
                      value: selectedStatus,
                      decoration: InputDecoration(
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(10)),
                        contentPadding:
                            const EdgeInsets.symmetric(horizontal: 10),
                      ),
                      items: const [
                        DropdownMenuItem(
                            value: "",
                            child: Text(
                              "All",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  fontFamily: "Amiko"),
                            )),
                        DropdownMenuItem(
                            value: "FULL",
                            child: Text(
                              "FULL",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  fontFamily: "Amiko"),
                            )),
                        DropdownMenuItem(
                            value: "IDLE",
                            child: Text(
                              "IDLE",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  fontFamily: "Amiko"),
                            )),
                        DropdownMenuItem(
                            value: "RESERVED",
                            child: Text(
                              "RESERVED",
                              style: TextStyle(
                                  fontWeight: FontWeight.bold,
                                  fontSize: 16,
                                  fontFamily: "Amiko"),
                            )),
                      ],
                      onChanged: (value) {
                        setState(() => selectedStatus = value);
                      },
                    ),
                  ],
                ),
                actions: [
                  ElevatedButton(
                    onPressed: () {
                      bloc.add(OnSearch(
                          floor: selectedFloor ?? "",
                          status: selectedStatus ?? ""));
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      padding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text("Apply",
                        style: TextStyle(
                            fontFamily: "Amiko",
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16)),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(context).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      padding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      backgroundColor: const Color.fromARGB(255, 251, 251, 251),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    child: const Text("Cancel",
                        style: TextStyle(
                            fontFamily: "Amiko",
                            color: Color.fromARGB(255, 0, 0, 0),
                            fontWeight: FontWeight.bold,
                            fontSize: 16)),
                  ),
                ],
              );
            },
          );
        },
      );
    }

    return BlocListener<AdminParkingBloc, AdminParkingState>(
      listener: (context, state) {
        if (state is AdminParkingSuccess) {
          showCustomDialogSucess(context, state.message);
        } else if (state is AdminParkingError) {
          showCustomDialogError(context, state.message);
        }
      },
      child: Scaffold(
        floatingActionButton: FloatingActionButton(
          backgroundColor: Colors.green,
          onPressed: () {
            showAddParkingDialog(context);
          },
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
                    if (state.parkings.isNotEmpty) {
                      return AdminListViewParking(
                        parkings: state.parkings,
                        floors: state.floors,
                      );
                    } else {
                      return Center(
                          child: Text(
                        "No data found",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            fontFamily: "Amiko"),
                      ));
                    }
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
