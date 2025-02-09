import 'package:cpr_application/Login/signup.dart';
import 'package:cpr_application/home.dart';
import 'package:flutter/material.dart';

class Signin extends StatefulWidget {
  const Signin({super.key});

  @override
  State<Signin> createState() => _SigninState();
}

class _SigninState extends State<Signin> {
  // final userController = TextEditingController();
  // final passController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(''),
      ),
      body: Center(
        child: Padding(
          padding: EdgeInsets.all(15),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                height: 250,
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
                            "Welcome Back!",
                            style: TextStyle(
                                fontSize: 28,
                                fontFamily: "Amiko",
                                fontWeight: FontWeight.w700),
                          ),
                        ),
                      ],
                    ),
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.white, elevation: 3),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => Home()),
                        );
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 10, horizontal: 30),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Image.asset(
                              "assets/images/logogoogle.png",
                              height: 35,
                            ),
                            Text(
                              "CONTINUE WITH GOOGLE",
                              style: TextStyle(
                                  color: Colors.black54,
                                  fontFamily: "Amiko",
                                  fontWeight: FontWeight.w700,
                                  fontSize: 15),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Text(
                      "OR LOG IN WITH EMAIL",
                      style: TextStyle(
                          fontSize: 14,
                          fontFamily: "Amiko",
                          fontWeight: FontWeight.w700,
                          color: Colors.grey),
                    ),
                  ],
                ),
              ),
              SizedBox(
                height: 25,
              ),
              Container(
                height: 400,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    TextField(
                      // controller: userController,
                      decoration: InputDecoration(
                        filled: true,
                        fillColor: Colors.grey[100],
                        label: Text(
                          "Email or Username",
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
                    TextField(
                      // controller: passController,
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
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFEF4637),
                          elevation: 3),
                      onPressed: () {
                        //if (userController.text.isEmpty ||
                        //    passController.text.isEmpty) {
                        //  ScaffoldMessenger.of(context).showSnackBar(
                        //    SnackBar(
                        //      content: Text(
                        //        "Fail",
                        //        style: TextStyle(
                        //            color: Colors.white,
                        //            fontWeight: FontWeight.bold),
                        //      ),
                        //      backgroundColor:
                        //          const Color(0xFFEF4637),
                        //    ),
                        //  );
                        //} else {
                        //  ScaffoldMessenger.of(context).showSnackBar(
                        //    SnackBar(
                        //      content: Text(
                        //        "Success",
                        //        style: TextStyle(
                        //            color: Colors.black,
                        //            fontWeight: FontWeight.bold),
                        //      ),
                        //      backgroundColor: const Color(0xFF29CE79),
                        //    ),
                        //  );
                         Navigator.push(
                           context,
                           MaterialPageRoute(builder: (context) => Home()),
                         );
                        //}
                      },
                      child: Padding(
                        padding: const EdgeInsets.symmetric(
                            vertical: 15, horizontal: 135),
                        child: Text(
                          "LOG IN",
                          style: TextStyle(
                              color: Colors.white,
                              fontFamily: "Amiko",
                              fontWeight: FontWeight.w700,
                              fontSize: 16),
                        ),
                      ),
                    ),
                  ],
                ),
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
    );
  }
}
