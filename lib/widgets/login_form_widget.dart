import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tb_kelompok1_b/utils/helper.dart';
import '../controller/auth_controller.dart';
import '../routes/route_names.dart';

class LoginFormWidget extends StatefulWidget {
  const LoginFormWidget({super.key});

  @override
  State<LoginFormWidget> createState() => _LoginFormWidgetState();
}

class _LoginFormWidgetState extends State<LoginFormWidget> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _auth = AuthController();
  bool _isPasswordVisible = false;

  Future<void> _login() async {
    final username = _usernameController.text.trim();
    final password = _passwordController.text;

    final result = await _auth.login(username, password);

    if (!mounted) return; //

    if (result == null) {
      context.goNamed(RouteNames.main);
    } else {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(result)));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(
            controller: _usernameController,
            decoration: const InputDecoration(
              labelText: 'Username',
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black, width: 2),
              ),
            ),
          ),
          const SizedBox(height: 12),
          TextField(
            controller: _passwordController,
            obscureText: !_isPasswordVisible,
            decoration: InputDecoration(
              labelText: 'Password',
              enabledBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black),
              ),
              focusedBorder: OutlineInputBorder(
                borderSide: BorderSide(color: Colors.black, width: 2),
              ),
              suffixIcon: IconButton(
                icon: Icon(
                  _isPasswordVisible ? Icons.visibility : Icons.visibility_off,
                ),
                onPressed:
                    () => setState(
                      () => _isPasswordVisible = !_isPasswordVisible,
                    ),
              ),
            ),
          ),
          const SizedBox(height: 24),
          ElevatedButton(
            onPressed: _login,
            style: ButtonStyle(
              backgroundColor: WidgetStatePropertyAll<Color>(
                AppColors.frozenTeal,
              ),
              foregroundColor: const WidgetStatePropertyAll<Color>(
                Colors.white,
              ),
            ),
            child: const Text('Login'),
          ),
          const SizedBox(height: 24),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Don’t have account?"),
              const SizedBox(width: 5),
              TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: Colors.blue,
                  padding: EdgeInsets.zero, // Menghilangkan padding
                  minimumSize: Size.zero, // Menghilangkan ukuran minimum
                  tapTargetSize:
                      MaterialTapTargetSize
                          .shrinkWrap, // Menyesuaikan area tap ke konten
                ),
                onPressed: () => context.goNamed(RouteNames.register),
                child: const Text("Register"),
              ),
            ],
          ),
          const SizedBox(height: 10),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Text("Login as"),
              const SizedBox(width: 5),
              TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: Colors.blue,
                  padding: EdgeInsets.zero, // Menghilangkan padding
                  minimumSize: Size.zero, // Menghilangkan ukuran minimum
                  tapTargetSize:
                      MaterialTapTargetSize
                          .shrinkWrap, // Menyesuaikan area tap ke konten
                ),
                onPressed: () => context.goNamed(RouteNames.loginAuthor),
                child: const Text("Author"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
