import 'package:car_parking_reservation/Login/signin.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

void logout_admin_dialog(BuildContext context) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        backgroundColor: Colors.white,
        title: const Text('Logout',
            style: TextStyle(fontFamily: 'Amiko', fontWeight: FontWeight.bold)),
        content: const Text('Are you sure you want to logout?'),
        actions: <Widget>[
          TextButton(
            onPressed: () {
              SharedPreferences.getInstance().then((prefs) {
                prefs.remove('token');
              });
              Navigator.pop(context); // ปิด Dialog
              Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
                MaterialPageRoute(builder: (context) => const Signin()),
                (route) => false,
              );
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
            ),
            child: Text("Confirm",
                style: TextStyle(
                    color: Colors.white,
                    fontFamily: 'Amiko',
                    fontWeight: FontWeight.bold)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // ปิด Dialog
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
