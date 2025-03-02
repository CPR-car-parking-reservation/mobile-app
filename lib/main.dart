import 'package:car_parking_reservation/admin/admin_home.dart';
import 'package:car_parking_reservation/reserv.dart';
import 'package:flutter/material.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'Login/signin.dart';
import 'Login/signup.dart';
import 'Login/welcome.dart';
import 'Widget/home.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: "Car Parking Reservation",
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        //'/': (context) => AdminHomePage(),
        '/': (context) => Welcome(),
        '/signin': (context) => Signin(),
        '/signup': (context) => Signup(),
        '/home': (context) => Home(),
        '/admin': (context) => AdminHomePage(),
        '/reserv': (context) => Reserv(),
      },
    );
  }
}
