import 'dart:io';
import 'package:flutter/material.dart';
import 'package:car_parking_reservation/model/car.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:car_parking_reservation/bloc/setting/setting_bloc.dart';
import 'package:car_parking_reservation/bloc/setting/setting_event.dart';
import 'package:car_parking_reservation/bloc/setting/setting_state.dart';
import 'package:image_picker/image_picker.dart';

class EditCarPage extends StatefulWidget {
  // ignore: non_constant_identifier_names
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
  final ValueNotifier<File?> imageNotifier = ValueNotifier<File?>(null);
  File? imageFile;
  String? imagePath;

  String baseImgUrl = 'https://legend-trees-tee-shed.trycloudflare.com';

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
        setState(() {
          imageFile = File(pickedFile.path);
          imagePath = pickedFile.path;
        });
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
          _showSnackBar(context, state.message);
          Navigator.pop(context);
        } else if (state is SettingError) {
          _showSnackBar(context, state.message);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          title: const Text(
            'Edit Car',
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: const Color(0xFF03174C),
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
                          ImageSection(
                            baseImgUrl: baseImgUrl,
                            car: car,
                            imageFile: imageFile,
                            onImagePicked: (file, path) {
                              setState(() {
                                imageFile = file;
                                imagePath = path;
                              });
                            },
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
                                  imageFile: imagePath != null ? File(imagePath!) : null,
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



class ImageSection extends StatefulWidget {
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

  @override
  _ImageSectionState createState() => _ImageSectionState();
}

class _ImageSectionState extends State<ImageSection> {
  Future<void> pickImage() async {
    final pickedFile =
        await ImagePicker().pickImage(source: ImageSource.gallery);
    if (pickedFile != null) {
      String fileExtension = pickedFile.path.split('.').last.toLowerCase();
      if (['png', 'jpg', 'jpeg'].contains(fileExtension)) {
        widget.onImagePicked(File(pickedFile.path), pickedFile.path);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      alignment: Alignment.bottomRight,
      children: [
        if (widget.imageFile != null)
          Image.file(widget.imageFile!, height: 200, width: 200),
        if (widget.imageFile == null)
          Image.network(
            '${widget.baseImgUrl}${widget.car.image_url}',
            height: 200,
            width: 200,
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
