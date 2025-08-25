import 'package:flutter/material.dart';
import 'package:taskmanagement/screens/login_screen.dart';

import '../services/api_service.dart';

class RegisterScreen extends StatefulWidget {
  @override
  _RegisterScreenState createState() => _RegisterScreenState();
}

class _RegisterScreenState extends State<RegisterScreen> {
  final _emailController = TextEditingController();
  final _passwordController = TextEditingController();
  bool _loading = false;

  void _signup() async {
    setState(() => _loading = true);
    final success = await ApiService.signup(
      _emailController.text,
      _passwordController.text,
    );
    setState(() => _loading = false);

    print("success object : $success");

    ScaffoldMessenger.of(context).showSnackBar(
      SnackBar(content: Text(success ? "Signup Successful!" : "Signup Failed")),
    );
    if (success) {
      Navigator.push(context, MaterialPageRoute(builder: (_) => LoginScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: Text("Signup")),
      body: Padding(
        padding: const EdgeInsets.all(16),
        child: Column(
          children: [
            TextField(
              controller: _emailController,
              decoration: InputDecoration(labelText: "Email"),
            ),
            TextField(
              controller: _passwordController,
              decoration: InputDecoration(labelText: "Password"),
              obscureText: true,
            ),
            SizedBox(height: 20),
            _loading
                ? CircularProgressIndicator()
                : ElevatedButton(onPressed: _signup, child: Text("Signup")),
          ],
        ),
      ),
    );
  }
}
