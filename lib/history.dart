import 'dart:developer';

import 'package:car_parking_reservation/Widget/custom_dialog.dart';
import 'package:car_parking_reservation/bloc/history/history_bloc.dart';
import 'package:car_parking_reservation/bloc/reserved/reserved_bloc.dart';
import 'package:car_parking_reservation/model/reservation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:intl/intl.dart';

class History extends StatefulWidget {
  const History({super.key});

  @override
  State<History> createState() => _HistoryState();

  static getStatusColor(String status) {
    switch (status) {
      case "CANCEL":
        return Colors.red;
      case "OCCUPIED":
        return Colors.grey;
      case "SUCCESS":
        return Colors.green;
      case "EXPIRED":
        return Colors.amber;
      case "WAITING":
      default:
        return Colors.blue;
    }
  }
}

class _HistoryState extends State<History> {
  void initState() {
    super.initState();
    context.read<HistoryBloc>().add(FetchFirstHistory());
  }

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
            BlocListener<HistoryBloc, HistoryState>(
              listener: (context, state) {
                if (state is HistoryError) {
                  showCustomDialogError(context, state.message);
                }
              },
              child: Expanded(
                child: BlocBuilder<HistoryBloc, HistoryState>(
                  builder: (context, state) {
                    if (state is HistoryLoading) {
                      return const Center(child: CircularProgressIndicator());
                    }
                    if (state is HistoryError) {
                      return Center(child: Text(state.message));
                    }
                    if (state is HistoryLoaded) {
                      return ListView.builder(
                        padding: const EdgeInsets.only(top: 20, bottom: 10),
                        itemCount: state.history.length,
                        itemBuilder: (context, index) {
                          final history_user = state.history[index];

                          //display local time zone
                          final history_date_start =
                              history_user.startAt!.toLocal();
                          var history_date_end = history_user.endAt == null
                              ? ''
                              : history_user.endAt!.toLocal();

                          final date_start =
                              DateTime.parse(history_date_start.toString());

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
                                      padding: const EdgeInsets.only(
                                          top: 50, left: 25),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
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
                                                "${date_start.hour.toString().padLeft(2, '0')}:${date_start.minute.toString().padLeft(2, '0')}:${date_start.second.toString().padLeft(2, '0')}" ??
                                                    'N/A',
                                                style: const TextStyle(
                                                    fontFamily: "Amiko",
                                                    fontSize: 16),
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
                                                history_date_end.toString() ==
                                                        ''
                                                    ? 'N/A'
                                                    : "${(DateTime.parse(history_date_end.toString())).hour.toString().padLeft(2, '0')}:${(DateTime.parse(history_date_end.toString())).minute.toString().padLeft(2, '0')}:${(DateTime.parse(history_date_end.toString())).second.toString()}",
                                                style: const TextStyle(
                                                    fontFamily: "Amiko",
                                                    fontSize: 16),
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
                                                history_user.price.toString() ==
                                                        ''
                                                    ? 'N/A'
                                                    : "${NumberFormat("#,###.##").format(double.parse(history_user.price.toString()))} ฿" ??
                                                        'N/A',
                                                style: const TextStyle(
                                                    fontFamily: "Amiko",
                                                    fontSize: 16),
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
                                      width: 175,
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
                                              "${date_start.day.toString().padLeft(2, '0')}-${date_start.month.toString().padLeft(2, '0')}-${date_start.year.toString()}" ??
                                                  'N/A',
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
                                    right: 10,
                                    top: 10,
                                    child: Container(
                                      decoration: BoxDecoration(
                                        color: History.getStatusColor(
                                            history_user.status),
                                        borderRadius: BorderRadius.circular(20),
                                      ),
                                      child: Padding(
                                        padding: const EdgeInsets.all(8.0),
                                        child: Padding(
                                          padding: const EdgeInsets.symmetric(
                                              horizontal: 5, vertical: 2.5),
                                          child: Row(
                                            children: [
                                              Text(
                                                history_user.status ?? 'N/A',
                                                style: const TextStyle(
                                                    color: Colors.white,
                                                    fontFamily: "Amiko",
                                                    fontSize: 10,
                                                    fontWeight:
                                                        FontWeight.w700),
                                              ),
                                            ],
                                          ),
                                        ),
                                      ),
                                    ),
                                  ),
                                  Positioned(
                                    left: 285,
                                    bottom: 20,
                                    child: Container(
                                      height: 20,
                                      width: 50,
                                      decoration: const BoxDecoration(
                                          color: Colors.white),
                                      child: Center(
                                        child: Text(
                                          history_user.parkingSlot.slotNumber
                                                  .toString() ??
                                              'N/A',
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
                      );
                    }
                    return const SizedBox();
                  },
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
