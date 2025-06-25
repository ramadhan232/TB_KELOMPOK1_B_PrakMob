import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:tb_kelompok1_b/controller/auth_controller.dart';
import 'package:tb_kelompok1_b/routes/route_names.dart';
import '../utils/helper.dart';

class RegisterFormWidget extends StatefulWidget {
  const RegisterFormWidget({super.key});

  @override
  State<RegisterFormWidget> createState() => _RegisterFormWidgetState();
}

class _RegisterFormWidgetState extends State<RegisterFormWidget> {
  final _usernameController = TextEditingController();
  final _passwordController = TextEditingController();
  final _formKey = GlobalKey<FormState>();
  final _authController = AuthController();
  bool _isPasswordVisible = false;

  Future<void> _register() async {
    final username = _usernameController.text.trim();
    final password = _passwordController.text;

    if (!_formKey.currentState!.validate()) return;

    final result = await _authController.register(username, password);

    if (!mounted) return;

    if (result == null) {
      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Pendaftaran berhasil!')));
      context.goNamed(RouteNames.login);
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
      child: Form(
        key: _formKey,
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            TextFormField(
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
              validator:
                  (value) => value!.isEmpty ? 'Username wajib diisi' : null,
            ),
            const SizedBox(height: 12),
            TextFormField(
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
                    _isPasswordVisible
                        ? Icons.visibility
                        : Icons.visibility_off,
                  ),
                  onPressed:
                      () => setState(
                        () => _isPasswordVisible = !_isPasswordVisible,
                      ),
                ),
              ),
              validator:
                  (value) =>
                      value!.length < 6 ? 'Password minimal 6 karakter' : null,
            ),
            const SizedBox(height: 24),
            ElevatedButton(
              onPressed: _register,
              style: ButtonStyle(
                backgroundColor: WidgetStatePropertyAll<Color>(
                  AppColors.frozenTeal,
                ),
                foregroundColor: const WidgetStatePropertyAll<Color>(
                  Colors.white,
                ),
              ),
              child: const Text('Daftar'),
            ),
            TextButton(
              onPressed: () => context.goNamed(RouteNames.login),
              child: const Text("Sudah punya akun? Login"),
            ),
          ],
        ),
      ),
    );
  }
}
