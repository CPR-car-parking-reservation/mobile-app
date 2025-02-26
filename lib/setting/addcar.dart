import 'dart:io';
import 'package:car_parking_reservation/bloc/setting/setting_bloc.dart';
import 'package:car_parking_reservation/bloc/setting/setting_event.dart';
import 'package:car_parking_reservation/bloc/setting/setting_state.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';

class AddCarPage extends StatefulWidget {
  const AddCarPage({super.key});

  @override
  _AddCarPageState createState() => _AddCarPageState();
}

class _AddCarPageState extends State<AddCarPage> {
  TextEditingController plateController = TextEditingController();
  TextEditingController modelController = TextEditingController();
  TextEditingController typeController = TextEditingController();
  File? imageFile;

  Future<void> pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      String fileExtension = pickedFile.path.split('.').last.toLowerCase();
      if (['png', 'jpg', 'jpeg'].contains(fileExtension)) {
        setState(() {
          imageFile = File(pickedFile.path);
        });
      } else {
        // ignore: use_build_context_synchronously
        _showSnackBar(context, 'กรุณาเลือกไฟล์รูปภาพ (.png, .jpg, .jpeg)');
      }
    }
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: const TextStyle(color: Colors.white),
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

  Widget buildTextField(
      String label, IconData icon, TextEditingController controller) {
    return TextField(
      controller: controller,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.black),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        labelText: label,
        labelStyle: const TextStyle(color: Colors.black, fontSize: 16),
        floatingLabelBehavior: FloatingLabelBehavior.never,
      ),
      style: const TextStyle(color: Colors.black),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SettingBloc, SettingState>(
      listener: (context, state) {
        if (state is SettingSuccess) {
          Future.microtask(() => Navigator.of(context).pop('Car added successfully'));
        } else if (state is SettingError) {
          _showSnackBar(context, state.message);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF03174C),
          title: const Text(
            "Add Car",
            style: TextStyle(
                color: Colors.white, fontSize: 22, fontWeight: FontWeight.bold),
          ),
          centerTitle: true,
        ),
        backgroundColor: const Color(0xFF03174C), // Set background color
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: ConstrainedBox(
              constraints: BoxConstraints(
                minHeight:
                    MediaQuery.of(context).size.height - kToolbarHeight - 32,
              ),
              child: IntrinsicHeight(
                child: Column(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    const SizedBox(height: 10),
                    Divider(color: Colors.white70, thickness: 1.5),
                    const SizedBox(height: 16),
                    Stack(
                      alignment: Alignment.bottomRight,
                      children: [
                        Card(
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          child: Container(
                            width: 350,
                            height: 230,
                            decoration: BoxDecoration(
                              borderRadius: BorderRadius.circular(12),
                              image: imageFile != null
                                  ? DecorationImage(
                                      image: FileImage(imageFile!),
                                      fit: BoxFit.cover,
                                    )
                                  : null,
                            ),
                            child: imageFile == null
                                ? Center(
                                    child: IconButton(
                                      onPressed: pickImage,
                                      icon: const Icon(Icons.image,
                                          color: Colors.grey, size: 60.0),
                                      tooltip: 'เลือกภาพ',
                                    ),
                                  )
                                : null,
                          ),
                        ),
                        if (imageFile != null)
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.orange,
                              shape: BoxShape.circle,
                              border: Border.all(color: Colors.white, width: 2),
                            ),
                            child: IconButton(
                              icon: const Icon(Icons.edit, size: 16, color: Colors.white),
                              onPressed: pickImage,
                            ),
                          ),
                      ],
                    ),
                    const SizedBox(height: 20),
                    buildTextField("ป้ายทะเบียน", Icons.directions_car, plateController),
                    const SizedBox(height: 10),
                    buildTextField("รุ่นรถ", Icons.car_repair, modelController),
                    const SizedBox(height: 10),
                    buildTextField("ประเภทรถ", Icons.category, typeController),
                    const SizedBox(height: 20),
                    ElevatedButton(
                      onPressed: () {
                        if (imageFile != null) {
                          context.read<SettingBloc>().add(AddCar(
                                plate: plateController.text,
                                model: modelController.text,
                                type: typeController.text,
                                imageFile: imageFile!,
                              ));
                        } else {
                          _showSnackBar(context, 'กรุณาเลือกภาพ');
                        }
                      },
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.green,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12),
                        ),
                        minimumSize: const Size(
                            double.infinity, 50), // Set width and height
                      ),
                      child: const Text(
                        "Add Car",
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}