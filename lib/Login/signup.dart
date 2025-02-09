import 'package:cpr_application/home.dart';
import 'package:flutter/material.dart';

class Signup extends StatefulWidget {
  const Signup({super.key});

  @override
  State<Signup> createState() => _SignupState();
}

class _SignupState extends State<Signup> {
  // final newuserController = TextEditingController();
  // final newemailController = TextEditingController();
  // final newpassController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
              Container(
                height: 250,
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
                height: 15,
              ),
              Container(
                height: 200,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.start,
                  children: [
                    TextField(
                      // controller: newuserController,
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
                      // controller: newemailController,
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
                      // controller: newpassController,
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
                  ],
                ),
              ),
              Container(
                height: 250,
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFEF4637),
                          elevation: 3),
                      onPressed: () {
                        //if (newuserController.text.isEmpty ||
                        //    newpassController.text.isEmpty || newemailController.text.isEmpty) {
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
                            vertical: 15, horizontal: 110),
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
    );
  }
}
