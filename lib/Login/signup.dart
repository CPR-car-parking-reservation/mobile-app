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
  final newsurnameController = TextEditingController();
  final newphoneController = TextEditingController();
  final newemailController = TextEditingController();
  final newpassController = TextEditingController();
  final newconfirmpassController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return BlocListener<RegisterBloc, RegisterState>(
      listener: (context, state) {
        if (state is RegisterSuccess) {
          Navigator.pushAndRemoveUntil(
              context,
              MaterialPageRoute(builder: (context) => Signin()),
              (route) => false);
          showCustomDialog(context, state.message);
        } else if (state is RegisterError) {
          showCustomDialogError(context, state.message);
        }
      },
      child: Scaffold(
        resizeToAvoidBottomInset: false,
        appBar: AppBar(title: Text('')),
        body: SingleChildScrollView(
          padding: EdgeInsets.all(20),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Center(
                child: Text(
                  "Create Your Account",
                  style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                ),
              ),
              SizedBox(height: 20),
              Row(
                children: [
                  Expanded(
                    child: TextField(
                      controller: newuserController,
                      decoration: _inputDecoration("Name", Icons.person),
                    ),
                  ),
                  SizedBox(width: 10),
                  Expanded(
                    child: TextField(
                      controller: newsurnameController,
                      decoration: _inputDecoration("Surname", Icons.person),
                    ),
                  ),
                ],
              ),
              SizedBox(height: 15),
              TextField(
                controller: newphoneController,
                keyboardType: TextInputType.number,
                maxLength: 10,
                decoration: _inputDecoration("Telephone", Icons.phone),
              ),
              SizedBox(height: 5),
              TextField(
                controller: newemailController,
                keyboardType: TextInputType.emailAddress,
                decoration: _inputDecoration("Email Address", Icons.email),
                
              ),
              SizedBox(height: 15),
              TextField(
                controller: newpassController,
                obscureText: true,
                decoration: _inputDecoration("Password", Icons.lock),
              ),
              SizedBox(height: 15),
              TextField(
                controller: newconfirmpassController,
                obscureText: true,
                decoration: _inputDecoration("Confirm Password", Icons.lock),
              ),
              SizedBox(height: 30),
              Center(
                child: ElevatedButton(
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.redAccent,
                    padding: EdgeInsets.symmetric(vertical: 15, horizontal: 100),
                  ),
                  onPressed: () {
                    context.read<RegisterBloc>().add(
                      OnCreateRegister(
                        newuserController.text,
                        newsurnameController.text,
                        newemailController.text,
                        newpassController.text,
                        newconfirmpassController.text,
                        newphoneController.text,
                      ),
                    );
                  },
                  child: Text(
                    "GET STARTED",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 16,
                    ),
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }

  InputDecoration _inputDecoration(String label, IconData icon) {
    return InputDecoration(
      filled: true,
      fillColor: Colors.grey[100],
      labelText: label,
      prefixIcon: Icon(icon, color: Colors.black45),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(10),
        borderSide: BorderSide.none,
      ),
    );
  }
}
