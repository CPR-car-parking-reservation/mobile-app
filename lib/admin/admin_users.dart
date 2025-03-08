import 'dart:async';
import 'dart:developer';
import 'dart:io';

import 'package:car_parking_reservation/Bloc/admin_bloc/admin_user/admin_user_bloc.dart';
import 'package:car_parking_reservation/Widget/custom_dialog.dart';
import 'package:car_parking_reservation/admin/widgets/users/user_list_view.dart';
import 'package:car_parking_reservation/mqtt/mqtt_service.dart';
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

class _AdminUserPageState extends State<AdminUserPage> {
  final TextEditingController _searchController = TextEditingController();
  final mqttService = MqttService();
  StreamSubscription<String>? mqttSubscription;

  @override
  void initState() {
    super.initState();
    context.read<AdminUserBloc>().add(OnUsersPageLoad());
    _initializeMqttAndLoadData();
  }

  Future<void> _initializeMqttAndLoadData() async {
    context.read<AdminUserBloc>().add(SetLoading());
    bool isConnected = await mqttService.connect();
    if (isConnected) {
      // log("MQTT Connected, now loading users...");
      context.read<AdminUserBloc>().add(OnUsersPageLoad());

      mqttSubscription = mqttService.messageStream.listen((message) {
        if (message == "fetch user") {
          context.read<AdminUserBloc>().add(OnRefresh());
        }
      });
    } else {
      log("MQTT Connection failed, skipping user load");
    }
  }

  @override
  void dispose() {
    mqttSubscription?.cancel();
    super.dispose();
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
