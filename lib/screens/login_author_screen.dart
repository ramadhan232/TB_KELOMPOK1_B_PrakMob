// lib/pages/login_page.dart
import 'package:flutter/material.dart';
import '../widgets/login_author_form_widget.dart';

class LoginAuthorScreen extends StatelessWidget {
  const LoginAuthorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: SafeArea(
        child: Center(
          child: SingleChildScrollView(
            child: Column(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                Image.asset('assets/images/logo1.png', height: 100),
                const SizedBox(height: 10),
                const Text(
                  'Author',
                  textAlign: TextAlign.center,
                  style: TextStyle(fontSize: 24, color: Colors.black),
                ),
                const LoginAuthorFormWidget(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
