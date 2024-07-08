// ignore_for_file: library_private_types_in_public_api, use_super_parameters, prefer_const_constructors, use_build_context_synchronously

import 'package:flutter/material.dart';

import '../components/my_textfield.dart';
import '../services/auth/auth_service.dart';

class RegisterPage extends StatefulWidget {
  const RegisterPage({Key? key}) : super(key: key);

  @override
  _RegisterPageState createState() => _RegisterPageState();
}

class _RegisterPageState extends State<RegisterPage> {
  final AuthService _authService = AuthService();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Register'),
      ),
      body: Padding(
        padding: EdgeInsets.all(16.0),
        child: Column(
          children: [
            MyTextField(
              controller: _emailController,
              hintText: "Email",
              obscureText: false,
            ),
            const SizedBox(height: 10),
            MyTextField(
              controller: _passwordController,
              hintText: "Password",
              obscureText: true,
            ),
            const SizedBox(height: 10),
            ElevatedButton(
              onPressed: () async {
                String email = _emailController.text;
                String password = _passwordController.text;
                try {
                  await _authService.signUpWithEmailPassword(email, password);
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(content: Text('Registration successful')),
                  );
                  // Navigate to the next page or login
                } catch (e) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                        content: Text('Failed to register: ${e.toString()}')),
                  );
                }
              },
              child: Text('Register'),
            ),
          ],
        ),
      ),
    );
  }
}
