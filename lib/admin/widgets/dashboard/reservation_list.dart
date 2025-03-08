import 'package:car_parking_reservation/model/admin/reservation.dart';

import 'package:flutter/material.dart';

class AdminListViewHistory extends StatefulWidget {
  final List<Model_History_data> History;

  const AdminListViewHistory({super.key, required this.History});

  @override
  State<AdminListViewHistory> createState() => _AdminListViewHistoryState();

  static getStatusColor(String status) {
    switch (status) {
      case "CANCEL":
        return Colors.red;
      case "OCCUPIED":
        return Colors.grey;
      case "SUCCESS":
        return Colors.green;
      case "EXPIRED":
        return Colors.amber;
      case "WAITING":
      default:
        return Colors.blue;
    }
  }
}

class _AdminListViewHistoryState extends State<AdminListViewHistory> {
  @override
  Widget build(BuildContext context) {
    return ListView.builder(
      padding: const EdgeInsets.only(top: 10),
      itemCount: widget.History.length,
      itemBuilder: (context, index) {
        final history_user = widget.History[index];
        final history_date_start = history_user.start_at;
        var history_date_end =
            history_user.end_at == null ? '' : history_user.end_at;

        final date_start = DateTime.parse(history_date_start.toString());

        return Center(
          child: Padding(
            padding: EdgeInsets.only(bottom: 10),
            child: Stack(
              children: [
                Container(
                  height: 145,
                  width: 350,
                  decoration: BoxDecoration(
                    color: Colors.white,
                    borderRadius: BorderRadius.circular(20),
                    border: Border.all(
                        color: const Color.fromARGB(255, 203, 203, 203),
                        width: 1.5),
                  ),
                  child: Padding(
                    padding: const EdgeInsets.only(top: 50, left: 25),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Row(
                          children: [
                            const Text(
                              "User : ",
                              style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontFamily: "Amiko",
                                  fontSize: 14),
                            ),
                            Text(
                              "${history_user.user.name}",
                              style: const TextStyle(
                                  fontFamily: "Amiko", fontSize: 14),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const Text(
                              "In : ",
                              style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontFamily: "Amiko",
                                  fontSize: 14),
                            ),
                            Text(
                              "${date_start.hour.toString().padLeft(2, '0')}:${date_start.minute.toString().padLeft(2, '0')}:${date_start.second.toString().padLeft(2, '0')}" ??
                                  'N/A',
                              style: const TextStyle(
                                  fontFamily: "Amiko", fontSize: 14),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const Text(
                              "Out : ",
                              style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontFamily: "Amiko",
                                  fontSize: 16),
                            ),
                            Text(
                              history_date_end.toString() == ''
                                  ? 'N/A'
                                  : "${(DateTime.parse(history_date_end.toString())).hour.toString().padLeft(2, '0')}:${(DateTime.parse(history_date_end.toString())).minute.toString().padLeft(2, '0')}:${(DateTime.parse(history_date_end.toString())).second.toString()}",
                              style: const TextStyle(
                                  fontFamily: "Amiko", fontSize: 14),
                            ),
                          ],
                        ),
                        Row(
                          children: [
                            const Text(
                              "Price : ",
                              style: TextStyle(
                                  fontWeight: FontWeight.w700,
                                  fontFamily: "Amiko",
                                  fontSize: 14),
                            ),
                            Text(
                              "${history_user.price.toString()} ฿",
                              style: const TextStyle(
                                  fontFamily: "Amiko", fontSize: 14),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Container(
                    height: 35,
                    width: 175,
                    decoration: BoxDecoration(
                      color: const Color(0xFF03174C),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.symmetric(
                          horizontal: 20, vertical: 8),
                      child: Row(
                        children: [
                          const Text(
                            "Date : ",
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: "Amiko",
                                fontWeight: FontWeight.w700),
                          ),
                          Text(
                            "${date_start.day.toString().padLeft(2, '0')}-${date_start.month.toString().padLeft(2, '0')}-${date_start.year.toString()}" ??
                                'N/A',
                            style: const TextStyle(
                              color: Colors.white,
                              fontFamily: "Amiko",
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ),
                Positioned(
                  right: 10,
                  top: 10,
                  child: Container(
                    decoration: BoxDecoration(
                      color: AdminListViewHistory.getStatusColor(
                          history_user.status),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            horizontal: 5, vertical: 2.5),
                        child: Row(
                          children: [
                            Text(
                              history_user.status,
                              style: const TextStyle(
                                  color: Colors.white,
                                  fontFamily: "Amiko",
                                  fontSize: 10,
                                  fontWeight: FontWeight.w700),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ),
                Positioned(
                  left: 285,
                  bottom: 20,
                  child: Container(
                    height: 30,
                    width: 50,
                    decoration: const BoxDecoration(color: Colors.white),
                    child: Center(
                      child: Text(
                        history_user.parking_slots.slotNumber,
                        style: const TextStyle(
                            fontFamily: "Amiko",
                            fontSize: 25,
                            fontWeight: FontWeight.w700),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}
