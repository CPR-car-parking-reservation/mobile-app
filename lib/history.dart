import 'package:car_parking_reservation/Bloc/reserved/reserved_bloc.dart';
import 'package:car_parking_reservation/model/history.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class History extends StatefulWidget {
  final String? parking_slots_id;
  final String? date;
  final String? start_at;
  final String? end_at;

  const History(
      {super.key,
      this.date,
      this.start_at,
      this.parking_slots_id,
      this.end_at});

  @override
  State<History> createState() => _HistoryState();
}

class _HistoryState extends State<History> {
  late List<Map<String, String>> mockHistoryData;
  void initState() {
    super.initState();
    context.read<ReservedBloc>().add(FetchAllReservation());

    mockHistoryData = [];

    if (widget.date != null && widget.start_at != null) {
      mockHistoryData.add({
        "date": widget.date!,
        "inTime": widget.start_at!,
        "outTime": widget.end_at!,
        "price": "",
        "slot_number": widget.parking_slots_id!
      });
    }
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
            Expanded(
              child: BlocBuilder<ReservedBloc, ReservedState>(
                builder: (context, state) {
                  if (state is ReserveLoading) {
                    return const Center(child: CircularProgressIndicator());
                  }
                  if (state is ReservedError) {
                    return Center(child: Text(state.message));
                  }
                  if (state is ReservedLoaded) {
                    List<History_data> history = state.history;
                    return ListView.builder(
                      padding: const EdgeInsets.only(top: 20, bottom: 10),
                      itemCount: history.length,
                      itemBuilder: (context, index) {
                        final item = history[index];
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
                                              item.start_at ?? '',
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
                                              item.end_at ?? '',
                                              style: const TextStyle(
                                                  fontFamily: "Amiko",
                                                  fontSize: 16),
                                            ),
                                          ],
                                        ),
                                        // Row(
                                        //   children: [
                                        //     const Text(
                                        //       "Price : ",
                                        //       style: TextStyle(
                                        //           fontWeight: FontWeight.w700,
                                        //           fontFamily: "Amiko",
                                        //           fontSize: 16),
                                        //     ),
                                        //     Text(
                                        //       '200',
                                        //       style: const TextStyle(
                                        //           fontFamily: "Amiko",
                                        //           fontSize: 16),
                                        //     ),
                                        //   ],
                                        // ),
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
                                            item.start_at ?? '',
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
                                        item.parkingSlot.slot_number ?? '',
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
          ],
        ),
      ),
    );
  }
}
