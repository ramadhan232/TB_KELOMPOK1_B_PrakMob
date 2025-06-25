import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controller/news_controller.dart';
import '../widgets/news_list_item.dart';
import '../widgets/news_detail_view.dart';
import '../model/news_model.dart';
import '../utils/helper.dart';

class SearchScreen extends StatefulWidget {
  const SearchScreen({super.key});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  String? _selectedCategory;
  String _searchQuery = '';
  NewsModel? selectedNews;

  List<String> getCategories(List<NewsModel> newsList) {
    final categories =
        newsList
            .map((n) => n.category.trim())
            .toSet()
            .where((e) => e.isNotEmpty)
            .toList();
    categories.insert(0, 'Semua'); // Tambahkan pilihan "Semua" di awal
    return categories;
  }

  void openDetail(NewsModel news) {
    setState(() {
      selectedNews = news;
    });
  }

  void closeDetail() {
    setState(() {
      selectedNews = null;
    });
  }

  @override
  Widget build(BuildContext context) {
    final newsController = context.watch<NewsController>();
    final allNews = newsController.newsList;
    final categories = getCategories(allNews);
    final filteredNews =
        allNews.where((n) {
          final matchCategory =
              _selectedCategory == null ||
              _selectedCategory == 'Semua' ||
              n.category == _selectedCategory;
          final matchSearch = n.title.toLowerCase().contains(
            _searchQuery.toLowerCase(),
          );
          return matchCategory && matchSearch;
        }).toList();

    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(16),
          child: Column(
            children: [
              TextField(
                decoration: InputDecoration(
                  fillColor: Colors.white,
                  hintText: 'Cari',
                  prefixIcon: Icon(Icons.search),
                  enabledBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.frozenTeal),
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderSide: BorderSide(color: AppColors.deepIce, width: 2),
                    borderRadius: BorderRadius.circular(20.0),
                  ),
                  filled: true,
                ),
                onChanged: (value) {
                  setState(() => _searchQuery = value);
                },
              ),
              const SizedBox(height: 12),
              DropdownButtonFormField<String>(
                dropdownColor: AppColors.paleCyan,
                focusColor: AppColors.frozenTeal,
                value: _selectedCategory,
                hint: const Text("Pilih Kategori"),
                items:
                    categories.map((c) {
                      return DropdownMenuItem(value: c, child: Text(c));
                    }).toList(),
                onChanged: (value) {
                  setState(() => _selectedCategory = value);
                },
              ),

              const SizedBox(height: 16),
              Expanded(
                child:
                    filteredNews.isEmpty
                        ? const Center(
                          child: Text("Tidak ada berita ditemukan"),
                        )
                        : ListView.builder(
                          itemCount: filteredNews.length,
                          itemBuilder: (context, index) {
                            final news = filteredNews[index];
                            return NewsListItem(
                              news: news,
                              onTap: () => openDetail(news),
                            );
                          },
                        ),
              ),
            ],
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
                      alignment: Alignment.topLeft,
                      child: IconButton(
                        icon: const Icon(Icons.arrow_back),
                        onPressed: closeDetail,
                      ),
                    ),
                    Expanded(
                      child: SingleChildScrollView(
                        child: NewsDetailView(news: selectedNews!),
                        // Ganti dengan NewsDetailView(news: selectedNews!) jika ada
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
