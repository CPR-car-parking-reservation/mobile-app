import 'dart:developer';
import 'dart:math';

import 'package:car_parking_reservation/model/admin/dashboard.dart';
import 'package:fl_chart/fl_chart.dart';
import 'package:flutter/material.dart';

class BarChartSample2 extends StatefulWidget {
  final List<ModelGraph> data;
  final String title;
  BarChartSample2({super.key, required this.data, required this.title});

  @override
  State<StatefulWidget> createState() => BarChartSample2State();
}

class BarChartSample2State extends State<BarChartSample2> {
  final double width = 10;

  late List<BarChartGroupData> rawBarGroups;
  late List<BarChartGroupData> showingBarGroups;

  int touchedGroupIndex = -1;

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    if (widget.data.isEmpty) {
      return const Center(
          child:
              Text("No Data Available", style: TextStyle(color: Colors.white)));
    }
    //find max value of data_number
    double maxY = 0;
    for (int i = 0; i < widget.data.length; i++) {
      if (widget.data[i].data_number > maxY) {
        maxY = widget.data[i].data_number.toDouble();
      }
    }
    if (maxY == 0) {
      maxY = 100;
    }
    maxY = (maxY * 1.1).ceilToDouble(); // เพิ่ม 20% margin

    // ปรับ maxY ให้เป็นค่าที่หาร 100 ลงตัว
    maxY = ((maxY / 100).ceil() * 100).toDouble();

    // สร้างข้อมูลของ BarChart
    showingBarGroups = widget.data.asMap().entries.map((entry) {
      int index = entry.key;
      ModelGraph item = entry.value;
      return makeGroupData(
          index, item.data_number.toDouble()); // ใช้ค่าจริงจาก data
    }).toList();

    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(15.0),
        color: const Color(0xFF03174C),
      ),
      child: Padding(
        padding: const EdgeInsets.symmetric(horizontal: 15.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.stretch,
          children: [
            Padding(
              padding: const EdgeInsets.only(top: 25),
              child: Text(
                '${widget.title} Per Day',
                textAlign: TextAlign.center,
                style: const TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                    fontFamily: "Amiko",
                    fontWeight: FontWeight.w700),
              ),
            ),
            Flexible(
              child: SingleChildScrollView(
                scrollDirection: Axis.horizontal,
                child: Container(
                  width: max(600,
                      widget.data.length * 25), // ขยายความกว้างตามจำนวนข้อมูล
                  child: BarChart(
                    BarChartData(
                      maxY: maxY,
                      titlesData: FlTitlesData(
                        show: true,
                        rightTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        topTitles: const AxisTitles(
                          sideTitles: SideTitles(showTitles: false),
                        ),
                        bottomTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            getTitlesWidget: bottomTitles,
                            reservedSize: 42,
                          ),
                        ),
                        leftTitles: AxisTitles(
                          sideTitles: SideTitles(
                            showTitles: true,
                            reservedSize: 28,
                            interval: maxY / 10,
                            getTitlesWidget: leftTitles,
                            maxIncluded: false,
                          ),
                        ),
                      ),
                      borderData: FlBorderData(
                        show: false,
                      ),
                      barGroups: showingBarGroups,
                      gridData: const FlGridData(show: true),
                    ),
                  ),
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }

// ปรับแกน X ให้แสดงค่า day ของข้อมูลจริง
  Widget bottomTitles(double value, TitleMeta meta) {
    int index = value.toInt();
    if (index < 0 || index >= widget.data.length) return Container();

    String day = widget.data[index].day.toString(); // ใช้ค่าจริงจาก data

    return SideTitleWidget(
      meta: meta,
      space: 10,
      child: Text(day,
          style: const TextStyle(
              color: Colors.white, fontWeight: FontWeight.bold, fontSize: 10)),
    );
  }

  BarChartGroupData makeGroupData(int x, double y1) {
    return BarChartGroupData(barsSpace: 6, x: x, barRods: [
      BarChartRodData(
        toY: y1,
        color: widget.title == "Cash"
            ? Color.fromARGB(255, 103, 233, 109)
            : const Color.fromARGB(255, 255, 135, 203),
        width: width,
      ),
    ]);
  }

// ปรับแกน Y ให้เป็นค่าอัตโนมัติ
  Widget leftTitles(double value, TitleMeta meta) {
    return SideTitleWidget(
      meta: meta,
      space: 5,
      child: Text(
        value.toInt().toString(),
        style: const TextStyle(
            color: Colors.white, fontWeight: FontWeight.bold, fontSize: 10),
      ),
    );
  }
}
