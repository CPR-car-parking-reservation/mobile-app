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

    return BlocListener<AdminSettingBloc, AdminSettingState>(
      listener: (context, state) {
        if(state is AdminSettingSuccess) 
        {
          Navigator.of(context).pop();
          showCustomDialogSucess(context, state.message);
          oldPasswordController.clear();
          newPasswordController.clear();
          confirmPasswordController.clear();
          
        } else if(state is AdminSettingFailed) {
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
                          crossAxisAlignment:
                              CrossAxisAlignment.center, // เนื้อหาอยู่กลาง Card
                          children: [
                            Row(
                              mainAxisAlignment:
                                  MainAxisAlignment.end, // จัดให้อยู่ตรงกลาง
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
                                  width: 36, // กำหนดขนาดวงกลมเล็กลง
                                  height: 36,
                                  decoration: BoxDecoration(
                                    color: Colors.orange,
                                    shape: BoxShape.circle,
                                  ),
                                  child: IconButton(
                                    onPressed: () {
                                      edit_price_rate(context, '20.00');
                                    },
                                    icon: Icon(
                                      Icons.mode_edit_outline_rounded,
                                      color: Colors.white,
                                      size: 18, // ลดขนาดไอคอน
                                    ),
                                    padding: EdgeInsets
                                        .zero, // ลบ padding เพื่อให้พอดีกับ Container
                                    constraints:
                                        BoxConstraints(), // ลบ constraints ของ IconButton เอง
                                  ),
                                ),
                              ],
                            ),
                            SizedBox(height: 10),
                            Text(
                              '💵: 20.00฿',
                              style: TextStyle(
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                                fontFamily: 'Amiko',
                                color: Colors.green, // ทำให้ราคาดูโดดเด่น
                              ),
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
