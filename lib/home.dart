import 'package:flutter/material.dart';
import 'package:car_parking_reservation/history.dart';
import 'package:car_parking_reservation/reserv.dart';
import 'package:car_parking_reservation/setting/setting_page.dart';



class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;

  static const List<Map<String, dynamic>> floor_park_slot = [
    {
      "data": [
        {
          "id": "8d29898f-8958-4b3d-be4c-2cc4f0043bd2",
          "slot_number": "A1",
          "status": "IDLE",
          "floor_id": "eb289864-28c5-4bf5-8913-6fbfe5556017",
          "floor": {
            "id": "eb289864-28c5-4bf5-8913-6fbfe5556017",
            "floor_number": "F1"
          }
        },
        {
          "id": "05e68638-7b3c-4ad1-9002-c8bcc9fe89b2",
          "slot_number": "A2",
          "status": "WORKING",
          "floor_id": "8d5eae91-064c-4567-b8a8-6591036da0f3",
          "floor": {
            "id": "8d5eae91-064c-4567-b8a8-6591036da0f3",
            "floor_number": "F1"
          }
        },
        {
          "id": "7a73c6f4-cd57-4c75-bb7b-45e4d946d5a6",
          "slot_number": "A3",
          "status": "RESERVE",
          "floor_id": "a6a52cf9-9201-4d57-b652-5272bae5de62",
          "floor": {
            "id": "a6a52cf9-9201-4d57-b652-5272bae5de62",
            "floor_number": "F1"
          }
        },
        {
          "id": "4b96658a-5bf6-4257-8bd2-7068dd484e6d",
          "slot_number": "B1",
          "status": "RESERVE",
          "floor_id": "d55f5330-6814-4691-a275-73df2151d929",
          "floor": {
            "id": "d55f5330-6814-4691-a275-73df2151d929",
            "floor_number": "F1"
          }
        },
        {
          "id": "f9d02c22-e819-4976-ae09-a2742d621d6c",
          "slot_number": "B2",
          "status": "IDLE",
          "floor_id": "1bb9f983-7303-41aa-98cd-74e95ae3b3dd",
          "floor": {
            "id": "1bb9f983-7303-41aa-98cd-74e95ae3b3dd",
            "floor_number": "F1"
          }
        },
        {
          "id": "7f11e5a6-616a-40ed-8ed8-7ef7e15feea5",
          "slot_number": "B3",
          "status": "IDLE",
          "floor_id": "9fd8bd31-0668-421a-878c-0272624510ac",
          "floor": {
            "id": "9fd8bd31-0668-421a-878c-0272624510ac",
            "floor_number": "F1"
          }
        },
        {
          "id": "977f5c81-d138-4376-acb3-5ca4fab25f4c",
          "slot_number": "C1",
          "status": "RESERVE",
          "floor_id": "9fd8bd31-0668-421a-878c-0272624510ac",
          "floor": {
            "id": "9fd8bd31-0668-421a-878c-0272624510ac",
            "floor_number": "F2"
          }
        },
        {
          "id": "5bf423ac-c3ff-4784-ba83-f380a6565a33",
          "slot_number": "C2",
          "status": "IDLE",
          "floor_id": "6c851134-44ad-4f7c-bb59-f0515a987191",
          "floor": {
            "id": "6c851134-44ad-4f7c-bb59-f0515a987191",
            "floor_number": "F2"
          }
        },
        {
          "id": "ef6198de-7dd0-4132-81c4-8f1f6cead563",
          "slot_number": "C3",
          "status": "WORKING",
          "floor_id": "303705e6-f9cd-49f0-abc2-caa831c8a8a6",
          "floor": {
            "id": "303705e6-f9cd-49f0-abc2-caa831c8a8a6",
            "floor_number": "F2"
          }
        },
        {
          "id": "1cfa28f5-df35-4eb7-86c0-fca328896bcb",
          "slot_number": "D1",
          "status": "IDLE",
          "floor_id": "2fba6118-b36c-4cb5-979c-6b02a7cb811f",
          "floor": {
            "id": "2fba6118-b36c-4cb5-979c-6b02a7cb811f",
            "floor_number": "F2"
          }
        },
        {
          "id": "0b044b2f-cb5d-4a30-b257-8d519934df67",
          "slot_number": "D2",
          "status": "IDLE",
          "floor_id": "21a404cc-aa50-49e7-a2dc-9ddc6e70174a",
          "floor": {
            "id": "21a404cc-aa50-49e7-a2dc-9ddc6e70174a",
            "floor_number": "F2"
          }
        },
        {
          "id": "b3353ade-5452-43bd-b427-e1cdd4697bb2",
          "slot_number": "D3",
          "status": "IDLE",
          "floor_id": "8ade9455-73ba-4984-b89c-0977ef57b944",
          "floor": {
            "id": "8ade9455-73ba-4984-b89c-0977ef57b944",
            "floor_number": "F2"
          }
        },
        {
          "id": "b3353ade-5452-43bd-b427-e1cdd4697bb2",
          "slot_number": "D3",
          "status": "WORKING",
          "floor_id": "8ade9455-73ba-4984-b89c-0977ef57b944",
          "floor": {
            "id": "8ade9455-73ba-4984-b89c-0977ef57b944",
            "floor_number": "F3"
          }
        },
      ]
    }
  ];

  static final List<Widget> _widgetOptions = <Widget>[
    HomeScreen(), // ✅ เพิ่มหน้าจอ Home เข้ามา
    const Reserv(),
    const History(),
    const Setting(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color.fromRGBO(3, 23, 76, 1),
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Image.asset("assets/images/LogoCARPAKING.png", height: 50),
          ],
        ),
      ),
      body: _widgetOptions[_selectedIndex], // ✅ โหลดหน้าตาม _selectedIndex
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.fixed,
        backgroundColor: const Color.fromRGBO(3, 23, 76, 1),
        selectedItemColor: Colors.white,
        unselectedItemColor: Colors.grey[400],
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(icon: Icon(Icons.home), label: 'Home'),
          BottomNavigationBarItem(icon: Icon(Icons.flag), label: 'Reservation'),
          BottomNavigationBarItem(icon: Icon(Icons.history), label: 'History'),
          BottomNavigationBarItem(icon: Icon(Icons.settings), label: 'Setting'),
        ],
        currentIndex: _selectedIndex,
        onTap: _onItemTapped,
      ),
    );
  }
}

/// 🔹 สร้าง HomeScreen แยกออกมา (Parking Zone)
class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  String selectedFloor = "F1";

  List<String> get floorNumbers {
    return _HomeState.floor_park_slot
        .expand((p) => p["data"] as List<Map<String, dynamic>>)
        .map((slot) => slot["floor"]["floor_number"] as String)
        .toSet()
        .toList()
      ..sort();
  }

  void changeFloor(bool next) {
    List<String> floors = floorNumbers;
    int currentIndex = floors.indexOf(selectedFloor);

    if (next && currentIndex < floors.length - 1) {
      setState(() {
        selectedFloor = floors[currentIndex + 1];
      });
    } else if (!next && currentIndex > 0) {
      setState(() {
        selectedFloor = floors[currentIndex - 1];
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    List<Map<String, dynamic>> slots = _HomeState.floor_park_slot
        .expand((p) => p["data"] as List<Map<String, dynamic>>)
        .where((slot) => slot["floor"]["floor_number"] == selectedFloor)
        .toList();

    List<List<Map<String, dynamic>>> leftSlots = [];
    List<List<Map<String, dynamic>>> rightSlots = [];

    for (var slot in slots) {
      if (leftSlots.isEmpty || leftSlots.last.length < 3) {
        if (leftSlots.isEmpty || leftSlots.last.length >= 3) {
          leftSlots.add([]);
        }
        leftSlots.last.add(slot);
      } else {
        if (rightSlots.isEmpty || rightSlots.last.length >= 3) {
          rightSlots.add([]);
        }
        rightSlots.last.add(slot);
      }
    }

    return Stack(
      children: [
        Column(
          children: [
            Text(
              'Parking Zone: $selectedFloor',
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 26,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Amiko"),
            ),
            const Divider(
              color: Colors.white,
              thickness: 1.5,
              indent: 100,
              endIndent: 100,
            ),
            Expanded(
              child: Container(
                decoration: const BoxDecoration(
                  image: DecorationImage(
                      image: AssetImage("assets/images/parkzone.png"),
                      fit: BoxFit.cover),
                ),
              ),
            ),
          ],
        ),
        Positioned(
          left: 20,
          top: MediaQuery.of(context).size.height * 0.29,
          child: Column(
            children: leftSlots
              .map((column) =>
                Column(children: column.reversed.map(buildParkingButton).toList()))
              .toList(),
          ),
        ),
        Positioned(
          right: 20,
          top: MediaQuery.of(context).size.height * 0.29,
          child: Column(
            children: rightSlots
                .map((column) =>
                    Column(children: column.reversed.map(buildParkingButton).toList()))
                .toList(),
          ),
        ),
        Column(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                if(selectedFloor == floorNumbers.first)
                  const SizedBox(width: 50),
                if (selectedFloor != floorNumbers.first)
                  IconButton(
                    icon: const Icon(Icons.arrow_back_ios, color: Colors.white),
                    onPressed: () => changeFloor(false),
                  ),
                if (selectedFloor != floorNumbers.last)
                  IconButton(
                    icon: const Icon(Icons.arrow_forward_ios,
                        color: Colors.white),
                    onPressed: () => changeFloor(true),
                  ),
              ],
            ),
          ],
        ),
      ],
    );
  }

  static Widget buildParkingButton(Map<String, dynamic> parking) {
    return Column(
      children: [
        SizedBox(
          width: 135,
          height: 72,
          child: FloatingActionButton(
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: BorderSide(
                  style: BorderStyle.solid,
                  width: 4,
                  color: getStatusColor(parking["status"]!)),
            ),
            child: Text(
              parking["slot_number"],
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 22,
                  fontWeight: FontWeight.bold),
            ),
            onPressed: () {},
          ),
        ),
        Container(
          width: 145,
          height: 20,
          margin: const EdgeInsets.only(top: 10, bottom: 10),
          decoration: BoxDecoration(
            color: getStatusColor(parking["status"]!),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Text(
              parking["status"] ?? "Available",
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 12,
                  fontWeight: FontWeight.bold,
                  fontFamily: "Amiko"),
            ),
          ),
        ),
      ],
    );
  }

  static Color getStatusColor(String status) {
    switch (status) {
      case "WORKING":
        return Colors.red;
      case "RESERVE":
        return Colors.amber;
      case "IDLE":
      default:
        return Colors.green;
    }
  }
}
