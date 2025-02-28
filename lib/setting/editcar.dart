import 'dart:io';
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

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(
            color: Colors.white,
            fontFamily: "amiko",
          ),
        ),
        backgroundColor: Colors.blueAccent,
        behavior: SnackBarBehavior.floating,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(10),
        ),
        margin: const EdgeInsets.all(10),
      ),
    );
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
          _showSnackBar(context, state.message);
          Navigator.pop(context);
        } else if (state is SettingError) {
          _showSnackBar(context, state.message);
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

                plateController.text = car.car_number;
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
                                Navigator.pop(context,
                                    true); // Pass a result to indicate a reload is needed
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
                            const SizedBox(
                                width:
                                    48), // To balance the space taken by the back button
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
              fontFamily: "amiko",
            ),
          ),
          content: const Text(
            "คุณแน่ใจหรือไม่ว่าต้องการลบรถคันนี้?",
            style: TextStyle(
              fontFamily: "amiko",
            ),
          ),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(dialogContext),
              child: const Text(
                "Cancel",
                style: TextStyle(
                  fontFamily: "amiko",
                ),
              ),
            ),
            TextButton(
              onPressed: () {
                context.read<SettingBloc>().add(DeleteCar(id: widget.car_id));
                Navigator.pop(dialogContext); // ปิด Dialog
              },
              style: TextButton.styleFrom(foregroundColor: Colors.red),
              child: const Text(
                "Delete",
                style: TextStyle(
                  fontFamily: "amiko",
                ),
              ),
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
            height: 200,
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
