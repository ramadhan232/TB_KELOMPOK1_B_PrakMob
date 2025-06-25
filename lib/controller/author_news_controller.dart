import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import '../model/author_news_model.dart';

class AuthorNewsController extends ChangeNotifier {
  final String token;
  final String _baseUrl = 'http://45.149.187.204:3000/api/author/news';

  AuthorNewsController({required this.token});

  List<AuthorNewsModel> _newsList = [];
  AuthorNewsModel? _news;
  String? _error;
  bool _loading = false;

  List<AuthorNewsModel> get newsList => _newsList;
  AuthorNewsModel? get news => _news;
  String? get error => _error;
  bool get isLoading => _loading;

  Future<void> fetchAllNews() async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      final response = await http.get(
        Uri.parse(_baseUrl),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );

      final data = jsonDecode(response.body);
      if (response.statusCode == 200 && data['body']?['data'] is List) {
        _newsList =
            (data['body']['data'] as List)
                .map((e) => AuthorNewsModel.fromJson(e))
                .toList();
      } else {
        _error = data['body']?['message'] ?? 'Gagal mengambil data';
      }
    } catch (e) {
      _error = 'Terjadi kesalahan: $e';
    }

    _loading = false;
    notifyListeners();
  }

  Future<void> fetchNewsById(String id) async {
    _loading = true;
    _error = null;
    notifyListeners();
    try {
      final response = await http.get(
        Uri.parse('$_baseUrl/$id'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      final data = jsonDecode(response.body);
      if (response.statusCode == 200 && data['body']?['data'] != null) {
        _news = AuthorNewsModel.fromJson(data['body']['data']);
      } else {
        _error = data['body']?['message'] ?? 'Gagal mengambil data';
      }
    } catch (e) {
      _error = 'Terjadi kesalahan: $e';
    }

    _loading = false;
    notifyListeners();
  }

  Future<bool> postNews(AuthorNewsModel news) async {
    try {
      final payload = news.toJson();
      payload['isPublished'] = true;
      final response = await http.post(
        Uri.parse(_baseUrl),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(payload),
      );

      final data = jsonDecode(response.body);
      if (response.statusCode == 201 || response.statusCode == 200) {
        await fetchAllNews(); // Refresh list after post
        return true;
      } else {
        _error = data['body']?['message'] ?? 'Gagal menambahkan berita';
        return false;
      }
    } catch (e) {
      _error = 'Terjadi kesalahan: $e';
      return false;
    }
  }

  Future<bool> updateNewsById(String id, AuthorNewsModel updatedNews) async {
    try {
      final response = await http.put(
        Uri.parse('$_baseUrl/$id'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
        body: jsonEncode(updatedNews.toJson()),
      );
      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        await fetchAllNews(); // Refresh after update
        return true;
      } else {
        _error = data['body']?['message'] ?? 'Gagal memperbarui';
        return false;
      }
    } catch (e) {
      _error = 'Terjadi kesalahan: $e';
      return false;
    }
  }

  Future<bool> deleteNewsById(String id) async {
    try {
      final response = await http.delete(
        Uri.parse('$_baseUrl/$id'),
        headers: {
          'Authorization': 'Bearer $token',
          'Content-Type': 'application/json',
        },
      );
      final data = jsonDecode(response.body);
      if (response.statusCode == 200) {
        _newsList.removeWhere((item) => item.id == id);
        notifyListeners();
        return true;
      } else {
        _error = data['body']?['message'] ?? 'Gagal menghapus';
        return false;
      }
    } catch (e) {
      _error = 'Terjadi kesalahan: $e';
      return false;
    }
  }
}
