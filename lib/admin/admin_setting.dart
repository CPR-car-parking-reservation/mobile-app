import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AdminSettingPage extends StatefulWidget {
  const AdminSettingPage({super.key});

  @override
  State<AdminSettingPage> createState() => _AdminSettingPageState();
}

class _AdminSettingPageState extends State<AdminSettingPage> {
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.white),
        useMaterial3: true,
      ),
      debugShowCheckedModeBanner: false,
      home: const MyHomePage(),
    );
  }
}

class MyHomePage extends StatefulWidget {
  const MyHomePage({super.key});

  @override
  State<MyHomePage> createState() => _MyHomePageState();
}

class _MyHomePageState extends State<MyHomePage> {
  final usernameController = TextEditingController();
  final passwordController = TextEditingController();
  String username = '';
  String password = '';
  String? token;

  @override
  void initState() {
    super.initState();
    _loadDataUser();
  }

  Future<void> _loadDataUser() async {
    final prefs = await SharedPreferences.getInstance();
    token = prefs.getString('token');
    debugPrint('token: $token');
    setState(() {
      username = prefs.getString('username') ?? '';
      password = prefs.getString('password') ?? '';
    });
  }

  Future<void> _saveUserData() async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('username', usernameController.text);
    await prefs.setString('password', passwordController.text);
    await prefs.setString('token', 'Success');

    _loadDataUser(); // โหลดข้อมูลใหม่
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: <Widget>[
            TextField(
              controller: usernameController,
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Enter your username',
              ),
            ),
            const SizedBox(height: 10),
            TextField(
              controller: passwordController,
              obscureText: true, // ซ่อนรหัสผ่าน
              decoration: const InputDecoration(
                border: OutlineInputBorder(),
                labelText: 'Enter your password',
              ),
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () {
                _saveUserData();
              },
              child: const Text("Send"),
            ),
            const SizedBox(height: 20),
            Text('Username: $username'),
            Text('Password: $password'),
            Text("Token: $token"), // ✅ แก้ไขข้อความ token
          ],
        ),
      ),
    );
  }
}
