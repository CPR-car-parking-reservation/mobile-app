
import 'package:car_parking_reservation/Widget/home.dart';
import 'package:car_parking_reservation/bloc/reserved/reserved_bloc.dart';
import 'package:car_parking_reservation/Qr-generator/qr_code.dart';
import 'package:car_parking_reservation/model/car.dart';
import 'package:car_parking_reservation/model/history.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/intl.dart';
import 'package:intl/date_symbol_data_local.dart';
import 'package:shared_preferences/shared_preferences.dart';

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
  String? _selectedValue;
  late List<car_data> carData;

  final dateFormat = DateFormat("yyyy-MM-dd'T'HH:mm:ss.SSS'Z'");
  final currentDate = DateTime.now().toUtc().add(Duration(hours: 7));

  late List<Map<String, dynamic>> history;

  @override
  void initState() {
    initializeDateFormatting();
    history = [];
    carData = [];
    context.read<ReservedBloc>().add(FectchFirstReserved());
    _loadToken();
    super.initState();
  }

  String userToken = "";
  String baseUrl = dotenv.env['BASE_URL'].toString();

  // ดึง token จาก SharedPreferences
  void _loadToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userToken = prefs.getString('token') ?? ''; // ถ้าไม่มี token จะใช้ค่าว่าง
    });
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ReservedBloc, ReservedState>(
      listener: (context, state) {
        if (state is ReservedSuccess) {
          Navigator.pushAndRemoveUntil(
            context,
            MaterialPageRoute(builder: (context) => Home()),
            (route) => false, // ลบทุกเส้นทางที่ผ่านมาหมด
          );
        } else if (state is ReservedError) {}
      },
      child: Scaffold(
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
        body: BlocBuilder<ReservedBloc, ReservedState>(
          builder: (context, state) {
            if (state is ReserveLoading) {
              return Center(child: CircularProgressIndicator());
            } else if (state is ReservedLoaded) {
              carData = state.carData;
            } else if (state is ReservedError) {
              return Center(child: Text(state.message));
            }

            return SingleChildScrollView(
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
                      Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Container(
                          padding: EdgeInsets.symmetric(horizontal: 16),
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: DropdownButtonHideUnderline(
                            child: DropdownButton<String>(
                              hint: Text("Select License Plate",
                                  style: TextStyle(color: Colors.grey)),
                              value: _selectedValue,
                              icon: Icon(Icons.arrow_drop_down_rounded,
                                  size: 36, color: Colors.black),
                              style: TextStyle(
                                  color: Colors.black,
                                  fontWeight: FontWeight.w600),
                              onChanged: (String? newValue) {
                                setState(() {
                                  _selectedValue = newValue;
                                });
                              },
                              isExpanded: true,
                              dropdownColor: Colors.white,
                              borderRadius: BorderRadius.circular(20),
                              items: carData.map((car_data car) {
                                return DropdownMenuItem<String>(
                                  value: car.id,
                                  child: Row(
                                    children: [
                                      Image.network(
                                          "$baseUrl${car.image_url}",
                                          height: 50,
                                          width: 50),
                                      Text(" ${car.license_plate} "),
                                    ],
                                  ),
                                );
                              }).toList(),
                            ),
                          ),
                        ),
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
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
                                              "${currentDate.day.toString().padLeft(2, '0')}-${currentDate.month.toString().padLeft(2, '0')}-${currentDate.year}",
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
                                        mainAxisAlignment:
                                            MainAxisAlignment.center,
                                        children: [
                                          Padding(
                                            padding:
                                                const EdgeInsets.only(left: 15),
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
                                              "${currentDate.hour.toString().padLeft(2, '0')}:${currentDate.minute.toString().padLeft(2, '0')}:${currentDate.second.toString().padLeft(2, '0')}",
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
                      Padding(
                        padding: const EdgeInsets.all(10),
                        child: Container(
                          child: ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.white),
                            onPressed: () async {
                              if (_selectedValue != null) {
                                final String select_this_date =
                                    "${dateFormat.format(DateTime.now().toUtc().toLocal().add(Duration(hours: 7)))}";
                                String select_this_time =
                                    "${dateFormat.format(DateTime.now().toUtc().toLocal().add(Duration(hours: 7)))}";

                                log("${dateFormat.format(DateTime.now().toUtc().toLocal().add(Duration(hours: 7)))}");

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
                                context.read<ReservedBloc>().add(
                                    SendReservation(
                                        _selectedValue ?? '',
                                        widget.parking_slots_id ?? '',
                                        select_this_time));
                                //log("car_id: ${_selectedValue}, parking_slot_id: ${historyData.parkingSlot.id}, start_time: ${historyData.start_at}");
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
                                  ),
                                );
                              } else {
                                showDialog(
                                  context: context,
                                  builder: (context) => AlertDialog(
                                    title: Column(
                                      children: [
                                        Icon(Icons.error_rounded,
                                            color: Colors.red, size: 50),
                                        Padding(
                                          padding: const EdgeInsets.symmetric(
                                              vertical: 10),
                                          child: Text(
                                            "Reservation Fail",
                                            style: TextStyle(
                                                fontFamily: "Amiko",
                                                fontSize: 18,
                                                fontWeight: FontWeight.w700,
                                                color: Colors.black),
                                          ),
                                        ),
                                      ],
                                    ),
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
                                    color: Colors.black),
                              ),
                            ),
                          ),
                        ),
                      )
                    ],
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
