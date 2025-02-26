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

  @override
  Widget build(BuildContext context) {
    return BlocListener<SettingBloc, SettingState>(
      listener: (context, state) {
        if (state is SettingSuccess) {
          if (Navigator.canPop(context)) {
            Navigator.pop(context, state.message);
          }
        } else if (state is SettingError) {
          _showSnackBar(context, state.message);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF03174C),
          // leading: IconButton(
          //   icon: const Icon(Icons.arrow_back, color: Colors.white),
          //   onPressed: () => Navigator.pop(context),
          // ),
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
                    if (imageFile != null)
                      Image.file(imageFile!, height: 200, width: 200)
                    else
                      IconButton(
                        onPressed: pickImage,
                        icon: const Icon(Icons.image,
                            color: Colors.white, size: 60.0),
                        tooltip: 'เลือกภาพ',
                      ),
                    const SizedBox(height: 20),
                    TextField(
                      controller: plateController,
                      decoration: const InputDecoration(
                        labelText: "ป้ายทะเบียน",
                        labelStyle: TextStyle(color: Colors.white),
                      ),
                      style: const TextStyle(color: Colors.white),
                    ),
                    TextField(
                      controller: modelController,
                      decoration: const InputDecoration(
                        labelText: "รุ่นรถ",
                        labelStyle: TextStyle(color: Colors.white),
                      ),
                      style: const TextStyle(color: Colors.white),
                    ),
                    TextField(
                      controller: typeController,
                      decoration: const InputDecoration(
                        labelText: "ประเภทรถ",
                        labelStyle: TextStyle(color: Colors.white),
                      ),
                      style: const TextStyle(color: Colors.white),
                    ),
                    const SizedBox(height: 10),
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