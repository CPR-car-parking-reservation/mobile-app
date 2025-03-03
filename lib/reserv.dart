import 'package:car_parking_reservation/bloc/reserved/reserved_bloc.dart';
import 'package:car_parking_reservation/Qr-generator/qr_code.dart';
import 'package:car_parking_reservation/history.dart';
import 'package:car_parking_reservation/model/history.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';

class Reserv extends StatefulWidget {
  // Get the slot number, floor id, and status from the API
  final String? parking_slots_id;
  final String? slot_number;
  final String? floor_number;
  final String? status;

  const Reserv(
      {super.key,
      this.parking_slots_id,
      this.floor_number,
      this.status,
      this.slot_number});

  @override
  _ReservState createState() => _ReservState();
}

class _ReservState extends State<Reserv> {
  bool isVisible = false;
  bool _boolfade = true;

  final dateFormat = DateTime.now();
  late DateFormat timeFormat;

  late List<Map<String, dynamic>> history;

  void initState() {
    super.initState();
    initializeDateFormatting();
    timeFormat = DateFormat.Hms('th');
    history = [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF03174C),
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Image.asset(
              "assets/images/LogoCARPAKING.png",
              height: 40,
              width: 90,
            ),
          ],
        ),
      ),
      backgroundColor: const Color(0xFF03174C),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(0),
            child: Column(
              children: [
                Text(
                  "Reservation",
                  style: TextStyle(
                      fontFamily: "Amiko",
                      fontSize: 26,
                      fontWeight: FontWeight.w700,
                      color: Colors.white),
                ),
                Divider(
                  height: 10,
                  endIndent: 40,
                  indent: 40,
                ),
                Text(
                  "${widget.slot_number}",
                  style: TextStyle(
                      fontFamily: "Amiko",
                      fontSize: 38,
                      fontWeight: FontWeight.w700,
                      color: Colors.white),
                ),
                Text(
                  "PARKING ZONE ${widget.floor_number}",
                  style: TextStyle(
                      fontFamily: "Amiko",
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Colors.white),
                ),
                Image.asset(
                  "assets/images/cartopview2.png",
                  height: 300,
                ),
                Column(
                  children: [
                    Center(
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 10),
                        child: Column(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.center,
                              children: [
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Icon(
                                      Icons.date_range_outlined,
                                      color: Colors.white,
                                      size: 30,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 5, top: 7.5),
                                      child: Text(
                                        "${dateFormat.day}-${dateFormat.month}-${dateFormat.year}",
                                        style: TextStyle(
                                            fontFamily: "Amiko",
                                            fontSize: 22,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.white),
                                      ),
                                    ),
                                  ],
                                ),
                                Row(
                                  mainAxisAlignment: MainAxisAlignment.center,
                                  children: [
                                    Padding(
                                      padding: const EdgeInsets.only(left: 15),
                                      child: Icon(
                                        Icons.access_time,
                                        color: Colors.white,
                                        size: 30,
                                      ),
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 5, top: 7.5),
                                      child: Text(
                                        "${timeFormat.format(DateTime.now().toLocal())}",
                                        style: TextStyle(
                                            fontFamily: "Amiko",
                                            fontSize: 22,
                                            fontWeight: FontWeight.w700,
                                            color: Colors.white),
                                      ),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ],
                        ),
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 350,
                          height: 150,
                        ),
                        Positioned(
                          top: 100,
                          child: SizedBox(
                            width: 150,
                            child: AnimatedOpacity(
                              opacity: _boolfade ? 1.0 : 0.0,
                              duration: const Duration(milliseconds: 500),
                              child: Visibility(
                                visible: isVisible,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.yellow[600]),
                                  onPressed: () {
                                    setState(() {
                                      isVisible = false;
                                      _boolfade = false;
                                    });
                                    Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                        builder: (context) => GenQR(),
                                      ),
                                    );
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.all(10),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          "Get QR",
                                          style: TextStyle(
                                              color: Colors.black,
                                              fontWeight: FontWeight.w700,
                                              fontSize: 16),
                                        ),
                                        Padding(
                                          padding:
                                              const EdgeInsets.only(left: 5),
                                          child: Icon(
                                            Icons.qr_code,
                                            color: Colors.black,
                                            size: 24,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ),
                                ),
                              ),
                            ),
                          ),
                        ),
                        Positioned(
                          bottom: 75,
                          child: Container(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.white),
                              onPressed: () {
                                setState(() {
                                  isVisible = true;
                                  _boolfade = true;
                                });

                                String select_this_date =
                                    "${dateFormat.day}-${dateFormat.month}-${dateFormat.year}";
                                String select_this_time =
                                    "${timeFormat.format(DateTime.now().toLocal())}";

                                final historyData = History_data(
                                  date: select_this_date,
                                  start_at: select_this_time,
                                  end_at: "N/A",
                                  parkingSlot: ParkingSlot(
                                    id: widget.parking_slots_id ?? '',
                                    slot_number: widget.slot_number ?? '',
                                    status: widget.status ?? '',
                                    floorId: widget.floor_number ?? '',
                                    floor: Floor(
                                      id: widget.floor_number ?? '',
                                      floor_number: widget.floor_number ?? '',
                                    ),
                                  ),
                                );
                                BlocProvider.of<ReservedBloc>(context)
                                    .add(SendReservation(historyData));
                                debugPrint(
                                    "Date: ${historyData.date} Start Time: ${historyData.start_at} End Time: ${historyData.end_at} Slot Number: ${historyData.parkingSlot.slot_number} Status: ${historyData.parkingSlot.status} Floor Number: ${historyData.parkingSlot.floor.floor_number}");
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: Column(
                                      children: [
                                        Icon(Icons.check_circle,
                                            color: Colors.green, size: 50),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 10),
                                          child: Text(
                                            "Reservation Success",
                                            style: TextStyle(
                                                fontFamily: "Amiko",
                                                fontSize: 18,
                                                fontWeight: FontWeight.w700,
                                                color: Colors.black),
                                          ),
                                        ),
                                      ],
                                    ),
                                    // content: Row(
                                    //   mainAxisAlignment:
                                    //       MainAxisAlignment.center,
                                    //   children: [
                                    //     Flexible(
                                    //       child: Text(
                                    //         "",
                                    //       ),
                                    //     ),
                                    //   ],
                                    // ),
                                    actions: [
                                      Center(
                                        child: ElevatedButton(
                                            style: ElevatedButton.styleFrom(
                                                backgroundColor: Colors.green),
                                            onPressed: () {
                                              Navigator.of(context).pop();
                                            },
                                            child: Padding(
                                              padding:
                                                  const EdgeInsets.symmetric(
                                                      horizontal: 75),
                                              child: Text("OK",
                                                  style: TextStyle(
                                                      fontFamily: "Amiko",
                                                      fontWeight:
                                                          FontWeight.w700,
                                                      fontSize: 16,
                                                      color: Colors.white)),
                                            )),
                                      ),
                                    ],
                                  ),
                                );
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                                child: Text(
                                  "Reserved",
                                  style: TextStyle(
                                      fontFamily: "Amiko",
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.black),
                                ),
                              ),
                            ),
                          ),
                        ),
                      ],
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
}
