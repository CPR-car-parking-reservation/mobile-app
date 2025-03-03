import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';
import 'package:shared_preferences/shared_preferences.dart';

class GenQR extends StatefulWidget {
  const GenQR({super.key});

  @override
  State<GenQR> createState() => _GenQRState();
}

class _GenQRState extends State<GenQR> {
  String userToken = "";

  @override
  void initState() {
    super.initState();
    _loadToken();
  }

  // ดึง token จาก SharedPreferences
  void _loadToken() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    setState(() {
      userToken = prefs.getString('token') ?? ''; // ถ้าไม่มี token จะใช้ค่าว่าง
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: const Color(0xFF03174C),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            const Text(
              "Scan QR Code",
              style: TextStyle(
                  color: Colors.white,
                  fontSize: 28,
                  fontFamily: "Amiko",
                  fontWeight: FontWeight.w700),
            ),
            userToken.isNotEmpty
                ? QrImageView(
                    data: userToken,
                    version: QrVersions.auto,
                    size: 200.0,
                    backgroundColor: Colors.white,
                  )
                : CircularProgressIndicator(),
            Text(userToken, style: TextStyle(color: Colors.white)),
          ],
        ),
      ),
    );
  }
}
