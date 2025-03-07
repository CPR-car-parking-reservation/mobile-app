import 'dart:io';
import 'package:car_parking_reservation/bloc/setting/setting_event.dart';
import 'package:car_parking_reservation/model/car.dart';
import 'package:flutter/material.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:car_parking_reservation/bloc/setting/setting_bloc.dart';

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

Widget buildDropdownField({
  required ValueNotifier<String?> selectedTypeNotifier,
  required TextEditingController typeController,
}) {
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

void confirmDeleteCar(BuildContext context, String carId) {
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
          "Are you sure you want to delete this car?",
          style: TextStyle(
            fontFamily: "amiko",
            fontSize: 16,
          ),
        ),
        actions: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceEvenly,
            children: [
              ElevatedButton(
                onPressed: () {
                  context.read<SettingBloc>().add(DeleteCar(id: carId));
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
                        fontFamily: "amiko",
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
                        fontFamily: "amiko",
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

