import 'package:car_parking_reservation/Widget/custom_dialog.dart';
import 'package:car_parking_reservation/bloc/history/history_bloc.dart';
import 'package:car_parking_reservation/bloc/reserved/reserved_bloc.dart';
import 'package:car_parking_reservation/model/history.dart';
import 'package:car_parking_reservation/model/reservation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

class History extends StatefulWidget {
  const History({super.key});

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  late List<Map<String, String>> mockHistoryData;
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
                          final history_date = history_user.startAt;
                          final date = DateTime.parse(history_date.toString());
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
                                                "${date.hour.toString().padLeft(2, '0')}:${date.minute.toString().padLeft(2, '0')}:${date.millisecond.toString()}" ??
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
                                                "Price : ",
                                                style: TextStyle(
                                                    fontWeight: FontWeight.w700,
                                                    fontFamily: "Amiko",
                                                    fontSize: 16),
                                              ),
                                              Text(
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
                                              "${date.day.toString().padLeft(2, '0')}-${date.month.toString().padLeft(2, '0')}-${date.year.toString()}" ??
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
                                    left: 285,
                                    bottom: 40,
                                    child: Container(
                                      height: 50,
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
