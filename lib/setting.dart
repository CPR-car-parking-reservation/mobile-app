import 'package:flutter/material.dart';

class Setting extends StatefulWidget {
  const Setting({super.key});

  @override
  State<Setting> createState() => _SettingState();
}

class _SettingState extends State<Setting> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        automaticallyImplyLeading: false,
        title: Row(
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            Container()
          ],
        ),
      ),
      body: Center(
        child: Padding(padding: EdgeInsets.all(15),
        child: Column(
          children: [
            Text("Home"),
            Divider(height: 50,)
          ],
        ),
        ),
      ),
    );
  }
}
