import 'package:flutter/material.dart';
import 'package:car_parking_reservation/model/car.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:car_parking_reservation/bloc/setting/setting_bloc.dart';
import 'package:car_parking_reservation/bloc/setting/setting_event.dart';
import 'package:car_parking_reservation/bloc/setting/setting_state.dart';

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
    required String id,
  });
}

class EditCarPage extends StatefulWidget {
  final String car_id;
  // ignore: non_constant_identifier_names
  const EditCarPage({super.key, required this.car_id});

  @override
  _EditCarPageState createState() => _EditCarPageState();

  Widget build(BuildContext context) => throw UnimplementedError();
}

class _EditCarPageState extends State<EditCarPage> {
  late TextEditingController plateController;
  late TextEditingController modelController;
  late TextEditingController typeController;

  String baseImgUrl = 'https://titten-recorded-multi-describes.trycloudflare.com';

  @override
  void initState() {
    super.initState();
    plateController = TextEditingController();
    modelController = TextEditingController();
    typeController = TextEditingController();
    BlocProvider.of<SettingBloc>(context)
        .add(FetchCarById(carId: widget.car_id));
  }

  @override
  void dispose() {
    plateController.dispose();
    modelController.dispose();
    typeController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SettingBloc, SettingState>(
      listener: (context, state) {
        if (state is SettingSuccess) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
          Navigator.pop(context); // ปิดหน้า EditCarPage
        } else if (state is SettingError) {
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text(state.message)),
          );
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF03174C),
          leading: IconButton(
            icon: const Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () => Navigator.pop(context),
          ),
          title: const Text(
            "Edit Car",
            style: TextStyle(
                color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        backgroundColor: const Color(0xFF03174C),
        body: BlocBuilder<SettingBloc, SettingState>(
          builder: (context, state) {
            return FutureBuilder<car_data>(
                future: BlocProvider.of<SettingBloc>(context)
                    .fetch_cars(widget.car_id),
                builder: (context, snapshot) {
                  if (snapshot.connectionState == ConnectionState.waiting) {
                    return const Center(child: CircularProgressIndicator());
                  } else if (snapshot.hasError) {
                    return Center(child: Text('Error: ${snapshot.error}'));
                  }
                  final car = snapshot.data!;
                  plateController.text = car.car_number;
                  modelController.text = car.car_model;
                  typeController.text = car.car_type;

                  return SingleChildScrollView(
                    child: Padding(
                      padding: const EdgeInsets.all(20.0),
                      child: Column(
                        children: [
                          const SizedBox(height: 10),
                          Divider(color: Colors.white70, thickness: 1.5),
                          const SizedBox(height: 16),
                          Stack(
                            alignment: Alignment.bottomRight,
                            children: [
                              Image(
                                  image: NetworkImage(
                                      "$baseImgUrl${car.image_url}")),
                              Container(
                                decoration: BoxDecoration(
                                  color: Colors.orange,
                                  shape: BoxShape.circle,
                                  border:
                                      Border.all(color: Colors.white, width: 2),
                                ),
                                child: IconButton(
                                  icon: const Icon(Icons.edit,
                                      size: 16, color: Colors.white),
                                  onPressed: () {
                                    // ฟังก์ชันเปลี่ยนรูป
                                  },
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: 20),
                          buildTextField("ป้ายทะเบียนรถ", Icons.directions_car,
                              plateController),
                          const SizedBox(height: 10),
                          buildTextField(
                              "รุ่นรถ", Icons.car_repair, modelController),
                          const SizedBox(height: 10),
                          buildTextField(
                              "ประเภทรถ", Icons.category, typeController),
                          const SizedBox(height: 30),
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: () async {
                                // Dispatch UpdateCar event
                                BlocProvider.of<SettingBloc>(context)
                                    .add(UpdateCar(
                                  id: widget.car_id,
                                  plate: plateController.text,
                                  model: modelController.text,
                                  type: typeController.text,
                                ));
                                
                              },
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.green,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text(
                                "Update Car",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                ),
                              ),
                            ),
                          ),
                          const SizedBox(height: 10),
                          SizedBox(
                            width: double.infinity,
                            height: 50,
                            child: ElevatedButton(
                              onPressed: () => confirmDeleteCar(context),
                              style: ElevatedButton.styleFrom(
                                backgroundColor: Colors.red,
                                shape: RoundedRectangleBorder(
                                  borderRadius: BorderRadius.circular(12),
                                ),
                              ),
                              child: const Text(
                                "Delete Car",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontSize: 18,
                                    fontWeight: FontWeight.bold),
                              ),
                            ),
                          ),
                        ],
                      ),
                    ),
                  );
                });
          },
        ),
      ),
    );
  }

  Widget buildTextField(
      String label, IconData icon, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.black),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
    );
  }

  void confirmDeleteCar(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text("Delete Car"),
          content: const Text("คุณแน่ใจหรือไม่ว่าต้องการลบรถคันนี้?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                context.read<SettingBloc>().add(DeleteCar(id: widget.car_id));
                Navigator.pop(dialogContext); // ปิด Dialog
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text("Delete"),
            ),
          ],
        );
      },
    );
  }
}
