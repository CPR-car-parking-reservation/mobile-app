import 'dart:io';
import 'package:car_parking_reservation/Widget/custom_dialog.dart';
import 'package:flutter/material.dart';
import 'package:car_parking_reservation/model/profile.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:image_picker/image_picker.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:car_parking_reservation/bloc/setting/setting_bloc.dart';
import 'package:car_parking_reservation/bloc/setting/setting_event.dart';
import 'package:car_parking_reservation/bloc/setting/setting_state.dart';
import 'package:car_parking_reservation/setting/widget/widget_editprofile.dart';

class EditProfilePage extends StatefulWidget {
  final Profile_data profile;

  const EditProfilePage({super.key, required this.profile});

  @override
  _EditProfilePageState createState() => _EditProfilePageState();
}

class _EditProfilePageState extends State<EditProfilePage> {
  late TextEditingController usernameController;
  late TextEditingController surnameController;
  late TextEditingController emailController;
  late TextEditingController phoneController;
  late TextEditingController oldPasswordController;
  late TextEditingController newPasswordController;
  late TextEditingController confirmPasswordController;
  File? imageFile;

  String baseUrl = dotenv.env['BASE_URL'].toString();
  final String fontFamily = "amiko";

  @override
  void initState() {
    super.initState();
    usernameController = TextEditingController(text: widget.profile.name);
    surnameController = TextEditingController(text: widget.profile.surname);
    phoneController = TextEditingController(text: widget.profile.phone);
    emailController = TextEditingController(text: widget.profile.email);
    oldPasswordController = TextEditingController();
    newPasswordController = TextEditingController();
    confirmPasswordController = TextEditingController();
  }

  @override
  void dispose() {
    usernameController.dispose();
    surnameController.dispose();
    phoneController.dispose();
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
        showCustomDialogWarning(
            context, 'Please select an image file. (.png, .jpg, .jpeg)');
      }
    }
  }

  void _updateProfile() {
    context.read<SettingBloc>().add(UpdateProfile(
          name: usernameController.text,
          surname: surnameController.text,
          phone: phoneController.text,
          imageFile: imageFile,
        ));
  }


  @override
  Widget build(BuildContext context) {
    final settingBloc = context.read<SettingBloc>();
    return BlocProvider.value(
      value: settingBloc,
      child: BlocListener<SettingBloc, SettingState>(
        listener: (context, state) {
          if (state is SettingSuccess) {
            Navigator.pop(context);
            showCustomDialogSucess(context, state.message);
          } else if (state is SettingError) {
            showCustomDialogError(context, state.message);
          }
        },
        child: BlocBuilder<SettingBloc, SettingState>(
          builder: (context, state) {
            return Scaffold(
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
                  style: TextStyle(color: Colors.white, fontFamily: fontFamily),
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
                              radius: 60,
                              backgroundColor: Colors.white,
                              child: ClipOval(
                                child: imageFile != null
                                    ? Image.file(imageFile!,
                                        fit: BoxFit.cover,
                                        width: 140,
                                        height: 140)
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
                      buildTextField("Username", Icons.person,
                          usernameController, TextInputType.text),
                      buildTextField("Surname", Icons.person, surnameController,
                          TextInputType.text),
                      buildTextField("Phone", Icons.phone, phoneController,
                          TextInputType.number),
                      buildTextField("Email", Icons.email, emailController,
                          TextInputType.text,
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
                          child: state is UserLoading
                              ? CircularProgressIndicator(
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                )
                              : Text(
                                  "Update Profile",
                                  style: TextStyle(
                                      color: Colors.white,
                                      fontSize: 18,
                                      fontWeight: FontWeight.bold,
                                      fontFamily: fontFamily),
                                ),
                        ),
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        width: double.infinity,
                        height: 50,
                        child: ElevatedButton(
                          onPressed: () {
                            showChangePasswordModal(context);
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
            );
          },
        ),
      ),
    );
  }
}
