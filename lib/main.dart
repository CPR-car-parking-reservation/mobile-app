import 'package:car_parking_reservation/Bloc/reserved/reserved_bloc.dart';
import 'package:car_parking_reservation/bloc/navigator/navigator_bloc.dart';
import 'package:car_parking_reservation/bloc/setting/setting_bloc.dart'; // Import SettingBloc
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
  runApp(const MyApp());
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MultiBlocProvider(
      providers: [
        BlocProvider<NavigatorBloc>(
          create: (context) => NavigatorBloc(),
        ),
        BlocProvider<ReservedBloc>(
          create: (context) => ReservedBloc(),
        ),
        BlocProvider<SettingBloc>( // Add SettingBloc here
          create: (context) => SettingBloc(),
        ),
      ],
      child: MaterialApp(
        debugShowCheckedModeBanner: false,
        title: 'CPR Application',
        theme: ThemeData(
          colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
          useMaterial3: true,
        ),
        home: const CprHomePage(),
      ),
    );
  }
}

class CprHomePage extends StatelessWidget {
  const CprHomePage({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
        useMaterial3: true,
      ),
      initialRoute: '/',
      routes: {
        '/': (context) => Welcome(),
        '/signin': (context) => Signin(),
        '/signup': (context) => Signup(),
        '/home': (context) => Home(),
        '/reserv': (context) => Reserv(),
        '/history': (context) => History(),
        '/setting': (context) => Setting(),
      },
    );
  }
}
