import 'package:flutter/material.dart';
import 'package:car_parking_reservation/history.dart';
import 'package:car_parking_reservation/reserv.dart';
import 'package:car_parking_reservation/setting.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;

  static const List<Map<String, String>> parking_lot = [
    {"id": "1", "name": "A3", "status": "reserve"},
    {"id": "2", "name": "A2", "status": "working"},
    {"id": "3", "name": "A1", "status": "null"},
    {"id": "4", "name": "B3", "status": "working"},
    {"id": "5", "name": "B2", "status": "null"},
    {"id": "6", "name": "B1", "status": "reserve"},
  ];

  static final List<Widget> _widgetOptions = <Widget>[
    const HomeScreen(), // ✅ เพิ่มหน้าจอ Home เข้ามา
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
class HomeScreen extends StatelessWidget {
  const HomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    List<Map<String, String>> leftParking = _HomeState.parking_lot
        .where((p) => p["name"]!.startsWith("A"))
        .toList();
    List<Map<String, String>> rightParking = _HomeState.parking_lot
        .where((p) => p["name"]!.startsWith("B"))
        .toList();

    return Stack(
      children: [
        Column(
          children: [
            const Text(
              'Parking Zone',
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
          top: MediaQuery.of(context).size.height * 0.27,
          child: Column(
            children: leftParking
                .map((parking) => buildParkingButton(parking))
                .toList(),
          ),
        ),
        Positioned(
          right: 20,
          top: MediaQuery.of(context).size.height * 0.27,
          child: Column(
            children: rightParking
                .map((parking) => buildParkingButton(parking))
                .toList(),
          ),
        ),
      ],
    );
  }

  /// 🔹 ฟังก์ชันสร้างปุ่มจอดรถ
  static Widget buildParkingButton(Map<String, String> parking) {
    return Column(
      children: [
        SizedBox(
          width: 145,
          height: 80,
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
              parking["name"]!,
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 22,
                  fontWeight: FontWeight.bold),
            ),
            onPressed: () {
              //print("Parking ${parking["name"]} pressed");
              // Navigator.push(
              //   //context,
              //   MaterialPageRoute(
              //       builder: (context) => const Reserv(),
              //       settings:
              //           RouteSettings(arguments: {"name": parking["name"]})),
              // );
            },
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
              parking["status"] == "null" ? "Available" : parking["status"]!,
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
      case "working":
        return Colors.red;
      case "reserve":
        return Colors.amber;
      case "null":
      default:
        return Colors.green;
    }
  }
}
