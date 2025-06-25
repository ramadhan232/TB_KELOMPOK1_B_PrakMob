import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../controller/news_controller.dart';
import '../widgets/news_list_item.dart';
import '../widgets/news_detail_view.dart';
import '../model/news_model.dart';
import '../utils/helper.dart';

class BookmarkScreen extends StatefulWidget {
  const BookmarkScreen({super.key});

  @override
  State<BookmarkScreen> createState() => _BookmarkScreenState();
}

class _BookmarkScreenState extends State<BookmarkScreen> {
  List<String> _bookmarkedIds = [];
  NewsModel? selectedNews;

  @override
  void initState() {
    super.initState();
    _loadBookmarks();
  }

  Future<void> _loadBookmarks() async {
    final prefs = await SharedPreferences.getInstance();
    final ids = prefs.getStringList('bookmarks') ?? [];
    setState(() {
      _bookmarkedIds = ids;
    });
  }

  void onNewsSelected(NewsModel news) {
    setState(() {
      selectedNews = news;
    });
  }

  void onBackFromDetail() {
    setState(() {
      selectedNews = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final allNews = context.watch<NewsController>().newsList;
    final bookmarkedNews =
        allNews.where((news) => _bookmarkedIds.contains(news.id)).toList();

    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: RefreshIndicator(
            onRefresh: _loadBookmarks,
            child:
                bookmarkedNews.isEmpty
                    ? const Center(child: Text('Belum ada bookmark'))
                    : ListView.builder(
                      padding: const EdgeInsets.all(16),
                      itemCount: bookmarkedNews.length,
                      itemBuilder: (context, index) {
                        final news = bookmarkedNews[index];
                        return NewsListItem(
                          news: news,
                          onTap: () => onNewsSelected(news),
                        );
                      },
                    ),
          ),
        ),
        if (selectedNews != null)
          Positioned.fill(
            child: Container(
              padding: const EdgeInsets.all(16),
              color: AppColors.frostWhite,
              child: SafeArea(
                child: Column(
                  children: [
                    Align(
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: onBackFromDetail,
                      ),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: NewsDetailView(news: selectedNews!),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ),
      ],
    );
  }
}
