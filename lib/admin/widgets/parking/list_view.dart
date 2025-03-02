import 'package:car_parking_reservation/Bloc/admin_bloc/admin_parking/admin_parking_bloc.dart';
import 'package:car_parking_reservation/model/admin/parking.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class AdminListViewParking extends StatelessWidget {
  final List<ModelParkingSlot> parkings;
  final List<ModelFloor> floors;

  const AdminListViewParking({
    super.key,
    required this.parkings,
    required this.floors,
  });

  showDeleteParkingDialog(BuildContext context, String id, String slotNumber) {
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

  showUpdateParkingDialog(BuildContext context, ModelParkingSlot parking) {
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

  @override
  Widget build(BuildContext context) {
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
                                IntrinsicWidth(
                                  child: Align(
                                    alignment: Alignment.centerRight,
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
                                                    size: 20,
                                                    color: Colors.blue),
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
                                                    size: 20,
                                                    color: Colors.red),
                                                SizedBox(width: 8),
                                                Text("Delete"),
                                              ],
                                            ),
                                          ),
                                        ],
                                        onChanged: (value) {
                                          if (value == "edit") {
                                            showUpdateParkingDialog(
                                                context, slot);
                                          } else if (value == "delete") {
                                            showDeleteParkingDialog(context,
                                                slot.id, slot.slotNumber);
                                          }
                                        },
                                      ),
                                    ),
                                  ),
                                ),
                              ],
                            ),
                          ),
                          Text(
                            slot.slotNumber.length > 3
                                ? "${slot.slotNumber.substring(0, 3)}..."
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
}
