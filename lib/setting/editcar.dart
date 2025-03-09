import 'dart:io';
import 'package:car_parking_reservation/Widget/custom_dialog.dart';
import 'package:car_parking_reservation/setting/widget/widget_editcar.dart'; // Import the widget_editcar.dart
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:car_parking_reservation/bloc/setting/setting_bloc.dart';
import 'package:car_parking_reservation/bloc/setting/setting_event.dart';
import 'package:car_parking_reservation/bloc/setting/setting_state.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';

const String fontFamily = "amiko";

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

  Future<bool> _onWillPop() async {
    context.read<SettingBloc>().add(LoadUserAndCars());
    return true;
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: _onWillPop,
      child: BlocListener<SettingBloc, SettingState>(
        listener: (context, state) {
          if (state is SettingSuccess) {
            showCustomDialogSucess(context, state.message);
            Navigator.pop(context, true);
          } else if (state is SettingError) {
            showCustomDialogWarning(context, state.message);
          }
        },
        child: Scaffold(
          backgroundColor: const Color(0xFF03174C),
          body: BlocBuilder<SettingBloc, SettingState>(
            builder: (context, state) {
              if (state is SettingLoading) {
                return const Center(
                  child: CircularProgressIndicator(),
                );
              } else if (state is SettingError) {
                return Center(
                  child: Text(
                    'Error: ${state.message}',
                    style: const TextStyle(
                      fontFamily: fontFamily,
                    ),
                  ),
                );
              } else if (state is CarLoaded) {
                final car = state.car;
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
                                context
                                    .read<SettingBloc>()
                                    .add(LoadUserAndCars());
                              },
                            ),
                            const Text(
                              "Edit Car",
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                fontFamily: fontFamily,
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
                        buildTextField("License plate", Icons.directions_car,
                            plateController),
                        const SizedBox(height: 10),
                        buildTextField(
                            "Car Models", Icons.car_repair, modelController),
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
                            onPressed: () async {
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
                              backgroundColor: const Color(0xFF4CAF50),
                              shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(12),
                              ),
                            ),
                            child: state is UserLoading
                                ? const CircularProgressIndicator(
                                    valueColor: AlwaysStoppedAnimation<Color>(
                                        Colors.white),
                                  )
                                : const Text(
                                    "Update Car",
                                    style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: fontFamily,
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
                                fontFamily: fontFamily,
                              ),
                            ),
                          ),
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
