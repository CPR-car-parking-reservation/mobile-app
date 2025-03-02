import 'dart:io';
import 'package:flutter/material.dart';
import 'package:car_parking_reservation/model/profile.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:car_parking_reservation/bloc/setting/setting_bloc.dart';
import 'package:car_parking_reservation/bloc/setting/setting_event.dart';
import 'package:car_parking_reservation/bloc/setting/setting_state.dart';

class EditProfilePage extends StatefulWidget {
  final Profile_data profile;

  const EditProfilePage({super.key, required this.profile});

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController usernameController;
  late TextEditingController emailController;
  late TextEditingController oldPasswordController;
  late TextEditingController newPasswordController;
  late TextEditingController confirmPasswordController;
  File? imageFile;

  String baseUrl = dotenv.env['BASE_URL'].toString();
  final String fontFamily = "amiko"; // ตัวแปรเก็บค่า fontFamily

  @override
  void initState() {
    super.initState();
    usernameController = TextEditingController(text: widget.profile.name);
    emailController = TextEditingController(text: widget.profile.email);
    oldPasswordController = TextEditingController();
    newPasswordController = TextEditingController();
    confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    usernameController.dispose();
    emailController.dispose();
    oldPasswordController.dispose();
    newPasswordController.dispose();
    confirmPasswordController.dispose();
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
        });
      } else {
        // ignore: use_build_context_synchronously
        _showSnackBar(
            context, 'Please select an image file. (.png, .jpg, .jpeg)');
      }
    }
  }

  void _updateProfile() {
    context.read<SettingBloc>().add(UpdateProfile(
          name: usernameController.text,
          imageFile: imageFile,
        ));
  }

  void _showSnackBar(BuildContext context, String message) {
    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(
        content: Text(
          message,
          style: TextStyle(
            color: Colors.white,
            fontFamily: fontFamily, // เรียกใช้ตัวแปร fontFamily
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

  Widget buildTextField(
      String label, IconData icon, TextEditingController controller,
      {bool readOnly = false}) {
    return TextField(
      controller: controller,
      readOnly: readOnly,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.black),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        labelText: label,
        labelStyle: TextStyle(
            color: Colors.black,
            fontSize: 16,
            fontFamily: fontFamily), // เรียกใช้ตัวแปร fontFamily
        floatingLabelBehavior: FloatingLabelBehavior.never,
      ),
      style: TextStyle(
          color: Colors.black,
          fontFamily: fontFamily), // เรียกใช้ตัวแปร fontFamily
    );
  }

  void _showChangePasswordModal(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title:
              Text('Change Password', style: TextStyle(fontFamily: fontFamily)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              buildPasswordField('Old Password', oldPasswordController),
              const SizedBox(height: 10),
              buildPasswordField('New Password', newPasswordController),
              const SizedBox(height: 10),
              buildPasswordField('Confirm Password', confirmPasswordController),
            ],
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: Text('Cancel', style: TextStyle(fontFamily: fontFamily)),
            ),
            ElevatedButton(
              onPressed: () {
                // Add your update password logic here
                Navigator.of(context).pop();
              },
              child: Text('Update Password',
                  style: TextStyle(fontFamily: fontFamily)),
            ),
          ],
        );
      },
    );
  }

  Widget buildPasswordField(String label, TextEditingController controller) {
    return TextField(
      controller: controller,
      obscureText: true,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(fontFamily: fontFamily),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
      ),
      style: TextStyle(fontFamily: fontFamily),
    );
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<SettingBloc, SettingState>(
      listener: (context, state) {
        if (state is SettingSuccess) {
          _showSnackBar(context, state.message);
          Navigator.pop(context, state.message);
        } else if (state is SettingError) {
          _showSnackBar(context, state.message);
        }
      },
      child: Scaffold(
        appBar: AppBar(
          backgroundColor: const Color(0xFF03174C),
          leading: IconButton(
            icon: Icon(Icons.arrow_back, color: Colors.white),
            onPressed: () {
              Navigator.pop(context);
            },
          ),
          title: Text(
            "Edit Profile",
            style: TextStyle(
                color: Colors.white,
                fontFamily: fontFamily), // เรียกใช้ตัวแปร fontFamily
          ),
          centerTitle: true,
        ),
        backgroundColor: const Color(0xFF03174C),
        body: SingleChildScrollView(
          child: Padding(
            padding: const EdgeInsets.all(20.0),
            child: Column(
              children: [
                const SizedBox(height: 10),

                // Divider เส้นคั่น
                Divider(color: Colors.white70, thickness: 1.5),

                const SizedBox(height: 16),
                Stack(
                  alignment: Alignment.bottomRight,
                  children: [
                    Container(
                      decoration: BoxDecoration(
                        shape: BoxShape.circle,
                        color: Colors.white, // สีขาวครอบ
                      ),
                      padding: const EdgeInsets.all(7.0),
                      child: CircleAvatar(
                        radius: 70,
                        backgroundColor: Colors.white,
                        child: ClipOval(
                          child: imageFile != null
                              ? Image.file(imageFile!,
                                  fit: BoxFit.cover, width: 140, height: 140)
                              : Image.network(
                                  '$baseUrl${widget.profile.image_url}',
                                  fit: BoxFit.cover,
                                  width: 140,
                                  height: 140),
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
                        icon: const Icon(Icons.edit,
                            size: 16, color: Colors.white),
                        onPressed: () {
                          pickImage();
                        },
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 40),
                buildTextField("Username", Icons.person, usernameController),
                const SizedBox(height: 15),
                buildTextField("Email", Icons.email, emailController,
                    readOnly: true),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: _updateProfile,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      "Update Profile",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          fontFamily: fontFamily), // เรียกใช้ตัวแปร fontFamily
                    ),
                  ),
                ),
                const SizedBox(height: 20),
                SizedBox(
                  width: double.infinity,
                  height: 50,
                  child: ElevatedButton(
                    onPressed: () {
                      _showChangePasswordModal(context);
                    },
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Colors.blue,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12),
                      ),
                    ),
                    child: Text(
                      "Change Password",
                      style: TextStyle(
                          color: Colors.white,
                          fontSize: 18,
                          fontWeight: FontWeight.bold,
                          fontFamily: fontFamily),
                    ),
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
