import 'package:flutter/material.dart';

class History extends StatefulWidget {
  const History({super.key});

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  final List<Map<String, String>> mockHistoryData = [
    {
      "date": "31/01/2568",
      "inTime": "9.30 am",
      "outTime": "7.30 pm",
      "price": "20 Bath",
      "slot_number": "A1"
    },
    {
      "date": "01/02/2568",
      "inTime": "8.00 am",
      "outTime": "6.00 pm",
      "price": "25 Bath",
      "slot_number": "B2"
    },
  ];

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
            Expanded(
              child: ListView.builder(
                padding: const EdgeInsets.only(top: 20, bottom: 10),
                itemCount: mockHistoryData.length,
                itemBuilder: (context, index) {
                  final item = mockHistoryData[index];
                  return Center(
                    child: Padding(
                      padding: EdgeInsets.all(10),
                      child: Stack(
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
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Row(
                                    children: [
                                      const Text(
                                        "In : ",
                                        style: TextStyle(
                                            fontWeight: FontWeight.w700,
                                            fontFamily: "Amiko",
                                            fontSize: 16),
                                      ),
                                      Text(
                                        item["inTime"] ?? '',
                                        style: const TextStyle(
                                            fontFamily: "Amiko", fontSize: 16),
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
                                        item["outTime"] ?? '',
                                        style: const TextStyle(
                                            fontFamily: "Amiko", fontSize: 16),
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
                                            fontSize: 16),
                                      ),
                                      Text(
                                        item["price"] ?? '',
                                        style: const TextStyle(
                                            fontFamily: "Amiko", fontSize: 16),
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
                              width: 200,
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
                                      item["date"] ?? '',
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
                            left: 285,
                            bottom: 40,
                            child: Container(
                              height: 50,
                              width: 50,
                              decoration:
                                  const BoxDecoration(color: Colors.white),
                              child: Center(
                                child: Text(
                                  item["slot_number"] ?? '',
                                  style: const TextStyle(
                                      fontFamily: "Amiko",
                                      fontSize: 20,
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
              ),
            ),
          ],
        ),
      ),
    );
  }
}
