
import 'package:cpr_application/Login/signin.dart';
import 'package:cpr_application/Login/signup.dart';
import 'package:flutter/material.dart';

class Welcome extends StatelessWidget {
  const Welcome({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 100,horizontal: 10),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Image.asset("assets/images/LogoCARPAKING.png" , height: 300, width: 300,),
              //Stack(
              //  alignment: AlignmentDirectional.bottomStart,
              //  children: [
              //    Container(
              //      height: 100,
              //      width: 300,
              //      color: Colors.green,
              //    ),
              //  
              //    Container(
              //      height: 100,
              //      width: 270,
              //      color: Colors.amber,
              //    )
              //  ],
              //),
              Container(
                child: Column(
                  children: [
                    ElevatedButton(
                      style: ElevatedButton.styleFrom(
                          backgroundColor: const Color(0xFFEF4637), elevation: 7),
                      onPressed: () {
                        Navigator.push(context,
                            MaterialPageRoute(builder: (context) => Signin()));
                      },
                      child: Padding(
                        padding:
                            const EdgeInsets.symmetric(vertical: 15, horizontal: 120),
                        child: Text("LOG IN",
                            style: TextStyle(color: Colors.white, fontSize: 16)),
                      ),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Text("ALERDY HAVE AN ACCOUNT?"),
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
                            style: TextStyle(color: const Color(0xFFEF4637)),
                          ),
                        ),
                      ],
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
