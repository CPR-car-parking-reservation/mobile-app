import 'package:car_parking_reservation/model/car.dart';
import 'package:car_parking_reservation/model/profile.dart';
import 'package:car_parking_reservation/setting/addcar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:car_parking_reservation/bloc/setting/setting_bloc.dart';
import 'package:car_parking_reservation/bloc/setting/setting_event.dart';
import 'package:car_parking_reservation/bloc/setting/setting_state.dart';
import 'package:car_parking_reservation/setting/editprofile.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:car_parking_reservation/widget/custom_dialog.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:car_parking_reservation/setting/widget/widget_setting_page.dart';

const String fontFamily = "amiko";

class Setting extends StatefulWidget {
  const Setting({super.key});

  @override
  _SettingState createState() => _SettingState();
}

class _SettingState extends State<Setting> with RouteAware {
  String baseUrl = dotenv.env['BASE_URL'].toString();
  String userToken = '';

  @override
  void initState() {
    super.initState();
    loadToken();
    context.read<SettingBloc>().add(LoadUserAndCars());
  }

  void loadToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userToken = prefs.getString('token') ?? '';
    });
  }

  @override
  void didPopNext() {
    loadToken();
    context.read<SettingBloc>().add(LoadUserAndCars());
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SettingBloc()..add(LoadUserAndCars()),
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
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
                              const SizedBox(width:7 ),
                              Expanded(
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: [
                                    Column(
                                      crossAxisAlignment:
                                          CrossAxisAlignment.start,
                                      children: [
                                        Row(
                                          children: [
                                            Text(
                                              'Name :',
                                              style: TextStyle(
                                                fontSize: 15,
                                                color: Colors.red,
                                                fontFamily: fontFamily,
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            Expanded(
                                              child: Text(
                                                '${profile.name} ${profile.surname}',
                                                style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w500,
                                                  fontFamily: fontFamily,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              'Email : ',
                                              style: TextStyle(
                                                fontSize: 15,
                                                color: Colors.red,
                                                fontFamily: fontFamily,
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            Expanded(
                                              child: Text(
                                                profile.email,
                                                style: TextStyle(
                                                  fontSize: 15,
                                                  color: Colors.black,
                                                  fontWeight: FontWeight.w500,
                                                  fontFamily: fontFamily,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ),
                                          ],
                                        ),
                                        Row(
                                          children: [
                                            Text(
                                              'Phone :',
                                              style: TextStyle(
                                                fontSize: 15,
                                                color: Colors.red,
                                                fontFamily: fontFamily,
                                              ),
                                            ),
                                            const SizedBox(width: 8),
                                            Expanded(
                                              child: Text(
                                                profile.phone,
                                                style: TextStyle(
                                                  fontSize: 15,
                                                  fontWeight: FontWeight.w500,
                                                  fontFamily: fontFamily,
                                                  overflow:
                                                      TextOverflow.ellipsis,
                                                ),
                                              ),
                                            ),
                                          ],
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
                                  showCustomDialogSucess(context, result);
                                  // ignore: use_build_context_synchronously
                                  context
                                      .read<SettingBloc>()
                                      .add(LoadUserAndCars());
                                }
                              },
                              backgroundColor: const Color(0xFF4CAF50),
                              icon: const Icon(Icons.add, color: Colors.white),
                              label: const Text("Add Car",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
                                      color: Colors.white,
                                      fontFamily: fontFamily)),
                            ),
                            FloatingActionButton.extended(
                              onPressed: () {
                                confirmLogout(context);
                              },
                              backgroundColor: Colors.red,
                              icon:
                                  const Icon(Icons.logout, color: Colors.white),
                              label: const Text("Logout",
                                  style: TextStyle(
                                    fontWeight: FontWeight.w600,
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
              return const SizedBox.shrink();
            },
          ),
        ),
      ),
    );
  }
}
