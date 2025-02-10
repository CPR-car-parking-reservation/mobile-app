import 'package:flutter/material.dart';

class Reserv extends StatefulWidget {
  final String? bookingSlots;
  final String? bookingDate;
  const Reserv({super.key, this.bookingSlots, this.bookingDate});

  @override
  State<Reserv> createState() => _ReservState();
}

class _ReservState extends State<Reserv> {
  String? selectedTime;
  bool isVisible = false;
  final List<String> timeSlots = [
    "07:00",
    "08:00",
    "09:00",
    "10:00",
  ];

  void _onDropdownChanged(String? newValue) {
    setState(() {
      selectedTime = newValue;
    });
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
                Divider(height: 10, endIndent: 40, indent: 40),
                Text(
                  "${widget.bookingSlots}",
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
                Text(
                  "PARKING ZONE: ${widget.bookingSlots}",
                  style: TextStyle(
                      fontFamily: "Amiko",
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Colors.white),
                ),
                Text(
                  "Date : 31 / 01 / 2568", //"Date: ${widget.bookingDate}",
                  style: TextStyle(
                      fontFamily: "Amiko",
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Colors.white),
                ),
                Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Container(
                    padding: EdgeInsets.symmetric(horizontal: 16),
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: DropdownButton<String>(
                      hint: Text("Select Time"),
                      borderRadius: BorderRadius.circular(20),
                      dropdownColor: Colors.white,
                      value: selectedTime,
                      icon: Icon(
                        Icons.arrow_drop_down_rounded,
                        size: 36,
                      ),
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: "Amiko",
                          fontWeight: FontWeight.w600),
                      onChanged: _onDropdownChanged,
                      isExpanded: true,
                      items: timeSlots.map((String time) {
                        return DropdownMenuItem(
                          value: time,
                          child: Text(time),
                        );
                      }).toList(),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.only(top: 80),
                  child: Row(
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
                              child: Visibility(
                                visible: isVisible,
                                child: ElevatedButton(
                                  style: ElevatedButton.styleFrom(
                                      backgroundColor: Colors.white),
                                  onPressed: () {},
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
                          Positioned(
                            child: ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFF29CE79)),
                              onPressed: () {
                                setState(() {
                                  isVisible = !isVisible;
                                });
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    horizontal: 10, vertical: 10),
                                child: Text(
                                  "Reserve",
                                  style: TextStyle(
                                      fontFamily: "Amiko",
                                      fontSize: 18,
                                      fontWeight: FontWeight.w700,
                                      color: Colors.white),
                                ),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
