import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:go_router/go_router.dart';
import '../controller/auth_author_controller.dart';
import '../routes/route_names.dart';
import '../utils/helper.dart';

class LoginAuthorFormWidget extends StatefulWidget {
  const LoginAuthorFormWidget({super.key});

  @override
  State<LoginAuthorFormWidget> createState() => _LoginAuthorFormWidgetState();
}

class _LoginAuthorFormWidgetState extends State<LoginAuthorFormWidget> {
  final _emailCtrl = TextEditingController();
  final _passCtrl = TextEditingController();
  bool _isPassauthorVisible = false;

  @override
  void dispose() {
    _emailCtrl.dispose();
    _passCtrl.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final auth = Provider.of<AuthAuthorController>(context);

    return Padding(
      padding: const EdgeInsets.all(24.0),
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          TextField(
            controller: _emailCtrl,
            keyboardType: TextInputType.emailAddress,
            decoration: const InputDecoration(
              labelText: 'Email',
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
            controller: _passCtrl,
            obscureText: !_isPassauthorVisible,
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
                  _isPassauthorVisible
                      ? Icons.visibility
                      : Icons.visibility_off,
                ),
                onPressed:
                    () => setState(
                      () => _isPassauthorVisible = !_isPassauthorVisible,
                    ),
              ),
            ),
          ),
          const SizedBox(height: 20),
          if (auth.error != null)
            Padding(
              padding: const EdgeInsets.only(bottom: 12),
              child: Text(
                auth.error!,
                style: const TextStyle(color: Colors.red),
                textAlign: TextAlign.center,
              ),
            ),
          ElevatedButton(
            style: ButtonStyle(
              backgroundColor: WidgetStatePropertyAll<Color>(
                AppColors.frozenTeal,
              ),
              foregroundColor: const WidgetStatePropertyAll<Color>(
                Colors.white,
              ),
            ),
            onPressed:
                auth.isLoading
                    ? null
                    : () async {
                      await auth.login(_emailCtrl.text, _passCtrl.text);

                      if (auth.auth != null && context.mounted) {
                        context.goNamed('mainAuthor');
                      }
                    },
            child:
                auth.isLoading
                    ? const SizedBox(
                      height: 20,
                      width: 20,
                      child: CircularProgressIndicator(strokeWidth: 2),
                    )
                    : const Text('Login'),
          ),
          const SizedBox(height: 24),
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
                onPressed: () => context.goNamed(RouteNames.login),
                child: const Text("User"),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
