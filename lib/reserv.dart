import 'package:car_parking_reservation/Bloc/reserved/reserved_bloc.dart';
import 'package:car_parking_reservation/Qr-generator/qr_code.dart';
import 'package:car_parking_reservation/history.dart';
import 'package:car_parking_reservation/model/history.dart';
import 'package:car_parking_reservation/setting/setting_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

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

  final currentDateController = DateTime.now();

  late List<Map<String, dynamic>> history;

  @override
  void initState() {
    super.initState();
    history = [
      {
        "date": "2022-01-01",
        "start_at": "10:00",
        "end_at": "12:00",
        "parkingSlot": {
          "id": "1",
          "slot_number": "1",
          "status": "WORKING",
          "floorId": "F1",
          "floor": {"id": "F1", "floor_number": "F1"}
        }
      },
    ];
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
                  "${widget.parking_slots_id}",
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
                                          left: 10, top: 7.5),
                                      child: Text(
                                        "${currentDateController.day}-${currentDateController.month}-${currentDateController.year}  ",
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
                                    Icon(
                                      Icons.access_time,
                                      color: Colors.white,
                                      size: 30,
                                    ),
                                    Padding(
                                      padding: const EdgeInsets.only(
                                          left: 10, top: 7.5),
                                      child: Text(
                                        "${currentDateController.hour.toString().padLeft(2, '0')}:${currentDateController.minute.toString().padLeft(2, '0')}",
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
                                if (currentDateController.hour != 0 &&
                                    currentDateController.minute != 0) {
                                  setState(() {
                                    isVisible = true;
                                    _boolfade = true;
                                  });

                                  String selectThisDate =
                                      "${currentDateController.day}/${currentDateController.month}/${currentDateController.year}";
                                  String selectThisTime =
                                      "${currentDateController.hour.toString().padLeft(2, '0')}:${currentDateController.minute.toString().padLeft(2, '0')}";

                                  ScaffoldMessenger.of(context).showSnackBar(
                                    SnackBar(
                                      backgroundColor: const Color(0xFF29CE79),
                                      duration: Duration(milliseconds: 1500),
                                      content: Padding(
                                        padding:
                                            const EdgeInsets.only(left: 20),
                                        child: Row(
                                          children: [
                                            Icon(
                                              Icons.check_circle,
                                              color: Colors.white,
                                            ),
                                            Padding(
                                              padding: const EdgeInsets.only(
                                                  left: 20),
                                              child: Text(
                                                'Success',
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

                                  final historyData = History_data(
                                    // ส่งค่าไปที่ Bloc
                                    date: selectThisDate,
                                    start_at: selectThisTime,
                                    end_at:
                                        "N/A", // ถ้ายังไม่มีค่า end_at ให้ใช้ "N/A" หรือช่องว่างตามที่ต้องการ
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
                                      "dadadada $selectThisTime /  $selectThisDate / ${widget.parking_slots_id} / ${widget.slot_number}");
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
