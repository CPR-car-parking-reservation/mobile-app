import 'dart:io';
import 'package:car_parking_reservation/Widget/custom_dialog.dart';
import 'package:car_parking_reservation/setting/widget/widget_editcar.dart'; // Import the widget_editcar.dart
import 'package:flutter/material.dart';
import 'package:car_parking_reservation/model/car.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:car_parking_reservation/bloc/setting/setting_bloc.dart';
import 'package:car_parking_reservation/bloc/setting/setting_event.dart';
import 'package:car_parking_reservation/bloc/setting/setting_state.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';


class EditCarPage extends StatefulWidget {
  // ignore: non_constant_identifier_names
  final String car_id;
  // ignore: non_constant_identifier_names
  const EditCarPage({super.key, required this.car_id});

  @override
  _EditCarPageState createState() => _EditCarPageState();
}

class _EditCarPageState extends State<EditCarPage> {
  late TextEditingController plateController;
  late TextEditingController modelController;
  late TextEditingController typeController;
  final ValueNotifier<File?> imageNotifier = ValueNotifier<File?>(null);
  final ValueNotifier<String?> selectedTypeNotifier =
      ValueNotifier<String?>(null);
  String? imagePath;

  String baseUrl = dotenv.env['BASE_URL'].toString();

  @override
  void initState() {
    super.initState();
    plateController = TextEditingController();
    modelController = TextEditingController();
    typeController = TextEditingController();
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
          showCustomDialogSucess(context, state.message);
          Navigator.pop(context, state.message);
        } else if (state is SettingError) {
          showCustomDialogWarning(context, state.message);
        }
      },
      child: Scaffold(
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
                  return Center(
                    child: Text(
                      'Error: ${snapshot.error}',
                      style: const TextStyle(
                        fontFamily: "amiko",
                      ),
                    ),
                  );
                }
                
                final car = snapshot.data!;
                // ตั้งค่าเริ่มต้นสำหรับ Dropdown
                if (selectedTypeNotifier.value == null ||
                    typeController.text.isEmpty) {
                  selectedTypeNotifier.value = car.car_type;
                  typeController.text = car.car_type;
                }
                plateController.text = car.license_plate;
                modelController.text = car.car_model;

                return SingleChildScrollView(
                  child: Padding(
                    padding: const EdgeInsets.all(20.0),
                    child: Column(
                      children: [
                        const SizedBox(height: 10),
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            IconButton(
                              icon: const Icon(Icons.arrow_back,
                                  color: Colors.white),
                              onPressed: () {
                                Navigator.pop(context, true);
                              },
                            ),
                            const Text(
                              "Edit Car",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                fontFamily: "amiko",
                              ),
                            ),
                            const SizedBox(width: 48),
                          ],
                        ),
                        const SizedBox(height: 10),
                        Divider(color: Colors.white70, thickness: 1.5),
                        const SizedBox(height: 16),
                        ValueListenableBuilder<File?>(
                          valueListenable: imageNotifier,
                          builder: (context, imageFile, child) {
                            return ImageSection(
                              baseImgUrl: baseUrl,
                              car: car,
                              imageFile: imageFile,
                              onImagePicked: (file, path) {
                                imageNotifier.value = file;
                                imagePath = path;
                              },
                            );
                          },
                        ),
                        const SizedBox(height: 20),
                        buildTextField("ป้ายทะเบียนรถ", Icons.directions_car,
                            plateController),
                        const SizedBox(height: 10),
                        buildTextField(
                            "รุ่นรถ", Icons.car_repair, modelController),
                        const SizedBox(height: 10),
                        buildDropdownField(
                          selectedTypeNotifier: selectedTypeNotifier,
                          typeController: typeController,
                        ),
                        const SizedBox(height: 30),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: state is SettingLoading
                                ? null
                                : () async {
                                    BlocProvider.of<SettingBloc>(context).add(
                                      UpdateCar(
                                        id: widget.car_id,
                                        plate: plateController.text,
                                        model: modelController.text,
                                        type: selectedTypeNotifier.value!,
                                        imageFile: imagePath != null
                                            ? File(imagePath!)
                                            : null,
                                      ),
                                    );
                                  },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.green,
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: state is SettingLoading
                                ? const CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(Colors.white),
                                  )
                                : const Text(
                                    "Update Car",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: "amiko",
                                    ),
                                  ),
                          ),
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () {
                              confirmDeleteCar(context, widget.car_id);
                            },
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
                                fontWeight: FontWeight.bold,
                                fontFamily: "amiko",
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
          },
        ),
      ),
    );
  }
}


