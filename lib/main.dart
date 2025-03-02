import 'package:car_parking_reservation/Bloc/reserved/reserved_bloc.dart';
import 'package:car_parking_reservation/admin/admin_home.dart';
import 'package:car_parking_reservation/bloc/admin_bloc/admin_navigator/admin_navigator_bloc.dart';
import 'package:car_parking_reservation/bloc/admin_bloc/admin_parking/admin_parking_bloc.dart';
import 'package:car_parking_reservation/bloc/navigator/navigator_bloc.dart';
import 'package:car_parking_reservation/reserv.dart';
import 'package:car_parking_reservation/setting/setting_page.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_dotenv/flutter_dotenv.dart';
import 'Login/signin.dart';
import 'Login/signup.dart';
import 'Login/welcome.dart';
import 'Widget/home.dart';
import 'history.dart';

Future<void> main() async {
  await dotenv.load(fileName: ".env");
  runApp(MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
        useMaterial3: true,
      ),
      initialRoute: '/',
      onGenerateRoute: (settings) {
        switch (settings.name) {
          case '/':
            return MaterialPageRoute(builder: (_) => AdminHomePage());
          case '/signin':
            return MaterialPageRoute(builder: (_) => Signin());
          case '/signup':
            return MaterialPageRoute(builder: (_) => Signup());
          case '/home':
            return MaterialPageRoute(builder: (_) => Home());
          case '/reserv':
            return MaterialPageRoute(builder: (_) => Reserv());
          case '/history':
            return MaterialPageRoute(builder: (_) => History());
          case '/setting':
            return MaterialPageRoute(builder: (_) => Setting());
        }
      },
    );
  }
}
