import 'package:car_parking_reservation/Bloc/admin_bloc/admin_parking/admin_parking_bloc.dart';
import 'package:car_parking_reservation/model/admin/parking.dart';
import 'package:flutter/material.dart';

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
          title: const Text(
            "Delete Parking Slot",
            style: TextStyle(
                fontSize: 20, fontWeight: FontWeight.bold, fontFamily: "Amiko"),
          ),
          content: Row(
            children: [
              Text("Are you sure to delete ",
                  style: TextStyle(
                      fontFamily: "Amiko", color: Colors.black, fontSize: 16)),
              Expanded(
                child: Text(slotNumber,
                    style: TextStyle(
                        overflow: TextOverflow.ellipsis,
                        fontWeight: FontWeight.bold,
                        fontFamily: "Amiko",
                        color: Colors.red,
                        fontSize: 16)),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                bloc.add(OnDelete(id));
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                backgroundColor: Colors.red,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: const Text("Delete",
                  style: TextStyle(
                      fontFamily: "Amiko",
                      color: Color.fromARGB(255, 255, 255, 255),
                      fontWeight: FontWeight.bold,
                      fontSize: 16)),
            ),
            ElevatedButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              style: ElevatedButton.styleFrom(
                padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
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
                          fontWeight: FontWeight.bold,
                          fontSize: 16,
                          fontFamily: "Amiko"),
                    ),
                    const SizedBox(height: 5),
                    TextField(
                      controller: _slotNumberController,
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          fontFamily: "Amiko"),
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
                    bloc.add(OnUpdate(selectedFloor!,
                        _slotNumberController.text, parking.id));
                    Navigator.of(context).pop();
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    backgroundColor: Colors.green,
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: const Text("Update",
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
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
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
                            padding: const EdgeInsets.only(
                                left: 10, top: 10, bottom: 15, right: 0),
                            child: Row(
                              mainAxisAlignment: MainAxisAlignment.spaceBetween,
                              children: [
                                Flexible(
                                  child: Stack(children: [
                                    Row(
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
                                        Expanded(
                                          child: Text(
                                            overflow: TextOverflow.ellipsis,
                                            slot.status,
                                            style: TextStyle(
                                              fontSize: 14,
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
                                        ),
                                      ],
                                    ),
                                    Positioned(
                                      top: -15,
                                      left: 30,
                                      child: DropdownButtonHideUnderline(
                                        child: DropdownButton<String>(
                                          dropdownColor: Colors.white,
                                          icon: const Icon(Icons.more_horiz,
                                              size: 28, color: Colors.black),
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
                                  ]),
                                ),
                              ],
                            ),
                          ),
                          Expanded(
                            child: Text(
                              slot.slotNumber,
                              style: const TextStyle(
                                fontFamily: "Amiko",
                                fontSize: 40,
                                fontWeight: FontWeight.w700,
                                color: Colors.black,
                                overflow: TextOverflow.ellipsis,
                              ),
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
