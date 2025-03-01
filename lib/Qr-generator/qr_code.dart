import 'package:flutter/material.dart';
import 'package:qr_flutter/qr_flutter.dart';

class GenQR extends StatefulWidget {
  const GenQR({super.key});

  @override
  State<GenQR> createState() => _GenQRState();
}

class _GenQRState extends State<GenQR> {
  String dataQr = "https://www.youtube.com/@purmpoon";

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
            QrImageView(
              data: dataQr,
              version: QrVersions.auto,
              size: 200.0,
              backgroundColor: Colors.white,
            ),
          ],
        ),
      ),
    );
  }
}
