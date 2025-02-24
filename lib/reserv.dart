import 'package:car_parking_reservation/history.dart';
import 'package:car_parking_reservation/setting/setting_page.dart';
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

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
  State<Reserv> createState() => _ReservState();
}

class _ReservState extends State<Reserv> {
  bool isVisible = false;
  bool _boolfade = true;

  TimeOfDay? select_time;
  TimePickerEntryMode entryMode = TimePickerEntryMode.dial;
  Orientation? orientation;
  TextDirection textDirection = TextDirection.ltr;
  MaterialTapTargetSize tapTargetSize = MaterialTapTargetSize.padded;
  bool use24HourTime = false;
  DateTime time = DateTime.now();

  final currentDateController = DateTime.now();

  void _showDialog(Widget child) {
    showCupertinoModalPopup<void>(
      context: context,
      builder: (BuildContext context) => Container(
        height: 216,
        padding: const EdgeInsets.only(top: 6.0),
        // The Bottom margin is provided to align the popup above the system
        // navigation bar.
        margin: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom,
        ),
        // Provide a background color for the popup.
        color: CupertinoColors.systemBackground.resolveFrom(context),
        // Use a SafeArea widget to avoid system overlaps.
        child: SafeArea(top: false, child: child),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF03174C),
      body: SingleChildScrollView(
        child: Center(
          child: Padding(
            padding: EdgeInsets.all(15),
            child: Column(
              children: [
                Text(
                  "Reservation Your Parking",
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
                  "${widget.parking_slots_id}",
                  style: TextStyle(
                      fontFamily: "Amiko",
                      fontSize: 38,
                      fontWeight: FontWeight.w700,
                      color: Colors.white),
                ),
                Image.asset(
                  "assets/images/cartopview2.png",
                  height: 300,
                ),
                Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "PARKING ZONE ${widget.floor_number}",
                        style: TextStyle(
                            fontFamily: "Amiko",
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Colors.white),
                      ),
                      Text(
                        "Date : ${currentDateController.day}/${currentDateController.month}/${currentDateController.year}",
                        style: TextStyle(
                            fontFamily: "Amiko",
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Colors.white),
                      ),
                      Text(
                        // "${select_time.format(context)}",
                        // "${select_time.hour}:${select_time.minute}",
                        "${select_time != null ? '${select_time!.hour} : ${select_time!.minute}' : '--> No time selected <--'}",
                        style: TextStyle(
                            fontFamily: "Amiko",
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Colors.white),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(25),
                  child: Container(
                    height: 55,
                    width: 200,
                    decoration: BoxDecoration(
                        borderRadius: BorderRadius.circular(30),
                        color: Colors.white),
                    child: CupertinoButton(
                      onPressed: () => _showDialog(
                        CupertinoDatePicker(
                            initialDateTime: time,
                            mode: CupertinoDatePickerMode.time,
                            use24hFormat: true,
                            onDateTimeChanged: (DateTime newTime) {
                              setState(() {
                                select_time = TimeOfDay(
                                    hour: newTime.hour, minute: newTime.minute);
                              });
                            }),
                      ),
                      child: Text(
                        '${select_time != null ? 'Change Time' : 'Select Time'}',
                        style: TextStyle(
                            fontFamily: "Amiko",
                            fontSize: 20,
                            fontWeight: FontWeight.w700,
                            color: Colors.black),
                      ),
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Stack(
                      alignment: Alignment.center,
                      children: [
                        SizedBox(
                          width: 350,
                          height: 50,
                        ),
                        Positioned(
                          right: 20,
                          child: SizedBox(
                            width: 200,
                            child: AnimatedOpacity(
                              opacity: _boolfade ? 1.0 : 0.0,
                              duration: const Duration(milliseconds: 500),
                              child: Visibility(
                                visible: isVisible,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white),
                                  onPressed: () {
                                    setState(() {
                                      isVisible = false;
                                      _boolfade = false;
                                    });
                                  },
                                  child: Padding(
                                    padding: const EdgeInsets.symmetric(
                                        horizontal: 5, vertical: 11),
                                    child: Row(
                                      mainAxisAlignment: MainAxisAlignment.end,
                                      children: [
                                        Text(
                                          "QR",
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
                          child: Container(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF29CE79)),
                              onPressed: () {
                                if (select_time != null) {
                                  setState(() {
                                    isVisible = true;
                                    _boolfade = true;
                                  });
                                } else {
                                  setState(() {
                                    isVisible = false;
                                    _boolfade = false;
                                  });
                                  showDialog(
                                    context: context,
                                    builder: (context) => AlertDialog(
                                      actions: [
                                        TextButton(
                                          onPressed: () {
                                            Navigator.of(context).pop();
                                          },
                                          child: Text("Close"),
                                        )
                                      ],
                                      title: Text("WARNING"),
                                      content: Text(
                                          "You need to select a time to reservation"),
                                    ),
                                  );
                                }
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
                                      color: Colors.white),
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
