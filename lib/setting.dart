import 'package:cpr_application/setting/editcar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:cpr_application/setting/editprofile.dart';
import 'package:cpr_application/Login/signin.dart';

// Model สำหรับข้อมูลโปรไฟล์
class Profile {
  final String name;
  final String phone;
  final String avatar;

  Profile({required this.name, required this.phone, required this.avatar});
}

// Model สำหรับข้อมูลรถยนต์
// Model สำหรับข้อมูลรถยนต์
class Car {
  final String image;
  final String plateNumber;
  final String model;
  final String type;

  Car({
    required this.image,
    required this.plateNumber,
    required this.model,
    required this.type,
  });
}


// State ของหน้า Setting
class SettingState {
  final Profile profile;
  final List<Car> cars;

  SettingState({required this.profile, required this.cars});
}

// Bloc สำหรับจัดการสถานะ
class SettingCubit extends Cubit<SettingState> {
  SettingCubit()
      : super(
          SettingState(
            profile: Profile(
              name: "Adewale Taiwo",
              phone: "094-468-xxxx",
              avatar: "assets/images/profile.png",
            ),
            cars: [
              Car(
                  image: "assets/images/car.png",
                  plateNumber: "AC 1234",
                  model: '',
                  type: ''),
              Car(
                  image: "assets/images/model3.png",
                  plateNumber: "EF 7832",
                  model: '',
                  type: ''),
            ],
          ),
        );

  // ฟังก์ชันอัปเดตรถ
  void updateCar(
      int index, String newPlateNumber, String newModel, String newType) {
    List<Car> updatedCars = List.from(state.cars);
    updatedCars[index] = Car(
      image: updatedCars[index].image, // คงค่า image เดิม
      plateNumber: newPlateNumber,
      model: newModel,
      type: newType,
    );

    emit(SettingState(profile: state.profile, cars: updatedCars));
  }

  void logout(BuildContext context) {
    Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const Signin()),
      (route) => false,
    );
  }

  void deleteCar(int index) {}
}

class Setting extends StatelessWidget {
  const Setting({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: SettingPage(),
    );
  }
}

class SettingPage extends StatelessWidget {
  const SettingPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF0A1D56),
      body: SafeArea(
        child: BlocBuilder<SettingCubit, SettingState>(
          builder: (context, state) {
            return Padding(
              padding: const EdgeInsets.all(16.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Center(
                      child: Text(
                    "Setting", //
                    style: TextStyle(
                      fontSize: 22,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  )),
                  const SizedBox(height: 8),
                  Divider(
                    color: Colors.white70,
                    thickness: 1.5,
                    indent: 20,
                    endIndent: 20,
                  ),
                  const SizedBox(height: 16),
                  // MY PROFILE
                  Text("MY PROFILE",
                      style: TextStyle(
                          color: const Color.fromARGB(255, 255, 255, 255))),
                  const SizedBox(height: 8),
                  Container(
                    decoration: BoxDecoration(
                      color: Colors.white,
                      borderRadius: BorderRadius.circular(12),
                    ),
                    padding: const EdgeInsets.all(12),
                    child: Row(
                      children: [
                        CircleAvatar(
                          backgroundImage: AssetImage(state.profile.avatar),
                          radius: 30,
                        ),
                        const SizedBox(width: 12),
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(state.profile.name,
                                style: TextStyle(
                                    fontSize: 16, fontWeight: FontWeight.bold)),
                            Text("Tel. ${state.profile.phone}",
                                style: TextStyle(color: Colors.red.shade400)),
                          ],
                        ),
                        const Spacer(),
                        IconButton(
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      const EditProfilePage()),
                            );
                          },
                          icon: const Icon(Icons.edit, color: Colors.orange),
                        )
                      ],
                    ),
                  ),

                  const SizedBox(height: 20),

                  // MY CAR
                  Text("MY CAR",
                      style: TextStyle(
                          color: const Color.fromARGB(255, 255, 255, 255))),
                  const SizedBox(height: 8),
                  Column(
                    children: state.cars.asMap().entries.map((entry) {
                      int index = entry.key;
                      Car car = entry.value;

                      return Container(
                        margin: const EdgeInsets.symmetric(vertical: 6),
                        decoration: BoxDecoration(
                          color: Colors.white,
                          borderRadius: BorderRadius.circular(12),
                        ),
                        padding: const EdgeInsets.all(12),
                        child: Row(
                          children: [
                            Image.asset(car.image,
                                width: 100, height: 60, fit: BoxFit.cover),
                            const SizedBox(width: 12),
                            Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                Text("ป้ายทะเบียนรถ",
                                    style: TextStyle(color: Colors.black)),
                                Text(car.plateNumber,
                                    style: TextStyle(
                                        fontSize: 16,
                                        fontWeight: FontWeight.bold)),
                                Text(car.model,
                                    style: TextStyle(color: Colors.grey)),
                                Text(car.type,
                                    style: TextStyle(color: Colors.grey)),
                              ],
                            ),
                            const Spacer(),
                            IconButton(
                              onPressed: () {
                                Navigator.push(
                                  context,
                                  MaterialPageRoute(
                                    builder: (context) =>
                                        EditCarPage(index: index, car: car),
                                  ),
                                );
                              },
                              icon:
                                  const Icon(Icons.edit, color: Colors.orange),
                            ),
                          ],
                        ),
                      );
                    }).toList(),
                  ),

                  const Spacer(),

                  // ปุ่มเพิ่มรถยนต์
                  Center(
                    child: FloatingActionButton.extended(
                      onPressed: () {},
                      backgroundColor: Colors.red.shade400,
                      icon: const Icon(Icons.add, color: Colors.white),
                      label: const Text("เพิ่มรถ",
                          style: TextStyle(color: Colors.white)),
                    ),
                  ),

                  const SizedBox(height: 20),

                  Align(
                    alignment: Alignment.bottomRight,
                    child: ElevatedButton(
                      onPressed: () {
                        context.read<SettingCubit>().logout(context);
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.red,
                        shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(10)),
                        padding: const EdgeInsets.symmetric(
                            horizontal: 10, vertical: 6),
                      ),
                      child: const Text("Log-Out",
                          style: TextStyle(color: Colors.white, fontSize: 14)),
                    ),
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
