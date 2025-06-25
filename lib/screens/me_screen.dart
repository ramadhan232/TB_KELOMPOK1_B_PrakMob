import 'dart:io';
import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:image_picker/image_picker.dart';
import 'package:tb_kelompok1_b/controller/auth_controller.dart';
import 'package:tb_kelompok1_b/utils/helper.dart';

class MeScreen extends StatefulWidget {
  const MeScreen({super.key});

  @override
  State<MeScreen> createState() => _MeScreenState();
}

class _MeScreenState extends State<MeScreen> {
  final auth = AuthController();
  File? _imageFile;
  String? _username;

  @override
  void initState() {
    super.initState();
    _loadUserAndImage();
  }

  Future<void> _loadUserAndImage() async {
    final user = await auth.getCurrentUser();
    if (user != null) {
      final imagePath = await auth.loadProfileImagePath(user.username);
      setState(() {
        _username = user.username;
        if (imagePath != null) _imageFile = File(imagePath);
      });
    }
  }

  Future<void> _pickImage() async {
    final user = await auth.getCurrentUser();
    if (user == null) return;

    final pickedFile = await ImagePicker().pickImage(
      source: ImageSource.gallery,
    );
    if (pickedFile != null) {
      final path = pickedFile.path;
      await auth.saveProfileImagePath(user.username, path);
      setState(() {
        _imageFile = File(path);
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.frostWhite,
      body: Padding(
        padding: const EdgeInsets.symmetric(vertical: 32.0, horizontal: 24),
        child: Center(
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              GestureDetector(
                onTap: _pickImage,
                child: CircleAvatar(
                  radius: 70,
                  backgroundImage:
                      _imageFile != null
                          ? FileImage(_imageFile!)
                          : const AssetImage('assets/images/profile.jpg')
                              as ImageProvider,
                ),
              ),
              const SizedBox(height: 16),
              Text(
                _username ?? 'USERNAME',
                style: GoogleFonts.roboto(
                  fontSize: 20,
                  fontWeight: FontWeight.bold,
                ),
              ),
              ElevatedButton(
                onPressed: () async => await auth.logout(context),
                style: ElevatedButton.styleFrom(
                  backgroundColor: Colors.red,
                  padding: const EdgeInsets.symmetric(
                    horizontal: 32,
                    vertical: 12,
                  ),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(24),
                  ),
                ),
                child: const Text(
                  'LOGOUT',
                  style: TextStyle(color: Colors.white),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
