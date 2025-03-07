import 'dart:developer';
import 'dart:io';

import 'package:car_parking_reservation/Widget/custom_dialog.dart';
import 'package:car_parking_reservation/model/parking_slot.dart';
import 'package:car_parking_reservation/reserv.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import '../bloc/parking/parking_bloc.dart';
// import 'package:uuid/data.dart';
// import 'package:uuid/uuid.dart';
// import 'package:uuid/rng.dart';

/// Widget หลักที่ใช้แสดงที่จอดรถทั้งหมด
class ParkingSlots extends StatefulWidget {
  const ParkingSlots({super.key});

  @override
  // ignore: library_private_types_in_public_api
  _ParkingSlots createState() => _ParkingSlots();

  // กำหนดสีของที่จอดรถตามสถานะ
  static getStatusColor(String status) {
    switch (status) {
      case "FULL":
        return Colors.red;
      case "Maintenance":
        return Colors.grey;
      case "RESERVED":
        return Colors.amber;
      case "IDLE":
      default:
        return Colors.green;
    }
  }
}

enum MqttCurrentConnectionState {
  IDLE,
  CONNECTING,
  CONNECTED,
  DISCONNECTED,
  ERROR_WHEN_CONNECTING
}

enum MqttSubscriptionState { IDLE, SUBSCRIBED }

class MqttClientWrapper {
  late MqttServerClient client;

  MqttCurrentConnectionState connectionState = MqttCurrentConnectionState.IDLE;
  MqttSubscriptionState subscriptionState = MqttSubscriptionState.IDLE;

  // Async setup to prevent blocking the main thread
  Future<void> prepareMqttClient() async {
    _setupMqttClient();
    await _connectClient();
    _subscribeToTopic('cpr/from_server/trigger');
  }

  Future<void> _connectClient() async {
    try {
      log('Client connecting....');
      connectionState = MqttCurrentConnectionState.CONNECTING;
      await client.connect('mobile2', 'Mobile2123');
    } on Exception catch (e) {
      log('Client exception - $e');
      connectionState = MqttCurrentConnectionState.ERROR_WHEN_CONNECTING;
      client.disconnect();
      return;
    }

    if (client.connectionStatus?.state == MqttConnectionState.connected) {
      connectionState = MqttCurrentConnectionState.CONNECTED;
      log('Client connected');
    } else {
      log('ERROR: Client connection failed - Disconnecting. Status: ${client.connectionStatus}');
      connectionState = MqttCurrentConnectionState.ERROR_WHEN_CONNECTING;
      client.disconnect();
    }
  }

  void _setupMqttClient() {
    client =
        MqttServerClient.withPort('61d93b772b6242a892508d48bf7f77ba.s1.eu.hivemq.cloud', 'mobile2', 8883);
    client.secure = true;
    client.securityContext = SecurityContext.defaultContext;
    client.keepAlivePeriod = 20;
    client.onDisconnected = _onDisconnected;
    client.onConnected = _onConnected;
    client.onSubscribed = _onSubscribed;
  }

  void _subscribeToTopic(String topicName) {
    log('Subscribing to topic: $topicName');
    client.subscribe(topicName, MqttQos.atMostOnce);
    client.updates?.listen((List<MqttReceivedMessage<MqttMessage>> c) {
      final MqttPublishMessage recMess = c[0].payload as MqttPublishMessage;
      String message =
          MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
      log('Received message: $message');
    });
  }


  void _onSubscribed(String topic) {
    log('Subscription confirmed for topic: $topic');
    subscriptionState = MqttSubscriptionState.SUBSCRIBED;
  }

  void _onDisconnected() {
    log('Client disconnected');
    connectionState = MqttCurrentConnectionState.DISCONNECTED;
  }

  void _onConnected() {
    log('Client connected successfully');
    connectionState = MqttCurrentConnectionState.CONNECTED;
  }
}

// State ของ ParkingSlots
class _ParkingSlots extends State<ParkingSlots> {
  String selectedFloor = "F1"; // กำหนดชั้นที่เลือกเริ่มต้นเป็น F1
  String message = 'Waiting for message...';

  // กรองเฉพาะที่จอดรถที่อยู่ในชั้นที่เลือก
  List<ParkingSlot> getFilteredSlots(List<ParkingSlot> slots) {
    return slots
        .where((slot) => slot.floor.floor_number == selectedFloor)
        .toList();
  }

  // เปลี่ยนชั้นของที่จอดรถ (ไปชั้นถัดไปหรือย้อนกลับ)
  void changeFloor(bool next, List<ParkingSlot> slots) {
    List<String> floors =
        slots.map((slot) => slot.floor.floor_number).toSet().toList();
    floors.sort();
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
  void initState() {
    context.read<ParkingBloc>().add(OnFirstParkingSlot());
    MqttClientWrapper().prepareMqttClient();  
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocBuilder<ParkingBloc, ParkingState>(
      builder: (context, state) {
        if (state is ParkingInitial || state is ParkingLoading) {
          return const Center(
              child: CircularProgressIndicator()); // แสดงโหลดเมื่อไม่มีข้อมูล
        } else if (state is ParkingLoaded) {
          List<List<ParkingSlot>> leftSlots = [];
          List<List<ParkingSlot>> rightSlots = [];

          List<String> floors = state.parkingSlots
              .map((slot) => slot.floor.floor_number)
              .toSet()
              .toList()
            ..sort();
          List<ParkingSlot> filteredSlots =
              getFilteredSlots(state.parkingSlots);

          // จัดที่จอดรถเป็นสองฝั่ง (ซ้าย-ขวา) โดยแต่ละแถวมีไม่เกิน 3 ช่อง
          for (var slot in filteredSlots) {
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
                  Container(
                    color: Color(0xFF03174C), // Set background color to black
                    padding: const EdgeInsets.only(left: 41, right: 41),
                    child: Column(
                      children: [
                        Text(
                          'Parking Zone: $selectedFloor',
                          style: const TextStyle(
                              color: Colors.white,
                              fontSize: 24,
                              fontWeight: FontWeight.bold,
                              fontFamily: "Amiko"),
                        ),
                        const Divider(
                          color: Colors.white,
                        ),
                        // Text(message,
                        //     style: const TextStyle(color: Colors.white)),
                      ],
                    ),
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
              // แสดงที่จอดฝั่งซ้าย
              Positioned(
                left: 12,
                top: MediaQuery.of(context).size.height * 0.28,
                child: Column(
                  children: leftSlots
                      .map((column) => Column(
                          children: column.reversed
                              .map((slot) => ParkingSlotButton(parking: slot))
                              .toList()))
                      .toList(),
                ),
              ),
              // แสดงที่จอดฝั่งขวา
              Positioned(
                right: 12,
                top: MediaQuery.of(context).size.height * 0.28,
                child: Column(
                  children: rightSlots
                      .map((column) => Column(
                          children: column.reversed
                              .map((slot) => ParkingSlotButton(parking: slot))
                              .toList()))
                      .toList(),
                ),
              ),
              // ปุ่มเปลี่ยนชั้น (ไปชั้นก่อนหน้า/ถัดไป)
              Padding(
                padding: const EdgeInsets.all(10.0),
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.end,
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        if (floors.indexOf(selectedFloor) == 0)
                          const SizedBox(width: 50),
                        if (floors.indexOf(selectedFloor) > 0)
                          FloatingActionButton(
                            onPressed: () =>
                                changeFloor(false, state.parkingSlots),
                            backgroundColor: Colors.white,
                            shape: const CircleBorder(),
                            child: const Icon(
                              Icons.arrow_back_ios,
                              color: Colors.black,
                            ),
                          ),
                        if (floors.indexOf(selectedFloor) < floors.length - 1)
                          FloatingActionButton(
                            onPressed: () =>
                                changeFloor(true, state.parkingSlots),
                            backgroundColor: Colors.white,
                            shape: const CircleBorder(),
                            child: const Icon(
                              Icons.arrow_forward_ios,
                              color: Colors.black,
                            ),
                          ),
                      ],
                    ),
                  ],
                ),
              )
            ],
          );
        } else if (state is ParkingError) {
          return Center(child: Text(state.message));
        }
        return Container();
      },
    );
  }
}

class ParkingSlotButton extends StatelessWidget {
  final ParkingSlot parking;

  const ParkingSlotButton({required this.parking, super.key});

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: 120,
          height: 60,
          child: FloatingActionButton(
            heroTag: "btn_${parking.slot_number}", // ป้องกัน error tag ซ้ำกัน
            backgroundColor: Colors.white,
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(10),
              side: BorderSide(
                  width: 4, color: ParkingSlots.getStatusColor(parking.status)),
            ),
            child: Text(
              parking.slot_number,
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 22,
                  fontWeight: FontWeight.bold),
            ),
            onPressed: () {
              if (parking.status == "IDLE") {
                Navigator.push(
                    context,
                    MaterialPageRoute(
                        builder: (context) => Reserv(
                              parking_slots_id: parking.id,
                              slot_number: parking.slot_number,
                              floor_number: parking.floor.floor_number,
                              status: parking.status,
                            )));
              }
              if (parking.status == "RESERVED") {
                showCustomDialogWarning(context, "Reserved");
              }

              if (parking.status == "Maintenance") {
                showCustomDialogWarning(context, "Maintenance");
              }

              if (parking.status == "FULL") {
                showCustomDialogError(context, "FULL");
              }
            },
          ),
        ),

        // แสดงสถานะของที่จอดรถ
        Container(
          width: 130,
          height: 20,
          margin: const EdgeInsets.only(top: 10, bottom: 10),
          decoration: BoxDecoration(
            color: ParkingSlots.getStatusColor(parking.status),
            borderRadius: BorderRadius.circular(10),
          ),
          child: Center(
            child: Text(
              parking.status,
              style: const TextStyle(
                  color: Colors.black,
                  fontSize: 12,
                  fontWeight: FontWeight.bold),
            ),
          ),
        ),
      ],
    );
  }
}
