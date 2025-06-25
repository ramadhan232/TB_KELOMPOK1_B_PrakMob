import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controller/auth_author_controller.dart';

class MeAuthorScreen extends StatefulWidget {
  const MeAuthorScreen({super.key});

  @override
  State<MeAuthorScreen> createState() => _MeAuthorScreenState();
}

class _MeAuthorScreenState extends State<MeAuthorScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      if (!mounted) return;
      context.read<AuthAuthorController>().fetchMe();
    });
  }

  @override
  Widget build(BuildContext context) {
    final auth = context.watch<AuthAuthorController>();
    final user = auth.auth;
    return Scaffold(
      appBar: AppBar(title: const Text('Profil')),
      body:
          user == null
              ? const Center(child: CircularProgressIndicator())
              : Padding(
                padding: const EdgeInsets.all(16.0),
                child: Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('id: ${user.id}'),
                      Text('Nama: ${user.fullName}'),
                      Text('Email: ${user.email}'),
                      const SizedBox(height: 24),
                      ElevatedButton.icon(
                        onPressed: () {
                          auth.logout(context);
                        },
                        icon: const Icon(Icons.logout),
                        label: const Text('Logout'),
                        style: ElevatedButton.styleFrom(
                          backgroundColor: Colors.red,
                          foregroundColor: Colors.white,
                        ),
                      ),
                    ],
                  ),
                ),
              ),
    );
  }
}
