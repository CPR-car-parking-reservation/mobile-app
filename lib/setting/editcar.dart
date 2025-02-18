import 'package:flutter/material.dart';



// Model สำหรับข้อมูลรถยนต์
// lib/models/car_model.dart
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


class EditCarPage extends StatefulWidget {
  final int index;
  final Car car;
  final void Function(int, Car) updateCar;
  final void Function(int) deleteCar;

  const EditCarPage({
    super.key,
    required this.index,
    required this.car,
    required this.updateCar,
    required this.deleteCar,
  });

  // ignore: library_private_types_in_public_api
  @override
  // ignore: library_private_types_in_public_api
  _EditCarPageState createState() => _EditCarPageState();
  
  Widget build(BuildContext context) => throw UnimplementedError();
}

class _EditCarPageState extends State<EditCarPage> {
  late TextEditingController plateController;
  late TextEditingController modelController;
  late TextEditingController typeController;

  @override
  void initState() {
    super.initState();
    plateController = TextEditingController(text: widget.car.plateNumber);
    modelController = TextEditingController(text: widget.car.model);
    typeController = TextEditingController(text: widget.car.type);
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
    return Scaffold(
      appBar: AppBar(
        backgroundColor: const Color(0xFF0A1D56),
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
      backgroundColor: const Color(0xFF0A1D56),
      body: SingleChildScrollView(
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
                  Image.asset(
                    widget.car.image,
                    width: 250,
                    height: 150,
                    fit: BoxFit.cover,
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
                        // ฟังก์ชันเปลี่ยนรูป
                      },
                    ),
                  ),
                ],
              ),
              const SizedBox(height: 20),
              buildTextField(
                  "ป้ายทะเบียนรถ", Icons.directions_car, plateController),
              const SizedBox(height: 10),
              buildTextField("รุ่นรถ", Icons.car_repair, modelController),
              const SizedBox(height: 10),
              buildTextField("ประเภทรถ", Icons.category, typeController),
              const SizedBox(height: 30),
              SizedBox(
                width: double.infinity,
                height: 50,
                child: ElevatedButton(
                  onPressed: () {
                    // เมื่อกดอัปเดตรถ
                    widget.updateCar(
                      widget.index, // ใช้ index ของรถ
                      Car(
                        image: widget.car.image,
                        plateNumber: plateController.text,
                        model: modelController.text,
                        type: typeController.text,
                      ),
                    );
                    Navigator.pop(context); // ปิดหน้า EditCarPage
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
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text("Delete Car"),
          content: const Text("คุณแน่ใจหรือไม่ว่าต้องการลบรถคันนี้?"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("Cancel"),
            ),
            TextButton(
              onPressed: () {
                widget.deleteCar(widget.index); // ลบรถ
                Navigator.pop(context); // ปิด Dialog
                Navigator.pop(context); // กลับไปหน้า SettingPage
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
