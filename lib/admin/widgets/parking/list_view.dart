import 'package:car_parking_reservation/Bloc/admin_bloc/admin_parking/admin_parking_bloc.dart';
import 'package:car_parking_reservation/admin/widgets/parking/dialog/delete_parking.dart';
import 'package:car_parking_reservation/admin/widgets/parking/dialog/update_parking.dart';
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
}
