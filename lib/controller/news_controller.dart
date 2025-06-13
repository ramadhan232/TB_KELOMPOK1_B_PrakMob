import 'dart:convert';
import 'package:flutter/widgets.dart';
import 'package:http/http.dart' as http;
import '../constants/api_constants.dart';
import '../model/news_everything.dart';
import '../model/news_top_headline_country.dart';
import '../model/news_top_headline_source.dart';

class NewsController with ChangeNotifier {
  NewsEverythingModel? _newsModel;
  NewsTopHeadlineCountryModel? _topHeadlineCountryModel;
  NewsTopHeadlineSourceModel? _sourceModel;
  late bool _isLoading = false;
  String? _errorMessage;

  NewsEverythingModel? get newsModel => _newsModel;
  NewsTopHeadlineCountryModel? get topHeadlineCountryModel =>
      _topHeadlineCountryModel;
  NewsTopHeadlineSourceModel? get sourceModel => _sourceModel;
  bool get isLoading => _isLoading;
  String? get errorMessage => _errorMessage;

  Future<void> fetchEveryting({required String query}) async {
    _isLoading = true;
    notifyListeners();
    try {
      final uri = Uri.parse(
        '${ApiConstants.baseUrl}${ApiConstants.everytingEndpoint}?q=$query&pageSize=${ApiConstants.defaultParams['pageSize']}',
      );
      final response = await http.get(uri, headers: ApiConstants.headers);
      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        _newsModel = NewsEverythingModel.fromJson(data);
        _errorMessage = null;
      } else {
        _errorMessage = 'Failed to load news: ${response.statusCode}';
      }
    } catch (e) {
      _errorMessage = 'Error fetching news: ${e.toString()}';
    } finally {
      _isLoading = false;
      notifyListeners();
    }
  }
}
