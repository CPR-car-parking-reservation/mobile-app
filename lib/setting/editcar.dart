import 'dart:io';
import 'package:car_parking_reservation/Widget/custom_dialog.dart';
import 'package:car_parking_reservation/setting/addcar.dart';
import 'package:flutter/material.dart';
import 'package:car_parking_reservation/model/car.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:car_parking_reservation/bloc/setting/setting_bloc.dart';
import 'package:car_parking_reservation/bloc/setting/setting_event.dart';
import 'package:car_parking_reservation/bloc/setting/setting_state.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:image_picker/image_picker.dart';

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

  Future<void> pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      String fileExtension = pickedFile.path.split('.').last.toLowerCase();
      if (['png', 'jpg', 'jpeg'].contains(fileExtension)) {
        imageNotifier.value = File(pickedFile.path);
        imagePath = pickedFile.path;
      }
    }
  }

  Widget buildDropdownField() {
    return ValueListenableBuilder<String?>(
      valueListenable: selectedTypeNotifier,
      builder: (context, selectedType, child) {
        // รายการที่สามารถเลือกได้
        List<String> carTypes = ['Fuels', 'Electric'];

        // ตรวจสอบว่า selectedType อยู่ในรายการหรือไม่
        if (!carTypes.contains(selectedType)) {
          selectedTypeNotifier.value = carTypes.first; // ตั้งค่าเริ่มต้นใหม่
        }

        return DropdownButtonFormField<String>(
          value: selectedTypeNotifier.value, // ใช้ค่าใหม่ที่ตรวจสอบแล้ว
          decoration: InputDecoration(
            prefixIcon: Icon(Icons.category, color: Colors.black),
            filled: true,
            fillColor: Colors.white,
            border: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide.none,
            ),
            enabledBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.black, width: 1),
            ),
            focusedBorder: OutlineInputBorder(
              borderRadius: BorderRadius.circular(12),
              borderSide: BorderSide(color: Colors.blue, width: 2),
            ),
            labelText: "ประเภทรถ",
            labelStyle: const TextStyle(color: Colors.black, fontSize: 16),
            floatingLabelBehavior: FloatingLabelBehavior.never,
          ),
          items: carTypes.map((String value) {
            return DropdownMenuItem<String>(
              value: value,
              child: Text(
                value,
                style: const TextStyle(
                  color: Colors.black,
                  fontFamily: "amiko",
                ),
              ),
            );
          }).toList(),
          onChanged: (newValue) {
            selectedTypeNotifier.value = newValue;
            typeController.text = newValue!;
          },
          style: const TextStyle(color: Colors.black),
          dropdownColor: Colors.white,
          icon: const Icon(Icons.arrow_drop_down, color: Colors.black),
          iconSize: 24,
        );
      },
    );
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
                        buildDropdownField(),
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
                                            : null));
                              },
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: Colors.green,
                                  shape: RoundedRectangleBorder(
                                      borderRadius: BorderRadius.circular(12))),
                              child: const Text(
                                "Update Car",
                                style: TextStyle(
                                  color: Colors.white,
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  fontFamily: "amiko",
                                ),
                              )),
                        ),
                        const SizedBox(height: 10),
                        SizedBox(
                          width: double.infinity,
                          height: 50,
                          child: ElevatedButton(
                            onPressed: () {
                              confirmDeleteCar(context);
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
          title: const Text(
            "Delete Car",
            style: TextStyle(
              fontFamily: fontFamily,
            ),
          ),
          content: const Text(
            "Are you sure you want to delete this car?",
            style: TextStyle(
              fontFamily: fontFamily,
              fontSize: 16,
            ),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    context
                        .read<SettingBloc>()
                        .add(DeleteCar(id: widget.car_id));
                    Navigator.pop(dialogContext);
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    backgroundColor: const Color.fromARGB(255, 255, 0, 0),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text("Delete",
                      style: TextStyle(
                          fontFamily: fontFamily,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 16)),
                ),
                ElevatedButton(
                  onPressed: () => Navigator.pop(dialogContext),
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    backgroundColor: const Color.fromARGB(255, 255, 255, 255),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text("Cancel",
                      style: TextStyle(
                          fontFamily: fontFamily,
                          color: Color.fromARGB(255, 0, 0, 0),
                          fontWeight: FontWeight.bold,
                          fontSize: 16)),
                ),
              ],
            ),
          ],
        );
      },
    );
  }
}

class ImageSection extends StatelessWidget {
  final String baseImgUrl;
  final car_data car;
  final File? imageFile;
  final Function(File, String) onImagePicked;

  const ImageSection({
    super.key,
    required this.baseImgUrl,
    required this.car,
    required this.imageFile,
    required this.onImagePicked,
  });

  Future<void> pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      String fileExtension = pickedFile.path.split('.').last.toLowerCase();
      if (['png', 'jpg', 'jpeg'].contains(fileExtension)) {
        onImagePicked(File(pickedFile.path), pickedFile.path);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        Card(
          elevation: 5,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: Container(
            width: double.infinity,
            height: 180,
            decoration: BoxDecoration(
              borderRadius: BorderRadius.circular(12),
              image: imageFile != null
                  ? DecorationImage(
                      image: FileImage(imageFile!),
                      fit: BoxFit.cover,
                    )
                  : DecorationImage(
                      image: NetworkImage('$baseImgUrl${car.image_url}'),
                      fit: BoxFit.cover,
                    ),
            ),
          ),
        ),
        Container(
          decoration: BoxDecoration(
            color: Colors.orange,
            shape: BoxShape.circle,
            border: Border.all(color: Colors.white, width: 2),
          ),
          child: IconButton(
            icon: const Icon(Icons.edit, size: 16, color: Colors.white),
            onPressed: () {
              pickImage();
            },
          ),
        ),
      ],
    );
  }
}
