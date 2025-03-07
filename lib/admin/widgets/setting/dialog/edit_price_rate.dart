import 'dart:developer';

import 'package:flutter/material.dart';

void edit_price_rate(BuildContext context, String currentPrice) {
  TextEditingController priceController =
      TextEditingController(text: currentPrice);

  showDialog(
    context: context,
    builder: (context) {
      return AlertDialog(
        backgroundColor: Colors.white,
        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(15)),
        title: Text(
          "Edit Price Rate",
          style: TextStyle(
              fontSize: 22,
              fontWeight: FontWeight.bold,
              fontFamily: 'Amiko',
              color: Colors.black),
        ),
        content: TextField(
          controller: priceController,
          keyboardType: TextInputType.number,
          decoration: InputDecoration(
            labelText: "Price per Hour (฿)",
            border: OutlineInputBorder(borderRadius: BorderRadius.circular(10)),
          ),
        ),
        actions: [
          ElevatedButton(
            onPressed: () {
              String newPrice = priceController.text;
              log("New Price: $newPrice");
              Navigator.pop(context, newPrice); // ปิด Dialog และส่งค่ากลับ
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              elevation: 5,
            ),
            child: Text("Save",
                style: TextStyle(color: Colors.white, fontFamily: 'Amiko', fontWeight: FontWeight.bold)),
          ),
          TextButton(
            onPressed: () {
              Navigator.pop(context); // ปิด Dialog
            },
            style: ElevatedButton.styleFrom(
              backgroundColor: const Color.fromARGB(255, 251, 251, 251),
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(12)),
              
            ),
            child: Text("Cancel",
                style: TextStyle(
                    color: Colors.black,
                    fontFamily: 'Amiko',
                    fontWeight: FontWeight.bold)),
          ),
        ],
      );
    },
  );
}
