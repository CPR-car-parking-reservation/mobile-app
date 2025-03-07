import 'package:flutter/material.dart';

const String fontFamily = "amiko";
Widget buildTextField(
    String label, IconData icon, TextEditingController controller) {
  return Padding(
    padding: const EdgeInsets.symmetric(vertical: 8.0),
    child: TextField(
      controller: controller,
      decoration: InputDecoration(
        prefixIcon: Icon(icon, color: Colors.black),
        filled: true,
        fillColor: Colors.white,
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(12)),
        labelText: label,
        labelStyle: const TextStyle(
            color: Colors.black, fontSize: 16, fontFamily: fontFamily),
        floatingLabelBehavior: FloatingLabelBehavior.never,
      ),
      style: const TextStyle(color: Colors.black, fontFamily: fontFamily),
    ),
  );
}

class DropdownFieldWidget extends StatefulWidget {
  const DropdownFieldWidget({super.key});

  @override
  _DropdownFieldWidgetState createState() => _DropdownFieldWidgetState();
}

class _DropdownFieldWidgetState extends State<DropdownFieldWidget> {
  String selectedType = 'Fuels';

  @override
  Widget build(BuildContext context) {
    return buildDropdownField();
  }

  Widget buildDropdownField() {
    String selectedType = 'Fuels';

    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 8.0),
      child: DropdownButtonFormField<String>(
        value: selectedType,
        decoration: InputDecoration(
          prefixIcon: Icon(Icons.category, color: Colors.black),
          filled: true,
          fillColor: Colors.white,
          border: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.black, width: 1),
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(12),
            borderSide: BorderSide(color: Colors.blue, width: 2),
          ),
          labelStyle: const TextStyle(
              color: Colors.black, fontSize: 16, fontFamily: fontFamily),
          floatingLabelBehavior: FloatingLabelBehavior.never,
        ),
        items: ['Fuels', 'Electric'].map((String value) {
          return DropdownMenuItem<String>(
            value: value,
            child: Text(
              value,
              style: const TextStyle(
                color: Colors.black,
                fontFamily: fontFamily,
              ),
            ),
          );
        }).toList(),
        onChanged: (newValue) {
          setState(() {
            selectedType = newValue!;
          });
        },
        style: const TextStyle(color: Colors.black, fontFamily: fontFamily),
        dropdownColor: Colors.white,
        icon: const Icon(Icons.arrow_drop_down, color: Colors.black),
        iconSize: 24,
      ),
    );
  }
}
