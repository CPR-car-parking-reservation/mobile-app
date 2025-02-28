import 'package:car_parking_reservation/model/car.dart';
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

final RouteObserver<PageRoute> routeObserver = RouteObserver<PageRoute>();

class Profile {
  final String name;
  final String phone;
  final String avatar;

  Profile({required this.name, required this.phone, required this.avatar});
}

class Setting extends StatefulWidget {
  const Setting({super.key});

  @override
  _SettingState createState() => _SettingState();
}

class _SettingState extends State<Setting> with RouteAware {
  String baseUrl = dotenv.env['BASE_URL'].toString();

  Profile profile = Profile(
    name: "Adewale Taiwo",
    phone: "094-468-xxxx",
    avatar: "assets/images/profile.png",
  );

  @override
  void didPopNext() {
    context.read<SettingBloc>().add(LoadCars()); // Reload data when coming back
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    routeObserver.subscribe(
        this, ModalRoute.of(context)! as PageRoute<dynamic>);
  }

  @override
  void dispose() {
    routeObserver.unsubscribe(this);
    super.dispose();
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
                fit: BoxFit.cover,
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text("License plate",
                      style: TextStyle(
                          color: Colors.black,
                          fontFamily: "amiko",
                          fontWeight: FontWeight.bold)),
                  Text(car[index].car_number,
                      style: const TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.w400,
                          fontFamily: "amiko")),
                  Text(car[index].car_model,
                      style: const TextStyle(
                          color: Colors.grey,
                          fontFamily: "amiko",
                          fontWeight: FontWeight.w300)),
                  Text(car[index].car_type,
                      style: const TextStyle(
                          color: Colors.grey,
                          fontFamily: "amiko",
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
                  if (result == true) {
                    // ignore: use_build_context_synchronously
                    context
                        .read<SettingBloc>()
                        .add(LoadCars()); // Reload data if result is true
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

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        backgroundColor: const Color(0xFF29CE79),
        duration: Duration(milliseconds: 1500),
        content: Padding(
          padding: const EdgeInsets.only(left: 20),
          child: Row(
            children: [
              Icon(
                Icons.check_circle,
                color: Colors.white,
              ),
              Padding(
                padding: const EdgeInsets.only(left: 20),
                child: Text(
                  'Success',
                  style: TextStyle(
                      fontFamily: "Amiko",
                      fontSize: 18,
                      fontWeight: FontWeight.w700,
                      color: Colors.white),
                ),
              ),
            ],
          ),
        ),
        action: SnackBarAction(
          label: '',
          onPressed: () {
            // Code to execute.
          },
        ),
        padding: EdgeInsets.all(2),
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(30),
        ),
        behavior: SnackBarBehavior.floating,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => SettingBloc()..add(LoadCars()),
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
              } else if (state is SettingLoaded) {
                final List<car_data> carSnapshot = state.cars;
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
                              fontFamily: "Amiko",
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
                            style: TextStyle(color: Colors.white)),
                        const SizedBox(height: 8),
                        Container(
                          decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius: BorderRadius.circular(12)),
                          padding: const EdgeInsets.all(12),
                          child: Row(
                            children: [
                              CircleAvatar(
                                backgroundImage: AssetImage(profile.avatar),
                                radius: 30,
                              ),
                              const SizedBox(width: 12),
                              Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  Text(profile.name,
                                      style: TextStyle(
                                          fontSize: 16,
                                          fontWeight: FontWeight.bold)),
                                  Text("Tel. ${profile.phone}",
                                      style: TextStyle(
                                          color: Colors.red.shade400)),
                                ],
                              ),
                              const Spacer(),
                              IconButton(
                                onPressed: () {
                                  Navigator.push(
                                      context,
                                      MaterialPageRoute(
                                          builder: (context) =>
                                              const EditProfilePage()));
                                },
                                icon: const Icon(Icons.edit,
                                    color: Colors.orange),
                              )
                            ],
                          ),
                        ),

                        const SizedBox(height: 20),

                        // MY CAR
                        Text("MY CAR", style: TextStyle(color: Colors.white)),
                        const SizedBox(height: 8),

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
                                  _showSnackBar(context, result);
                                  // ignore: use_build_context_synchronously
                                  context.read<SettingBloc>().add(LoadCars());
                                }
                              },
                              backgroundColor:
                                  const Color.fromRGBO(41, 206, 121, 1),
                              icon: const Icon(Icons.add, color: Colors.white),
                              label: const Text("Add Car",
                                  style: TextStyle(color: Colors.white)),
                            ),
                            FloatingActionButton.extended(
                              onPressed: () {
                                logout(context);
                              },
                              backgroundColor: Colors.red,
                              icon:
                                  const Icon(Icons.logout, color: Colors.white),
                              label: const Text("Logout",
                                  style: TextStyle(color: Colors.white)),
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
