import 'package:car_parking_reservation/Bloc/admin_bloc/admin_setting/admin_setting_bloc.dart';
import 'package:car_parking_reservation/Widget/custom_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

void change_password_admin(BuildContext context) {
  TextEditingController oldPasswordController = TextEditingController();
  TextEditingController newPasswordController = TextEditingController();
  TextEditingController confirmPasswordController = TextEditingController();

  showDialog(
    context: context,
    builder: (context) {
      return BlocListener<AdminSettingBloc, AdminSettingState>(
        listener: (context, state) {
          if (state is AdminSettingSuccess) {
            showCustomDialogSucess(context, state.message);
            Navigator.pop(context);
          } else if (state is AdminSettingFailed) {
            showCustomDialogError(context, state.message);
          }
        },
        child: AlertDialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
          title: Text("Change Password",
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Amiko',
                  color: Colors.black)),
          content: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              TextField(
                controller: oldPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "Old Password",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: newPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "New Password",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                controller: confirmPasswordController,
                obscureText: true,
                decoration: InputDecoration(
                  labelText: "Confirm Password",
                  border: OutlineInputBorder(
                      borderRadius: BorderRadius.circular(10)),
                ),
              ),
            ],
          ),
          actions: [
            ElevatedButton(
              onPressed: () {
                context.read<AdminSettingBloc>().add(OnUpdatePassword(
                    old_password: oldPasswordController.text,
                    new_password: newPasswordController.text,
                    confirm_password: confirmPasswordController.text));
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: Text("Save",
                  style: TextStyle(
                      color: Colors.white,
                      fontFamily: 'Amiko',
                      fontWeight: FontWeight.bold)),
            ),
            TextButton(
              onPressed: () {
                Navigator.pop(context);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.white,
                shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(12)),
              ),
              child: Text("Cancel",
                  style: TextStyle(
                      color: Colors.black,
                      fontFamily: 'Amiko',
                      fontWeight: FontWeight.bold)),
            ),
          ],
        ),
      );
    },
  );
}
