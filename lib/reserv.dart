import 'package:flutter/material.dart';

class Reserv extends StatefulWidget {
  final String? slot_number;
  final String? floor_id;
  final String? status;

  const Reserv({super.key, this.slot_number, this.floor_id, this.status});

  @override
  _ReservState createState() => _ReservState();
}

class _ReservState extends State<Reserv> {
  bool isVisible = true;
  String _dropdownValue = 'one';

  void Dropdowncallback(String? selectedValue) {
    if (selectedValue != null) {
      setState(() {
        _dropdownValue = selectedValue;
      });
    }
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
                  "${widget.slot_number}",
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
                  "PARKING ZONE: ${widget.slot_number}",
                  style: TextStyle(
                      fontFamily: "Amiko",
                      fontSize: 20,
                      fontWeight: FontWeight.w700,
                      color: Colors.white),
                ),
                Text(
                  "Date : 31 / 01 / 2568",
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
                      hint: Text("time"),
                      borderRadius: BorderRadius.circular(20),
                      dropdownColor: Colors.white,
                      value: _dropdownValue,
                      icon: Icon(
                        Icons.arrow_drop_down_rounded,
                        size: 36,
                      ),
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: "Amiko",
                          fontWeight: FontWeight.w600),
                      onChanged: Dropdowncallback,
                      isExpanded: true,
                      items: const [
                        DropdownMenuItem(
                          value: "one",
                          child: Text("One"),
                        ),
                        DropdownMenuItem(
                          value: "two",
                          child: Text("Two"),
                        ),
                        DropdownMenuItem(
                          value: "three",
                          child: Text("Three"),
                        ),
                      ],
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
                            child: Container(
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
