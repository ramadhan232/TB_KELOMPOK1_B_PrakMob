// lib/controllers/auth_author_controller.dart
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../model/auth_author.dart';
import 'package:go_router/go_router.dart';
import '../routes/route_names.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthAuthorController extends ChangeNotifier {
  static AuthAuthorController? instance;
  AuthAuthorController() {
    instance = this;
  }
  bool get isLoggedIn => _auth != null;
  final String _baseUrl = 'http://45.149.187.204:3000/api/auth';
  AuthAuthor? _auth;
  String? _error;
  bool _loading = false;
  String? _token;

  AuthAuthor? get auth => _auth;
  String? get error => _error;
  bool get isLoading => _loading;
  String? get token => _token;

  Future<void> login(String email, String password) async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await http.post(
        Uri.parse('$_baseUrl/login'),
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode({'email': email, 'password': password}),
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 &&
          data['body']?['data']?['token'] != null) {
        _token = data['body']['data']['token'];
        final prefs = await SharedPreferences.getInstance();
        await prefs.setString('token', _token!);
        await fetchMe();
      } else {
        _error = data['body']?['message'] ?? 'Login gagal';
      }
    } catch (e) {
      _error = 'Terjadi kesalahan: $e';
    }

    _loading = false;
    notifyListeners();
  }

  Future<void> fetchMe() async {
    if (_token == null) return;
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/me'),
        headers: {
          'Authorization': 'Bearer $_token',
          'Content-Type': 'application/json',
        },
      );

      final data = jsonDecode(response.body);

      if (response.statusCode == 200 && data['body']?['data'] != null) {
        _auth = AuthAuthor.fromJson(data);
      } else {
        _error = data['body']?['message'] ?? 'Gagal mengambil data user';
      }
    } catch (e) {
      _error = 'Gagal mengambil data user: $e';
    }

    notifyListeners();
  }

  Future<void> logout(BuildContext context) async {
    final prefs = await SharedPreferences.getInstance();
    await prefs.remove('loggedInUser'); // atau token / user data

    _auth = null;
    _token = null;
    notifyListeners();

    if (context.mounted) {
      context.goNamed(RouteNames.splash); // atau RouteNames.loginAuthor
    }
  }
}
