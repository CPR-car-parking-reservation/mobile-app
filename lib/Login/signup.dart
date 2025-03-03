
import 'package:car_parking_reservation/Bloc/user/register/register_bloc.dart';
import 'package:car_parking_reservation/Login/signin.dart';
import 'package:car_parking_reservation/Widget/custom_dialog.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  final newuserController = TextEditingController();
  final newemailController = TextEditingController();
  final newpassController = TextEditingController();
  final newconfirmpassController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocProvider(
      create: (context) => RegisterBloc(),
      child: Scaffold(
        resizeToAvoidBottomInset: false,
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
                  height: 75,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        "Created your account",
                        style: TextStyle(
                            fontSize: 28,
                            fontFamily: "Amiko",
                            fontWeight: FontWeight.w700),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 30),
                SizedBox(
                  height: 270,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.start,
                    children: [
                      //newuser
                      TextField(
                        controller: newuserController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.grey[100],
                          label: Text(
                            "Username",
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
                        height: 15,
                      ),
                      TextField(
                        controller: newemailController,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.grey[100],
                          label: Text(
                            "Email Address",
                            style: TextStyle(
                                fontFamily: "Amiko", color: Colors.black45),
                          ),
                          prefixIcon: Icon(Icons.mail),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide.none),
                        ),
                      ),
                      SizedBox(
                        height: 15,
                      ),
                      TextField(
                        controller: newpassController,
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
                        height: 15,
                      ),
                      TextField(
                        controller: newconfirmpassController,
                        obscureText: true,
                        decoration: InputDecoration(
                          filled: true,
                          fillColor: Colors.grey[100],
                          label: Text(
                            "Confirm Password",
                            style: TextStyle(
                                fontFamily: "Amiko", color: Colors.black45),
                          ),
                          prefixIcon: Icon(Icons.check_box_rounded),
                          border: OutlineInputBorder(
                              borderRadius: BorderRadius.circular(15),
                              borderSide: BorderSide.none),
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(
                  height: 250,
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      ElevatedButton(
                        style: ElevatedButton.styleFrom(
                            backgroundColor: const Color(0xFFEF4637),
                            elevation: 3),
                        onPressed: () async {
                          context.read<RegisterBloc>().add(OnCreateRegister(
                              newuserController.text,
                              newemailController.text,
                              newpassController.text,
                              newconfirmpassController.text));
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                              builder: (context) => Signin(),
                            ),
                          );
                          final String message = "User Created";
                          showCustomDialog(context, message);
                        },
                        child: Padding(
                          padding: const EdgeInsets.symmetric(
                              vertical: 15, horizontal: 80),
                          child: Text(
                            "GET STARTED",
                            style: TextStyle(
                                color: Colors.white,
                                fontFamily: "Amiko",
                                fontWeight: FontWeight.w700,
                                fontSize: 14),
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
