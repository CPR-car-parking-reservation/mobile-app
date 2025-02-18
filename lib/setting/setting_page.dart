import 'package:flutter/material.dart';
import 'editcar.dart';
import 'editprofile.dart';
import '../Login/signin.dart';

// Model สำหรับข้อมูลโปรไฟล์
class Profile {
  final String name;
  final String phone;
  final String avatar;

  Profile({required this.name, required this.phone, required this.avatar});
}

// Model สำหรับข้อมูลรถยนต์



class Setting extends StatefulWidget {
  const Setting({super.key});

  @override
  _SettingState createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  Profile profile = Profile(
    name: "Adewale Taiwo",
    phone: "094-468-xxxx",
    avatar: "assets/images/profile.png",
  );

  List<Car> cars = [
    Car(image: "assets/images/car.png", plateNumber: "AC 1234", model: "Model X", type: "SUV"),
    Car(image: "assets/images/model3.png", plateNumber: "EF 7832", model: "Model 3", type: "Sedan"),
  ];

  // ฟังก์ชันอัปเดตรถ
  void updateCar(int index, Car updatedCar) {
    setState(() {
      cars[index] = updatedCar;
    });
  }

  // ฟังก์ชันลบรถ
  void deleteCar(int index) {
    setState(() {
      cars.removeAt(index);
    });
  }

  void logout(BuildContext context) {
    Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const Signin()),
      (route) => false,
    );
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      home: Scaffold(
        backgroundColor: const Color(0xFF0A1D56),
        body: SafeArea(
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
                  ),
                )),
                const SizedBox(height: 8),
                Divider(color: Colors.white70, thickness: 1.5, indent: 20, endIndent: 20),
                const SizedBox(height: 16),
                
                // MY PROFILE
                Text("MY PROFILE", style: TextStyle(color: Colors.white)),
                const SizedBox(height: 8),
                Container(
                  decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
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
                          Text(profile.name, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                          Text("Tel. ${profile.phone}", style: TextStyle(color: Colors.red.shade400)),
                        ],
                      ),
                      const Spacer(),
                      IconButton(
                        onPressed: () {
                          Navigator.push(context, MaterialPageRoute(builder: (context) => const EditProfilePage()));
                        },
                        icon: const Icon(Icons.edit, color: Colors.orange),
                      )
                    ],
                  ),
                ),

                const SizedBox(height: 20),

                // MY CAR
                Text("MY CAR", style: TextStyle(color: Colors.white)),
                const SizedBox(height: 8),
                Column(
                  children: cars.asMap().entries.map((entry) {
                    int index = entry.key;
                    Car car = entry.value;

                    return Container(
                      margin: const EdgeInsets.symmetric(vertical: 6),
                      decoration: BoxDecoration(color: Colors.white, borderRadius: BorderRadius.circular(12)),
                      padding: const EdgeInsets.all(12),
                      child: Row(
                        children: [
                          Image.asset(car.image, width: 100, height: 60, fit: BoxFit.cover),
                          const SizedBox(width: 12),
                          Column(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [
                              Text("ป้ายทะเบียนรถ", style: TextStyle(color: Colors.black)),
                              Text(car.plateNumber, style: TextStyle(fontSize: 16, fontWeight: FontWeight.bold)),
                              Text(car.model, style: TextStyle(color: Colors.grey)),
                              Text(car.type, style: TextStyle(color: Colors.grey)),
                            ],
                          ),
                          const Spacer(),
                          IconButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (context) => EditCarPage(
                                    index: index,
                                    car: car,
                                    updateCar: updateCar,
                                    deleteCar: deleteCar,
                                  ),
                                ),
                              );
                            },
                            icon: const Icon(Icons.edit, color: Colors.orange),
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
                    onPressed: () {
                      setState(() {
                        cars.add(Car(
                          image: "assets/images/default_car.png",
                          plateNumber: "New Plate",
                          model: "New Model",
                          type: "New Type",
                        ));
                      });
                    },
                    backgroundColor: Colors.red.shade400,
                    icon: const Icon(Icons.add, color: Colors.white),
                    label: const Text("เพิ่มรถ", style: TextStyle(color: Colors.white)),
                  ),
                ),

                const SizedBox(height: 20),

                Align(
                  alignment: Alignment.bottomRight,
                  child: ElevatedButton(
                    onPressed: () {
                      logout(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.red,
                      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(10)),
                      padding: const EdgeInsets.symmetric(horizontal: 10, vertical: 6),
                    ),
                    child: const Text("Log-Out", style: TextStyle(color: Colors.white, fontSize: 14)),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
