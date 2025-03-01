import 'dart:developer';

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

  void _showFilterDialog(BuildContext context) {
    final bloc = context.read<AdminParkingBloc>(); // ดึง Bloc
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
                "Filter Options",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 🌟 Floor Filter
                    const Text(
                      "Floor",
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
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
                            child: Text(floor == "" ? "All" : floor));
                      }).toList(),
                      onChanged: (value) {
                        setState(() =>
                            selectedFloor = value); // ✅ อัปเดตค่าใน Dialog
                      },
                    ),
                    const SizedBox(height: 15),

                    // 🌟 Status Filter
                    const Text(
                      "Status",
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
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
                        DropdownMenuItem(value: "", child: Text("All")),
                        DropdownMenuItem(value: "FULL", child: Text("FULL")),
                        DropdownMenuItem(value: "IDLE", child: Text("IDLE")),
                        DropdownMenuItem(
                            value: "RESERVED", child: Text("RESERVED")),
                      ],
                      onChanged: (value) {
                        setState(() => selectedStatus = value);
                      },
                    ),
                  ],
                ),
              ),
              actions: [
                TextButton(
                  onPressed: () {
                    bloc.add(OnSearch(
                        floor: selectedFloor ?? "",
                        status: selectedStatus ?? ""));
                    Navigator.of(context).pop();
                  },
                  child: const Text("Apply", style: TextStyle(fontSize: 16)),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text("Close", style: TextStyle(fontSize: 16)),
                ),
              ],
            );
          },
        );
      },
    );
  }

  _showAddDialog(BuildContext BuildContext) {
    final bloc = context.read<AdminParkingBloc>();
    final state = bloc.state;
    List<ModelFloor> floors = [];
    if (state is AdminParkingLoaded) {
      floors = state.floors;
    }
    final TextEditingController _slotNumberController = TextEditingController();
    String? selectedFloor = "F1";
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: Colors.white,
              title: const Text(
                "Add Parking Slot",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 🌟 Slot Number
                    const Text(
                      "Slot Number",
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
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
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
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
                TextButton(
                  onPressed: () {
                    bloc.add(
                        OnCreate(_slotNumberController.text, selectedFloor));
                    Navigator.of(context).pop();
                  },
                  child: const Text("Add", style: TextStyle(fontSize: 16)),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text("Close", style: TextStyle(fontSize: 16)),
                ),
              ],
            );
          },
        );
      },
    );
  }

  _showUpdateDialog(BuildContext BuildContext, ModelParkingSlot parking) {
    final bloc = context.read<AdminParkingBloc>();
    final state = bloc.state;
    List<ModelFloor> floors = [];
    if (state is AdminParkingLoaded) {
      floors = state.floors;
    }
    final TextEditingController _slotNumberController = TextEditingController();
    _slotNumberController.text = parking.slotNumber;
    String? selectedFloor = parking.floor.floorNumber;
    String? selectedStatus = parking.status;
    showDialog(
      context: context,
      builder: (context) {
        return StatefulBuilder(
          builder: (context, setState) {
            return AlertDialog(
              backgroundColor: Colors.white,
              title: const Text(
                "Update Parking Slot",
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              content: SingleChildScrollView(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // 🌟 Slot Number
                    const Text(
                      "Slot Number",
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
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
                      style:
                          TextStyle(fontWeight: FontWeight.w600, fontSize: 16),
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
                TextButton(
                  onPressed: () {
                    log("Update Parking Slot");
                    log("id : ${parking.id}");
                    bloc.add(OnUpdate(selectedFloor!,
                        _slotNumberController.text, parking.id));
                    Navigator.of(context).pop();
                  },
                  child: const Text("Update", style: TextStyle(fontSize: 16)),
                ),
                TextButton(
                  onPressed: () => Navigator.of(context).pop(),
                  child: const Text("Close", style: TextStyle(fontSize: 16)),
                ),
              ],
            );
          },
        );
      },
    );
  }

  _showDeleteDialog(BuildContext context, String id, String slotNumber) {
    final bloc = context.read<AdminParkingBloc>();
    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          backgroundColor: Colors.white,
          title: Text("Delete Parking Slot $slotNumber",
              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold)),
          content: Text("Are you sure you want to delete this parking slot?"),
          actions: [
            TextButton(
              onPressed: () {
                bloc.add(OnDelete(id));
                Navigator.of(context).pop();
              },
              child: const Text("Delete", style: TextStyle(fontSize: 16)),
            ),

            // ✅ ปุ่มปิด Dialog
            TextButton(
              onPressed: () => Navigator.of(context).pop(),
              child: const Text("Close", style: TextStyle(fontSize: 16)),
            ),
          ],
        );
      },
    );
  }

  adminListviewParking(List<ModelParkingSlot> parkings, BuildContext context,
      List<ModelFloor> floors) {
    final bloc = context.read<AdminParkingBloc>();

    return SizedBox(
      height: 600,
      child: Scrollbar(
        child: GridView.count(
          physics: BouncingScrollPhysics(),
          padding: const EdgeInsets.all(10),
          crossAxisSpacing: 15,
          mainAxisSpacing: 15,
          crossAxisCount: 2,
          children: parkings.map((slot) {
            return Stack(
              children: [
                Container(
                  width: 200,
                  height: 200,
                  decoration: BoxDecoration(
                    color: const Color.fromRGBO(3, 23, 76, 1),
                    borderRadius: BorderRadius.circular(20),
                  ),
                ),
                Positioned(
                  child: Center(
                    child: Container(
                      width: 150,
                      height: 150,
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Column(
                        children: [
                          Padding(
                            padding: const EdgeInsets.symmetric(horizontal: 5),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                // ✅ แสดงสถานะจุดจอด
                                Flexible(
                                  child: Row(
                                    children: [
                                      Container(
                                        width: 10,
                                        height: 10,
                                        decoration: BoxDecoration(
                                          color: slot.status == "IDLE"
                                              ? Colors.green
                                              : slot.status == "RESERVED"
                                                  ? Colors.orange
                                                  : slot.status == "FULL"
                                                      ? Colors.red
                                                      : Colors.grey,
                                          shape: BoxShape.circle,
                                        ),
                                      ),
                                      const SizedBox(width: 8),
                                      Text(
                                        slot.status == "RESERVED"
                                            ? "RES..."
                                            : slot.status,
                                        style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold,
                                          color: slot.status == "IDLE"
                                              ? Colors.green
                                              : slot.status == "RESERVED"
                                                  ? Colors.orange
                                                  : slot.status == "FULL"
                                                      ? Colors.red
                                                      : Colors.grey,
                                        ),
                                      ),
                                    ],
                                  ),
                                ),

                                // ✅ Dropdown Menu Button (แก้ให้แสดงผลได้ถูกต้อง)
                                IntrinsicWidth(
                                  child: Align(
                                    alignment:
                                        Alignment.centerRight, // จัดให้ชิดขวา
                                    child: DropdownButtonHideUnderline(
                                        child: DropdownButton<String>(
                                      dropdownColor: Colors.white,
                                      icon: const Icon(Icons.more_horiz,
                                          size: 24, color: Colors.black),
                                      menuMaxHeight: 150,
                                      items: [
                                        DropdownMenuItem(
                                          value: "edit",
                                          child: Row(
                                            children: const [
                                              Icon(Icons.edit,
                                                  size: 20, color: Colors.blue),
                                              SizedBox(width: 8),
                                              Text("Edit"),
                                            ],
                                          ),
                                        ),
                                        DropdownMenuItem(
                                          value: "delete",
                                          child: Row(
                                            children: const [
                                              Icon(Icons.delete,
                                                  size: 20, color: Colors.red),
                                              SizedBox(width: 8),
                                              Text("Delete"),
                                            ],
                                          ),
                                        ),
                                      ],
                                      onChanged: (value) {
                                        if (value == "edit") {
                                          //  context.read<AdminParkingBloc>().add(OnEdit(slot.id));
                                          _showUpdateDialog(context, slot);
                                        } else if (value == "delete") {
                                          //confrim dialog
                                          _showDeleteDialog(context, slot.id,
                                              slot.slotNumber);
                                        }
                                      },
                                    )),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            slot.slotNumber.length > 4
                                ? slot.slotNumber.substring(0, 4)
                                : slot.slotNumber,
                            style: const TextStyle(
                              fontFamily: "Amiko",
                              fontSize: 40,
                              fontWeight: FontWeight.w700,
                              color: Colors.black,
                            ),
                          ),
                          const SizedBox(height: 10),
                          Text(
                            "Floor ${slot.floor.floorNumber}",
                            style: const TextStyle(
                              fontFamily: "Amiko",
                              fontSize: 15,
                              fontWeight: FontWeight.w700,
                              color: Colors.black,
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            );
          }).toList(),
        ),
      ),
    );
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
          onPressed: () => _showAddDialog(context),
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
                      onPressed: () => _showFilterDialog(context),
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
                    return const Center(
                        child:
                            CircularProgressIndicator()); // 🌀 โหลดเฉพาะรายการจอดรถ
                  } else if (state is AdminParkingError) {
                    return Center(child: Text(state.message));
                  } else if (state is AdminParkingLoaded) {
                    return adminListviewParking(
                        state.parkings, context, state.floors);
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
