import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import '../model/news_model.dart';

class NewsController extends ChangeNotifier {
  final String _url = 'http://45.149.187.204:3000/api/news';
  List<NewsModel> _newsList = [];
  final Set<int> _bookmarkedIds = {}; //
  bool _loading = false;
  String? _error;

  List<NewsModel> get newsList => _newsList;
  bool get isLoading => _loading;
  String? get error => _error;

  bool isBookmarked(int id) => _bookmarkedIds.contains(id);

  // ✅ Toggle status bookmark
  void toggleBookmark(int id) {
    if (_bookmarkedIds.contains(id)) {
      _bookmarkedIds.remove(id);
    } else {
      _bookmarkedIds.add(id);
    }
    notifyListeners();
  }

  Future<void> fetchNews() async {
    _loading = true;
    _error = null;
    notifyListeners();

    try {
      final response = await http.get(Uri.parse(_url));

      if (response.statusCode == 200) {
        final decoded = jsonDecode(response.body);
        final body = decoded['body'];

        if (body != null && body['data'] != null && body['data'] is List) {
          final List<dynamic> newsData = body['data'];
          _newsList = newsData.map((e) => NewsModel.fromJson(e)).toList();
        } else {
          _error = 'Data berita kosong atau tidak valid';
          _newsList = [];
        }
      } else {
        _error = 'Gagal mengambil data: ${response.statusCode}';
      }
    } catch (e) {
      _error = 'Terjadi kesalahan: $e';
    }

    _loading = false;
    notifyListeners();
  }
}
