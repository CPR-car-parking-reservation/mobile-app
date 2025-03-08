import 'dart:developer';

import 'package:car_parking_reservation/Bloc/admin_bloc/admin_setting/admin_setting_bloc.dart';
import 'package:car_parking_reservation/Widget/custom_dialog.dart';
import 'package:car_parking_reservation/admin/widgets/setting/dialog/edit_price_rate.dart';
import 'package:car_parking_reservation/admin/widgets/setting/dialog/logout_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminSettingPage extends StatefulWidget {
  const AdminSettingPage({super.key});

  @override
  State<AdminSettingPage> createState() => _AdminSettingPageState();
}

class _AdminSettingPageState extends State<AdminSettingPage> {
  final TextEditingController oldPasswordController = TextEditingController();
  final TextEditingController newPasswordController = TextEditingController();
  final TextEditingController confirmPasswordController =
      TextEditingController();
  final TextEditingController priceController = TextEditingController();
  String? token;

  @override
  void initState() {
    super.initState();
    context.read<AdminSettingBloc>().add(OnSettingPageLoad());
  }

  @override
  Widget build(BuildContext context) {
    showUpdatePasswordDialog(BuildContext context) {
      final bloc = context.read<AdminSettingBloc>();
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
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
                  bloc.add(OnUpdatePassword(
                      old_password: oldPasswordController.text,
                      new_password: newPasswordController.text,
                      confirm_password: confirmPasswordController.text));
                  Navigator.of(context).pop();
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
          );
        },
      );
    }

    edit_price_rate(BuildContext context, String price) {
      final bloc = context.read<AdminSettingBloc>();
      priceController.text = price; // ตั้งค่าเริ่มต้น
      showDialog(
        context: context,
        builder: (context) {
          return AlertDialog(
            backgroundColor: Colors.white,
            shape:
                RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
            title: Text(
              "Edit Price Rate",
              style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.bold,
                  fontFamily: 'Amiko',
                  color: Colors.black),
            ),
            content: TextField(
              controller: priceController,
              keyboardType: TextInputType.number,
              decoration: InputDecoration(
                labelText: "Price per Hour (฿)",
                border:
                    OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
              ),
            ),
            actions: [
              ElevatedButton(
                onPressed: () {
                  double? newRate = double.tryParse(priceController.text);
                  if (newRate != null) {
                    bloc.add(OnUpdatePriceRate(charge_rate: newRate));
                    Navigator.of(context).pop();
                  } else {
                    showCustomDialogError(context, "Invalid price format");
                  }
                },
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.green,
                  shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(12)),
                  elevation: 5,
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
                  backgroundColor: const Color.fromARGB(255, 251, 251, 251),
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
          );
        },
      );
    }

    return BlocListener<AdminSettingBloc, AdminSettingState>(
      listener: (context, state) {
        if (state is AdminSettingSuccess) {
          // Navigator.of(context).pop();
          showCustomDialogSucess(context, state.message);
          oldPasswordController.clear();
          newPasswordController.clear();
          confirmPasswordController.clear();
        } else if (state is AdminSettingFailed) {
          showCustomDialogError(context, state.message);
        }
      },
      child: Scaffold(
        body: SingleChildScrollView(
          child: Center(
            child: Column(
              children: [
                Column(
                  children: [
                    Text(
                      'Setting',
                      style: TextStyle(
                        fontSize: 26,
                        fontWeight: FontWeight.bold,
                        fontFamily: 'Amiko',
                        color: Colors.black87,
                      ),
                    ),
                    Divider(
                      height: 10,
                      endIndent: 60,
                      indent: 60,
                      color: Colors.black,
                    ),
                  ],
                ),
                SizedBox(height: 170),
                Column(
                  mainAxisAlignment:
                      MainAxisAlignment.center, // จัดให้อยู่ตรงกลางแนวตั้ง
                  crossAxisAlignment:
                      CrossAxisAlignment.center, // จัดให้อยู่ตรงกลางแนวนอน
                  children: [
                    Card(
                      color: Colors.white,
                      margin:
                          EdgeInsets.symmetric(vertical: 20, horizontal: 40),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(15), // มุมโค้งมน
                      ),
                      elevation: 5, // เพิ่มเงาให้ Card ดูโดดเด่น
                      child: Padding(
                        padding: const EdgeInsets.all(
                            20), // เพิ่ม Padding รอบเนื้อหา
                        child: Column(
                          mainAxisSize: MainAxisSize.min,
                          crossAxisAlignment: CrossAxisAlignment.center,
                          children: [
                            Row(
                              mainAxisAlignment: MainAxisAlignment.end,
                              children: [
                                Text(
                                  'Price / Hour',
                                  style: TextStyle(
                                    fontSize: 22,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Amiko',
                                    color: Colors.black87,
                                  ),
                                ),
                                SizedBox(width: 29),
                                Container(
                                  width: 36,
                                  height: 36,
                                  decoration: BoxDecoration(
                                    color: Colors.orange,
                                    shape: BoxShape.circle,
                                  ),
                                  child: BlocBuilder<AdminSettingBloc,
                                      AdminSettingState>(
                                    builder: (context, state) {
                                      return IconButton(
                                        onPressed: () {
                                          if (state
                                              is AdminSettingChangeRatePrice) {
                                            edit_price_rate(context,
                                                state.charge_rate.toString());
                                          } else {
                                            edit_price_rate(context, '0.00');
                                          }
                                        },
                                        icon: Icon(
                                          Icons.mode_edit_outline_rounded,
                                          color: Colors.white,
                                          size: 18,
                                        ),
                                        padding: EdgeInsets.zero,
                                        constraints: BoxConstraints(),
                                      );
                                    },
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            BlocBuilder<AdminSettingBloc, AdminSettingState>(
                              builder: (context, state) {
                                if(state is AdminSettingLoading){
                                  return CircularProgressIndicator();
                                }
                                return Text(
                                  state is AdminSettingChangeRatePrice
                                      ? state.charge_rate.toStringAsFixed(
                                          2) // แปลงเป็น string พร้อมทศนิยม 2 ตำแหน่ง
                                      : '0.00',
                                  style: TextStyle(
                                    fontSize: 24,
                                    fontWeight: FontWeight.bold,
                                    fontFamily: 'Amiko',
                                    color: Colors.green,
                                  ),
                                );
                              },
                            ),
                          ],
                        ),
                      ),
                    ),
                    ElevatedButton.icon(
                      onPressed: () {
                        showUpdatePasswordDialog(context);
                      },
                      label: Text(
                        'Change Password',
                        style: TextStyle(
                          fontSize: 16,
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontFamily: 'Amiko',
                        ),
                      ),
                      icon: Icon(Icons.lock, color: Colors.white),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.blue,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(
                              12), // ทำให้เป็นสี่เหลี่ยมโค้งมน
                        ),
                        elevation: 5,
                        padding:
                            EdgeInsets.symmetric(horizontal: 24, vertical: 12),
                      ),
                    ),
                  ],
                )
              ],
            ),
          ),
        ),
        floatingActionButton: FloatingActionButton.extended(
          onPressed: () {
            logout_admin_dialog(context);
          },
          backgroundColor: Colors.red,
          icon: Icon(Icons.logout, color: Colors.white),
          label: Text('Logout', style: TextStyle(color: Colors.white)),
        ),
        floatingActionButtonLocation:
            FloatingActionButtonLocation.endFloat, // อยู่ด้านขวาล่าง
      ),
    );
  }
}
