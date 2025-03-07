import 'package:car_parking_reservation/Login/signin.dart';
import 'package:car_parking_reservation/bloc/navigator/navigator_bloc.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'package:car_parking_reservation/setting/editcar.dart';
import 'package:car_parking_reservation/model/car.dart';

const String fontFamily = "amiko";

ListView listviewshow(List<car_data> car) {
  String baseUrl = dotenv.env['BASE_URL'].toString();
  return ListView.separated(
    itemBuilder: (context, index) {
      return Container(
        margin: const EdgeInsets.symmetric(vertical: 6),
        decoration: BoxDecoration(
            color: Colors.white, borderRadius: BorderRadius.circular(12)),
        padding: const EdgeInsets.all(12),
        child: Row(
          children: [
            Image.network(
              '$baseUrl${car[index].image_url}',
              width: 100,
              height: 60,
              fit: BoxFit.contain,
            ),
            const SizedBox(width: 12),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text("License plate",
                    style: TextStyle(
                        color: Colors.black,
                        fontSize: 16,
                        fontFamily: fontFamily,
                        fontWeight: FontWeight.w600)),
                Text(car[index].license_plate,
                    style: const TextStyle(
                      color: Colors.black,
                        fontSize: 15,
                        fontWeight: FontWeight.w500,
                        fontFamily: fontFamily)),
                Text(car[index].car_model,
                    style: const TextStyle(
                       fontSize: 15,
                        color: Color(0xFF6C6C6C),
                        fontFamily: fontFamily,
                        fontWeight: FontWeight.w500)),
                Text(car[index].car_type,
                    style: const TextStyle(
                       fontSize: 15,
                        color: Color(0xFF6C6C6C),
                        fontFamily: fontFamily,
                        fontWeight: FontWeight.w500)),
              ],
            ),
            const Spacer(),
            IconButton(
              onPressed: () async {
                await Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (context) => EditCarPage(car_id: car[index].id),
                  ),
                );
              },
              icon: const Icon(Icons.edit, color: Colors.orange),
            ),
          ],
        ),
      );
    },
    separatorBuilder: (context, index) => const Divider(),
    itemCount: car.length,
  );
}
void logout(BuildContext context) {
    Navigator.of(context, rootNavigator: true).pushAndRemoveUntil(
      MaterialPageRoute(builder: (context) => const Signin()),
      (route) => false,
    );
    context.read<NavigatorBloc>().add(ChangeIndex(index: 0));
  }


void confirmLogout(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext dialogContext) {
        return AlertDialog(
          title: const Text(
            "Log out",
            style: TextStyle(
              fontFamily: fontFamily,
            ),
          ),
          content: const Text(
            "Are you sure you want to log out?",
            style: TextStyle(
              fontFamily: fontFamily,
              fontSize: 16,
            ),
          ),
          actions: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceEvenly,
              children: [
                ElevatedButton(
                  onPressed: () {
                    logout(context);
                  },
                  style: ElevatedButton.styleFrom(
                    padding: EdgeInsets.symmetric(horizontal: 15, vertical: 10),
                    backgroundColor: const Color.fromARGB(255, 255, 0, 0),
                    shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(12)),
                  ),
                  child: Text("Confirm",
                      style: TextStyle(
                          fontFamily: fontFamily,
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
                          fontFamily: fontFamily,
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