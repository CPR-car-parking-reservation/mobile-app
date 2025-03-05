import 'package:flutter/material.dart';

class TopicDashboard extends StatelessWidget {
  final String title;

  const TopicDashboard({
    super.key,
    required this.title,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.start,
        children: [
          Text(
            title,
            style: TextStyle(
                fontFamily: "Amiko",
                fontSize: 20,
                fontWeight: FontWeight.w700,
                color: Colors.black),
          ),
          Padding(
            padding: const EdgeInsets.only(left: 5),
            child: Row(
              children: [
                Icon(
                  Icons.radio_button_on_outlined,
                  color: Colors.green,
                ),
                Text(
                  "NOW",
                  style: TextStyle(
                      fontFamily: "Amiko",
                      fontSize: 12,
                      fontWeight: FontWeight.w700,
                      color: Colors.green),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
