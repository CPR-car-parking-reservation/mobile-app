import 'package:car_parking_reservation/parking_slots/parking_slots.dart';
import 'package:flutter/material.dart';
import 'package:car_parking_reservation/history.dart';
import 'package:car_parking_reservation/reserv.dart';
import 'package:car_parking_reservation/setting/setting_page.dart';
import 'package:car_parking_reservation/model/parking_slot.dart';

class Home extends StatefulWidget {
  final int initialIndex;
  final ParkingSlot? slot;
  const Home({super.key, this.initialIndex = 0, this.slot});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _selectedIndex = 0;

  static final List<Widget> _widgetOptions = <Widget>[
    ParkingSlots(), // ✅ เพิ่มหน้าจอ Home เข้ามา
    Reserv(
      slot_number: '',
      floor_id: '',
      status: '',
    ),
    const History(),
    const Setting(),
  ];

  void _onItemTapped(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  void initState() {
    super.initState();
    _selectedIndex = widget.initialIndex;
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
      body: _selectedIndex == 1 && widget.slot != null
          ? Reserv(
              slot_number: widget.slot!.slot_number,
              floor_id: widget.slot!.floor.id,
              status: widget.slot!.status,
            )
          : _widgetOptions[_selectedIndex],
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
