import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../model/news_model.dart';

class BookmarkController extends ChangeNotifier {
  static const _key = 'bookmarked_news';

  List<NewsModel> _bookmarked = [];

  List<NewsModel> get bookmarked => _bookmarked;

  BookmarkController() {
    _loadBookmarks();
  }

  bool isBookmarked(NewsModel news) {
    return _bookmarked.any((item) => item.id == news.id);
  }

  void toggle(NewsModel news) {
    if (isBookmarked(news)) {
      _bookmarked.removeWhere((item) => item.id == news.id);
    } else {
      _bookmarked.add(news);
    }
    _saveBookmarks();
    notifyListeners();
  }

  void clear() {
    _bookmarked.clear();
    _saveBookmarks();
    notifyListeners();
  }

  Future<void> _saveBookmarks() async {
    final prefs = await SharedPreferences.getInstance();
    final encoded = _bookmarked.map((e) => jsonEncode(e.toJson())).toList();
    await prefs.setStringList(_key, encoded);
  }

  Future<void> _loadBookmarks() async {
    final prefs = await SharedPreferences.getInstance();
    final encodedList = prefs.getStringList(_key) ?? [];

    _bookmarked =
        encodedList.map((e) => NewsModel.fromJson(jsonDecode(e))).toList();

    notifyListeners();
  }
}
