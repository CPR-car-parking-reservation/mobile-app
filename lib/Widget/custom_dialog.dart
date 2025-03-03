import 'package:flutter/material.dart';

void showCustomDialogSucess(BuildContext context, String message) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Column(
          children: [
            Icon(
              Icons.check_circle,
              color: Colors.green,
              size: 50,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 10,
              ),
              child: Center(
                child: Text(
                  message,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: "Amiko",
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: const Color.fromARGB(255, 0, 0, 0)),
                ),
              ),
            ),
          ],
        ),
        actions: [
          Center(
              child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.green,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Text("OK",
                  style: TextStyle(
                      fontFamily: "Amiko",
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.white)),
            ),
          ))
        ],
      );
    },
  );
}

void showCustomDialogWarning(BuildContext context, String message) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Column(
          children: [
            Icon(
              Icons.warning_rounded,
              color: Colors.amber,
              size: 50,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 10,
              ),
              child: Center(
                child: Text(
                  message,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: "Amiko",
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: const Color.fromARGB(255, 0, 0, 0)),
                ),
              ),
            ),
          ],
        ),
        actions: [
          Center(
              child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.amber,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Text("OK",
                  style: TextStyle(
                      fontFamily: "Amiko",
                      fontSize: 16,
                      fontWeight: FontWeight.w700,
                      color: Colors.white)),
            ),
          ))
        ],
      );
    },
  );
}

void showCustomDialogError(BuildContext context, String message) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return AlertDialog(
        title: Column(
          children: [
            Icon(
              Icons.error_rounded,
              color: Colors.red,
              size: 50,
            ),
            Padding(
              padding: const EdgeInsets.symmetric(
                vertical: 10,
              ),
              child: Center(
                child: Text(
                  message,
                  textAlign: TextAlign.center,
                  style: TextStyle(
                      fontFamily: "Amiko",
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: const Color.fromARGB(255, 0, 0, 0)),
                ),
              ),
            ),
          ],
        ),
        actions: [
          Center(
              child: ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.red,
            ),
            onPressed: () {
              Navigator.of(context).pop();
            },
            child: Padding(
              padding: const EdgeInsets.symmetric(vertical: 10),
              child: Text("OK",
                  style: TextStyle(
                      fontFamily: "Amiko",
                      fontSize: 17,
                      fontWeight: FontWeight.bold,
                      color: const Color.fromARGB(255, 0, 0, 0)),
                ),
              ),
            ),
          ],
        ),
      );
    },
  );
}
