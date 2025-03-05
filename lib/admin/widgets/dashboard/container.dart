import 'package:flutter/material.dart';

class CustomContainer extends StatelessWidget {
  final Color color;
  final IconData icon;
  final String title;
  final String value;
  final Widget? child;

  const CustomContainer({
    super.key,
    this.color = Colors.blue,
    this.child,
    required this.icon,
    required this.title,
    required this.value,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(vertical: 5),
      child: Container(
        width: 150,
        height: 100,
        decoration: BoxDecoration(
          // ignore: deprecated_member_use
          color: color,
          borderRadius: BorderRadius.circular(20),
        ),
        child: Padding(
          padding: const EdgeInsets.only(left: 10, right: 10, top: 15),
          child: Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                  Icon(icon, size: 30, color: Colors.white),
                  Padding(
                    padding: const EdgeInsets.only(left: 3),
                    child: Text(
                      title,
                      style: TextStyle(
                          fontFamily: "Amiko",
                          fontSize: 14,
                          fontWeight: FontWeight.w700,
                          color: Colors.white),
                    ),
                  ),
                ],
              ),
              Text(
                value,
                style: TextStyle(
                    fontFamily: "Amiko",
                    fontSize: 28,
                    fontWeight: FontWeight.w700,
                    color: Colors.white),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
