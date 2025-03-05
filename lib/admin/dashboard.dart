import 'package:car_parking_reservation/admin/widgets/dashboard/barchart.dart';
import 'package:car_parking_reservation/admin/widgets/dashboard/container.dart';
import 'package:car_parking_reservation/admin/widgets/dashboard/toppic.dart';
import 'package:flutter/material.dart';

class AdminDashBoard extends StatefulWidget {
  const AdminDashBoard({super.key});

  @override
  State<AdminDashBoard> createState() => _AdminDashBoardState();
}

class _AdminDashBoardState extends State<AdminDashBoard> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Padding(
        padding: const EdgeInsets.all(8.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              Text(
                "DashBoard",
                style: TextStyle(
                    fontFamily: "Amiko",
                    fontSize: 26,
                    fontWeight: FontWeight.w700,
                    color: Colors.black),
              ),
              Divider(
                height: 10,
                endIndent: 60,
                indent: 60,
                color: const Color(0xFF03174C),
              ),
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  children: [
                    TopicDashboard(title: "Parking Status"),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        CustomContainer(
                            // ignore: deprecated_member_use
                            color: const Color(0xFF29CE79).withOpacity(0.75),
                            icon: Icons.info_rounded,
                            title: "    IDLE",
                            value: "17"),
                        CustomContainer(
                            // ignore: deprecated_member_use
                            color: Colors.red.withOpacity(0.75),
                            icon: Icons.directions_car_rounded,
                            title: "   FULL",
                            value: "4"),
                      ],
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        CustomContainer(
                            // ignore: deprecated_member_use
                            color: const Color(0xFFFFA600).withOpacity(0.75),
                            icon: Icons.info_rounded,
                            title: "RESERVED",
                            value: "8"),
                        CustomContainer(
                            // ignore: deprecated_member_use
                            color: Colors.grey.withOpacity(0.75),
                            icon: Icons.cancel,
                            title: "MAINTAIN",
                            value: "9"),
                      ],
                    ),
                    TopicDashboard(title: "Statistic"),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceAround,
                      children: [
                        CustomContainer(
                            color: const Color(0xFF03174C),
                            icon: Icons.supervisor_account_rounded,
                            title: "Total User",
                            value: "30"),
                        CustomContainer(
                            color: const Color(0xFF03174C),
                            icon: Icons.attach_money_rounded,
                            title: "Total Cash",
                            value: "300"),
                      ],
                    ),
                    Padding(
                      padding: const EdgeInsets.all(8.0),
                      child: BarChartSample2(),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
