import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:car_parking_reservation/bloc/setting/setting_bloc.dart';
import 'package:car_parking_reservation/bloc/setting/setting_event.dart';
import 'package:car_parking_reservation/bloc/setting/setting_state.dart';
import 'package:car_parking_reservation/Widget/custom_dialog.dart';

final String fontFamily = "amiko";

void showChangePasswordModal(BuildContext context) {
  final settingBloc = context.read<SettingBloc>();
  final oldPasswordController = TextEditingController();
  final newPasswordController = TextEditingController();
  final confirmPasswordController = TextEditingController();

  showDialog(
    context: context,
    builder: (BuildContext dialogContext) {
      return BlocProvider.value(
        value: settingBloc,
        child: BlocListener<SettingBloc, SettingState>(
          listener: (context, state) {
            if (state is EditSuccess) {
              Navigator.pop(dialogContext);
              showCustomDialogSucess(context, state.message);
              oldPasswordController.clear();
              newPasswordController.clear();
              confirmPasswordController.clear();
            } else if (state is EditError) {
              showCustomDialogError(context, state.message);
            }
          },
          child: AlertDialog(
            shape: RoundedRectangleBorder(
              borderRadius: BorderRadius.circular(12),
            ),
            backgroundColor: Colors.white,
            title: Text('Change Password',
                style: TextStyle(fontFamily: fontFamily, color: Colors.black)),
            content: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                buildPasswordField('Old Password', oldPasswordController),
                const SizedBox(height: 10),
                buildPasswordField('New Password', newPasswordController),
                const SizedBox(height: 10),
                buildPasswordField(
                    'Confirm Password', confirmPasswordController),
              ],
            ),
            actions: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  ElevatedButton(
                    onPressed: () {
                      context.read<SettingBloc>().add(UpdatePassword(
                            oldPassword: oldPasswordController.text,
                            newPassword: newPasswordController.text,
                            confirm_password: confirmPasswordController.text,
                          ));
                    },
                    style: ElevatedButton.styleFrom(
                      padding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      backgroundColor: Colors.green,
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text("Update",
                        style: TextStyle(
                            fontFamily: fontFamily,
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 16)),
                  ),
                  ElevatedButton(
                    onPressed: () {
                      Navigator.of(dialogContext).pop();
                    },
                    style: ElevatedButton.styleFrom(
                      padding:
                          EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                      backgroundColor: const Color.fromARGB(255, 251, 251, 251),
                      shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(12)),
                    ),
                    child: Text("Cancel",
                        style: TextStyle(
                            fontFamily: fontFamily,
                            color: const Color.fromARGB(255, 0, 0, 0),
                            fontWeight: FontWeight.bold,
                            fontSize: 16)),
                  ),
                ],
              ),
            ],
          ),
        ),
      );
    },
  );
}

Widget buildPasswordField(String label, TextEditingController controller) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: TextField(
      controller: controller,
      obscureText: true,
      decoration: InputDecoration(
        labelText: label,
        labelStyle: TextStyle(fontFamily: fontFamily, color: Colors.black),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Colors.grey[200],
      ),
      style: TextStyle(fontFamily: fontFamily, color: Colors.black),
    ),
  );
}

Widget buildTextField(String labelText, IconData icon,
    TextEditingController controller, TextInputType keyboardType,
    {bool readOnly = false}) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: TextField(
      controller: controller,
      readOnly: readOnly,
      keyboardType: keyboardType,
      decoration: InputDecoration(
        labelStyle: TextStyle(fontFamily: fontFamily, color: Colors.black),
        prefixIcon: Icon(icon, color: Colors.black),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        filled: true,
        fillColor: Colors.white,
      ),
      style: TextStyle(fontFamily: fontFamily, color: Colors.black),
    ),
  );
}
