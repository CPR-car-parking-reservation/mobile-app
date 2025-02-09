import 'package:flutter/material.dart';

class History extends StatefulWidget {
  const History({super.key});

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF03174C),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              "History",
              style: TextStyle(
                  fontFamily: "Amiko",
                  fontSize: 26,
                  fontWeight: FontWeight.w700,
                  color: Colors.white),
            ),
            Divider(
              height: 10,
              endIndent: 60,
              indent: 60,
            ),
            Padding(
              padding: const EdgeInsets.only(top: 20, bottom: 10),
              child: Column(
                children: [
                  Stack(
                    children: [
                      Container(
                        height: 130,
                        width: 350,
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(20),
                        ),
                        child: Padding(
                          padding: const EdgeInsets.only(top: 50, left: 25),
                          child: Container(
                            child: Column(
                              children: [
                                Row(
                                  children: [
                                    Text(
                                      "In : ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontFamily: "Amiko",
                                          fontSize: 16),
                                    ),
                                    Text(
                                      "9.30 am",
                                      style: TextStyle(
                                          fontFamily: "Amiko", fontSize: 16),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "Out : ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontFamily: "Amiko",
                                          fontSize: 16),
                                    ),
                                    Text(
                                      "7.30 pm",
                                      style: TextStyle(
                                          fontFamily: "Amiko", fontSize: 16),
                                    ),
                                  ],
                                ),
                                Row(
                                  children: [
                                    Text(
                                      "Price : ",
                                      style: TextStyle(
                                          fontWeight: FontWeight.w700,
                                          fontFamily: "Amiko",
                                          fontSize: 16),
                                    ),
                                    Text(
                                      "20 Bath",
                                      style: TextStyle(
                                          fontFamily: "Amiko", fontSize: 16),
                                    ),
                                  ],
                                ),
                              ],
                            ),
                          ),
                        ),
                      ),
                      Padding(
                        padding: const EdgeInsets.all(8.0),
                        child: Container(
                          height: 35,
                          width: 200,
                          decoration: BoxDecoration(
                            color: const Color(0xFF03174C),
                            borderRadius: BorderRadius.circular(20),
                          ),
                          child: Padding(
                            padding: const EdgeInsets.only(
                                left: 20, top: 8, bottom: 10, right: 8),
                            child: Row(
                              children: [
                                Text(
                                  "Date : ",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: "Amiko",
                                      fontWeight: FontWeight.w700),
                                ),
                                Text(
                                  " 31/01/2568",
                                  style: TextStyle(
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
                        left: 285,
                        bottom: 40,
                        child: Container(
                          height: 50,
                          width: 50,
                          decoration: BoxDecoration(color: Colors.white),
                          child: Center(
                              child: Text(
                            "A1",
                            style: TextStyle(
                                fontFamily: "Amiko",
                                fontSize: 20,
                                fontWeight: FontWeight.w700),
                          )),
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
    );
  }
}
