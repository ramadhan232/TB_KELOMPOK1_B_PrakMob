import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:crypto/crypto.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_database/firebase_database.dart';
import 'package:intl/intl.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/user_model.dart';
import 'package:go_router/go_router.dart';
import '../routes/route_names.dart';

class AuthController {
  final db =
      FirebaseDatabase.instanceFor(
        app: Firebase.app(),
        databaseURL:
            'https://frostnews-ed366-default-rtdb.asia-southeast1.firebasedatabase.app/',
      ).ref();

  String hashPassword(String password) {
    return sha256.convert(utf8.encode(password)).toString();
  }

  Future<String?> register(String username, String password) async {
    try {
      final snapshot = await db.child('users/$username').get();
      if (snapshot.exists) return 'Username sudah digunakan';

      final hashedPassword = hashPassword(password);
      final createdAt = DateFormat(
        'yyyy-MM-dd HH:mm:ss',
      ).format(DateTime.now());

      final user = UserModel(
        username: username,
        password: hashedPassword,
        createdAt: createdAt,
      );

      await db.child('users/$username').set(user.toMap());

      return null;
    } catch (e) {
      return 'Terjadi kesalahan saat registrasi: ${e.toString()}';
    }
  }

  Future<String?> login(String username, String password) async {
    try {
      final snapshot = await db.child('users/$username').get();
      if (!snapshot.exists) return 'Username tidak ditemukan';

      final user = UserModel.fromMap(username, snapshot.value as Map);
      final inputHash = hashPassword(password);

      if (inputHash != user.password) return 'Password salah';

      final prefs = await SharedPreferences.getInstance();
      await prefs.setString('loggedInUser', username);
      return null;
    } catch (e) {
      return 'Gagal login: ${e.toString()}';
    }
  }

  Future<void> logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('loggedInUser');

    // Navigasi ke halaman login (dengan GoRouter)
    if (context.mounted) {
      context.goNamed(RouteNames.login);
    }
  }

  Future<UserModel?> getCurrentUser() async {
    final prefs = await SharedPreferences.getInstance();
    final username = prefs.getString('loggedInUser');
    if (username == null) return null;

    final snapshot = await db.child('users/$username').get();
    if (!snapshot.exists) return null;

    return UserModel.fromMap(username, snapshot.value as Map);
  }

  Future<bool> isLoggedIn() async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.containsKey('loggedInUser');
  }

  Future<void> saveProfileImagePath(String username, String path) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.setString('profileImagePath_$username', path);
  }

  Future<String?> loadProfileImagePath(String username) async {
    final prefs = await SharedPreferences.getInstance();
    return prefs.getString('profileImagePath_$username');
  }
}
