import 'dart:developer';
import 'dart:io';

import 'package:car_parking_reservation/Bloc/admin_bloc/admin_user/admin_user_bloc.dart';
import 'package:car_parking_reservation/Widget/custom_dialog.dart';
import 'package:car_parking_reservation/admin/widgets/users/user_list_view.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:mqtt_client/mqtt_client.dart';
import 'package:mqtt_client/mqtt_server_client.dart';
import 'package:uuid/uuid.dart';

class AdminUserPage extends StatefulWidget {
  const AdminUserPage({super.key});

  @override
  State<AdminUserPage> createState() => _AdminUserPageState();
}

enum MqttCurrentConnectionState {
  IDLE,
  CONNECTING,
  CONNECTED,
  DISCONNECTED,
  ERROR_WHEN_CONNECTING
}

enum MqttSubscriptionState { IDLE, SUBSCRIBED }

class _AdminUserPageState extends State<AdminUserPage> {
  late MqttServerClient client;
  var uuid = Uuid();
  var v4 = Uuid().v4();
  //
  var clientId =
      Uuid().v4() + 'mobile' + DateTime.now().millisecondsSinceEpoch.toString();

  MqttCurrentConnectionState connectionState = MqttCurrentConnectionState.IDLE;
  MqttSubscriptionState subscriptionState = MqttSubscriptionState.IDLE;

  Future<void> _connectClient() async {
    final String clientId = Uuid().v4() +
        'mobile' +
        DateTime.now().millisecondsSinceEpoch.toString();
    final String mqtt_broker = dotenv.env['MQTT_BROKER'].toString();
    final String mqtt_username = dotenv.env['MQTT_USERNAME'].toString();
    final String mqtt_password = dotenv.env['MQTT_PASSWORD'].toString();
    final String mqtt_topic = dotenv.env['MQTT_ADMIN_TOPIC'].toString();

    // Create a new MqttServerClient instance

    client = MqttServerClient.withPort(mqtt_broker, clientId, 8883);
    client.secure = true;
    client.securityContext = SecurityContext.defaultContext;
    client.keepAlivePeriod = 60;
    client.onDisconnected = _onDisconnected;
    client.onConnected = _onConnected;
    client.onSubscribed = _onSubscribed;
    connectionState = MqttCurrentConnectionState.CONNECTING;
    await client.connect(mqtt_username, mqtt_password);

    // Connect to the broker
    try {
      await client.connect();
    } on NoConnectionException catch (e) {
      log('Connection exception: $e');
      rethrow;
    } catch (e) {
      log('Unexpected error: $e');
      rethrow;
    }

    client.subscribe(mqtt_topic, MqttQos.atMostOnce);
    client.updates?.listen((List<MqttReceivedMessage<MqttMessage>> c) {
      final MqttPublishMessage recMess = c[0].payload as MqttPublishMessage;
      String message =
          MqttPublishPayload.bytesToStringAsString(recMess.payload.message);
      log('Received message: $message');

      if (message == "fetch user") {
        context.read<AdminUserBloc>().add(OnRefresh());
      }
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

  final TextEditingController _searchController = TextEditingController();

  @override
  void initState() {
    context.read<AdminUserBloc>().add(OnUsersPageLoad());
    _connectClient();
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<AdminUserBloc, AdminUserState>(
      listener: (context, state) {
        if (state is AdminUserError) {
          showCustomDialogError(context, state.message);
        }
      },
      child: Scaffold(
        body: Column(
          mainAxisAlignment: MainAxisAlignment.start,
          children: [
            Text(
              "Users",
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
              color: Colors.black,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 2),
              child: SizedBox(
                height: 47,
                child: Row(
                  children: [
                    Flexible(
                      flex: 4,
                      child: SizedBox(
                        height: 40,
                        child: TextField(
                          controller: _searchController,
                          decoration: InputDecoration(
                            hintStyle: TextStyle(
                                color: Colors.blueGrey,
                                fontSize: 13,
                                fontWeight: FontWeight.bold,
                                fontFamily: "Amiko"),
                            hintText: "Search by name or email",
                            prefixIcon: Icon(Icons.search),
                            border: OutlineInputBorder(
                              borderSide:
                                  BorderSide(width: 2, color: Colors.blueGrey),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(100)),
                            ),
                            focusedBorder: OutlineInputBorder(
                              borderSide:
                                  BorderSide(width: 2, color: Colors.blueGrey),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(100)),
                            ),
                            enabledBorder: OutlineInputBorder(
                              borderSide: BorderSide(
                                  width: 1.2, color: Colors.blueGrey),
                              borderRadius:
                                  BorderRadius.all(Radius.circular(100)),
                            ),
                          ),
                          onChanged: (value) {
                            log("Search: $value");
                            context
                                .read<AdminUserBloc>()
                                .add(OnSearch(search: value));
                          },
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Expanded(
              child: BlocBuilder<AdminUserBloc, AdminUserState>(
                builder: (context, state) {
                  if (state is AdminUserLoading) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (state is AdminUserError) {
                    return Center(child: Text(state.message));
                  } else if (state is AdminUserLoaded) {
                    if (state.users.isNotEmpty) {
                      return AdminListViewUser(users: state.users);
                    } else {
                      return Center(
                          child: Text(
                        "No data found",
                        style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                            fontFamily: "Amiko"),
                      ));
                    }
                  }
                  return const SizedBox.shrink();
                },
              ),
            ),
          ],
        ),
      ),
    );
  }
}
