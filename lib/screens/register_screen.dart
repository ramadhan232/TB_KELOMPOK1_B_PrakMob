import 'package:flutter/material.dart';
import '../widgets/register_form_widget.dart';

class RegisterScreen extends StatelessWidget {
  const RegisterScreen({super.key});

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
                const SizedBox(height: 40),
                const RegisterFormWidget(),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
