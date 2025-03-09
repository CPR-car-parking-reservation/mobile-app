import 'dart:developer';

import 'package:car_parking_reservation/Bloc/login/login_bloc.dart';
import 'package:car_parking_reservation/Login/signup.dart';
import 'package:car_parking_reservation/Widget/custom_dialog.dart';
import 'package:car_parking_reservation/Widget/home.dart';
import 'package:car_parking_reservation/admin/admin_home.dart';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:shared_preferences/shared_preferences.dart';

class Signin extends StatefulWidget {
  const Signin({super.key});

  @override
  State<Signin> createState() => _SigninState();
}

class _SigninState extends State<Signin> {
  final emailController = TextEditingController();
  final passController = TextEditingController();

  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => LoginBloc()..add(onPageLoad()),
      child: Scaffold(
        appBar: AppBar(
          title: Text(''),
        ),
        body: Center(
          child: Padding(
            padding: EdgeInsets.all(15),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                SizedBox(
                  height: 50,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          Icon(
                            Icons.waving_hand_rounded,
                            size: 32,
                            color: Colors.amber,
                          ),
                          Padding(
                            padding: const EdgeInsets.only(left: 20, top: 5),
                            child: Text(
                              "Welcome !",
                              style: TextStyle(
                                  fontSize: 28,
                                  fontFamily: "Amiko",
                                  fontWeight: FontWeight.w700),
                            ),
                          ),
                        ],
                      ),
                    ],
                  ),
                ),
                Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    Image.asset(
                      "assets/images/LogoCARPAKING.png",
                      height: 150,
                      width: 400,
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    TextFormField(
                      controller: emailController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey[100],
                        label: Text(
                          "Email",
                          style: TextStyle(
                              fontFamily: "Amiko", color: Colors.black45),
                        ),
                        prefixIcon: Icon(Icons.account_circle_rounded),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide.none),
                      ),
                    ),
                    SizedBox(
                      height: 25,
                    ),
                    TextFormField(
                      controller: passController,
                      obscureText: true,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey[100],
                        label: Text(
                          "Password",
                          style: TextStyle(
                              fontFamily: "Amiko", color: Colors.black45),
                        ),
                        prefixIcon: Icon(Icons.lock_rounded),
                        border: OutlineInputBorder(
                            borderRadius: BorderRadius.circular(15),
                            borderSide: BorderSide.none),
                      ),
                    ),
                    SizedBox(
                      height: 40,
                    ),
                    BlocListener<LoginBloc, LoginState>(
                      listener: (context, state) {
                        if (state is LoginError) {
                          showCustomDialogError(context, state.message);
                        }
                        if (state is LoginSuccess) {
                          if (state.role == "ADMIN") {
                            Future.delayed(Duration.zero, () {
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(
                                    builder: (context) => AdminHomePage()),
                                (route) => false,
                              );
                            });
                          } else {
                            Future.delayed(Duration.zero, () {
                              Navigator.pushAndRemoveUntil(
                                context,
                                MaterialPageRoute(builder: (context) => Home()),
                                (route) => false,
                              );
                            });
                          }
                        }
                      },
                      child: BlocBuilder<LoginBloc, LoginState>(
                        builder: (context, state) {
                          log(state.toString());
                          if (state is LoginLoading) {
                            return ElevatedButton(
                              style: ElevatedButton.styleFrom(
                                  backgroundColor: const Color(0xFFEF4637),
                                  elevation: 3),
                              onPressed: () {
                                context.read<LoginBloc>().add(onSubmit(
                                    emailController.text, passController.text));
                              },
                              child: Padding(
                                padding: const EdgeInsets.symmetric(
                                    vertical: 10, horizontal: 110),
                                child: CircularProgressIndicator(
                                  backgroundColor: const Color(0xFFEF4637),
                                  strokeWidth: 3,
                                  valueColor: AlwaysStoppedAnimation<Color>(
                                      Colors.white),
                                ),
                              ),
                            );
                          }

                          return ElevatedButton(
                            style: ElevatedButton.styleFrom(
                                backgroundColor: const Color(0xFFEF4637),
                                elevation: 3),
                            onPressed: () {
                              context.read<LoginBloc>().add(onSubmit(
                                  emailController.text, passController.text));
                            },
                            child: Padding(
                              padding: const EdgeInsets.symmetric(
                                  vertical: 15, horizontal: 100),
                              child: Text(
                                "LOG IN",
                                style: TextStyle(
                                    color: Colors.white,
                                    fontFamily: "Amiko",
                                    fontWeight: FontWeight.w700,
                                    fontSize: 16),
                              ),
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text("ALREADY HAVE AN ACCOUNT?"),
                    TextButton(
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                            builder: (context) => Signup(),
                          ),
                        );
                      },
                      child: Text(
                        "SIGN UP",
                        style: TextStyle(
                          color: const Color(0xFFEF4637),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
