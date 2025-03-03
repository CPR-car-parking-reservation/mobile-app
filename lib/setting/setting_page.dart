import 'package:car_parking_reservation/model/car.dart';
import 'package:car_parking_reservation/model/profile.dart';
import 'package:car_parking_reservation/setting/addcar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:car_parking_reservation/bloc/setting/setting_bloc.dart';
import 'package:car_parking_reservation/bloc/setting/setting_event.dart';
import 'package:car_parking_reservation/bloc/setting/setting_state.dart';
import 'package:car_parking_reservation/setting/editcar.dart';
import 'package:car_parking_reservation/setting/editprofile.dart';
import 'package:car_parking_reservation/Login/signin.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:car_parking_reservation/widget/custom_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';

const String fontFamily = "amiko";

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

class Setting extends StatefulWidget {
  const Setting({super.key});

  @override
  _SettingState createState() => _SettingState();
}

class _SettingState extends State<Setting> with RouteAware {
  String baseUrl = dotenv.env['BASE_URL'].toString();

  @override
  void didPopNext() {
    loadToken();
    context.read<SettingBloc>().add(LoadUserAndCars());
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(
        this, ModalRoute.of(context)! as PageRoute<dynamic>);
    routeObserver.subscribe(
        this, ModalRoute.of(context)! as PageRoute<dynamic>);
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
  }

  String userToken = '';
  void loadToken() async {
   SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userToken = prefs.getString('token') ?? '';
    });
  }

  void logout(BuildContext context) {
    Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const Signin()),
      (route) => false,
    );
  }

  ListView listviewshow(List<car_data> car) {
    String baseUrl = dotenv.env['BASE_URL'].toString();
    return ListView.separated(
      itemBuilder: (context, index) {
        return Container(
          margin: const EdgeInsets.symmetric(vertical: 6),
          decoration: BoxDecoration(
              color: Colors.white, borderRadius: BorderRadius.circular(12)),
          padding: const EdgeInsets.all(12),
          child: Row(
            children: [
              Image.network(
                '$baseUrl${car[index].image_url}',
                width: 100,
                height: 60,
                fit: BoxFit.contain,
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("License plate",
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: fontFamily,
                          fontWeight: FontWeight.bold)),
                  Text(car[index].license_plate,
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          fontFamily: fontFamily)),
                  Text(car[index].car_model,
                      style: const TextStyle(
                          color: Colors.grey,
                          fontFamily: fontFamily,
                          fontWeight: FontWeight.w300)),
                  Text(car[index].car_type,
                      style: const TextStyle(
                          color: Colors.grey,
                          fontFamily: fontFamily,
                          fontWeight: FontWeight.w300)),
                ],
              ),
              const Spacer(),
              IconButton(
                onPressed: () async {
                  final result = await Navigator.push(
                    context,
                    MaterialPageRoute(
                      builder: (context) => EditCarPage(car_id: car[index].id),
                    ),
                  );
                  if (result is String) {
                    // ignore: use_build_context_synchronously
                    showCustomDialog(context, result);
                    // ignore: use_build_context_synchronously
                    context.read<SettingBloc>().add(LoadUserAndCars());
                  }
                },
                icon: const Icon(Icons.edit, color: Colors.orange),
              ),
            ],
          ),
        );
      },
      separatorBuilder: (context, index) => const Divider(),
      itemCount: car.length,
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SettingBloc()..add(LoadUserAndCars()),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        navigatorObservers: [routeObserver],
        home: Scaffold(
          backgroundColor: const Color(0xFF03174C),
          body: BlocBuilder<SettingBloc, SettingState>(
            builder: (context, state) {
              if (state is SettingLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (state is SettingError) {
                return Center(child: Text(state.message));
              } else if (state is UserAndCarsLoaded) {
                final List<car_data> carSnapshot = state.cars;
                final Profile_data profile = state.profile;
                return SafeArea(
                  child: Padding(
                    padding: const EdgeInsets.all(16.0),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Center(
                          child: Text(
                            "Setting",
                            style: TextStyle(
                              fontSize: 22,
                              fontWeight: FontWeight.bold,
                              color: Colors.white,
                              fontFamily: fontFamily,
                            ),
                          ),
                        ),
                        const SizedBox(height: 8),
                        Divider(
                            color: Colors.white70,
                            thickness: 1.5,
                            indent: 20,
                            endIndent: 20),
                        const SizedBox(height: 16),

                        // MY PROFILE
                        Text("MY PROFILE",
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                                fontFamily: fontFamily,
                                fontSize: 16)),
                        const SizedBox(height: 8),
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12)),
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            children: [
                              CircleAvatar(
                                backgroundImage: NetworkImage(
                                    '$baseUrl${profile.image_url}'),
                                radius: 30,
                              ),
                              const SizedBox(width: 12),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Row(
                                      children: [
                                        Text('Name : ',
                                            style: TextStyle(
                                              color: Colors.red,
                                              fontFamily: fontFamily,
                                            )),
                                        Expanded(
                                          child: Text(
                                            '${profile.name} ${profile.surname}',
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w400,
                                              fontFamily: fontFamily,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text('Email : ',
                                            style: TextStyle(
                                              color: Colors.red,
                                              fontFamily: fontFamily,
                                              overflow: TextOverflow.ellipsis,
                                            )),
                                        Text(profile.email,
                                            style: TextStyle(
                                              fontSize: 15,
                                              color: Colors.black,
                                              fontWeight: FontWeight.w400,
                                              fontFamily: fontFamily,
                                              overflow: TextOverflow.ellipsis,
                                            )),
                                      ],
                                    ),
                                    Row(
                                      children: [
                                        Text('Phone : ',
                                            style: TextStyle(
                                              color: Colors.red,
                                              fontFamily: fontFamily,
                                            )),
                                        Expanded(
                                          child: Text(
                                            profile.phone,
                                            style: TextStyle(
                                              fontSize: 15,
                                              fontWeight: FontWeight.w400,
                                              fontFamily: fontFamily,
                                            ),
                                            overflow: TextOverflow.ellipsis,
                                          ),
                                        ),
                                      ],
                                    ),
                                  ],
                                ),
                              ),
                              IconButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) => EditProfilePage(
                                              profile: profile)));
                                },
                                icon: const Icon(Icons.edit,
                                    color: Colors.orange),
                              )
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),

                        // MY CAR
                        Text("MY CAR",
                            style: TextStyle(
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                                fontFamily: fontFamily,
                                fontSize: 16)),
                        const SizedBox(height: 5),

                        // แสดง ListView
                        Expanded(
                          child: listviewshow(carSnapshot),
                        ),

                        const SizedBox(height: 20),

                        // ปุ่มเพิ่มรถและปุ่มออกจากระบบ
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            FloatingActionButton.extended(
                              onPressed: () async {
                                final result = await Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) => const AddCarPage(),
                                  ),
                                );
                                if (result is String) {
                                  // ignore: use_build_context_synchronously
                                  showCustomDialog(context, result);
                                  // ignore: use_build_context_synchronously
                                  context
                                      .read<SettingBloc>()
                                      .add(LoadUserAndCars());
                                }
                              },
                              backgroundColor:
                                  const Color.fromRGBO(41, 206, 121, 1),
                              icon: const Icon(Icons.add, color: Colors.white),
                              label: const Text("Add Car",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: fontFamily)),
                            ),
                            FloatingActionButton.extended(
                              onPressed: () {
                                logout(context);
                              },
                              backgroundColor: Colors.red,
                              icon:
                                  const Icon(Icons.logout, color: Colors.white),
                              label: const Text("Logout",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontFamily: fontFamily)),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ),
                );
              }
              return const Center(child: Text('No data available'));
            },
          ),
        ),
      ),
    );
  }
}

