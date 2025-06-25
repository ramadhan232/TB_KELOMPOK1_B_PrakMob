import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controller/news_controller.dart';
import '../model/news_model.dart';
import '../widgets/news_detail_view.dart';

class NewsDetailScreen extends StatefulWidget {
  final String newsId;

  const NewsDetailScreen({super.key, required this.newsId});

  @override
  State<NewsDetailScreen> createState() => _NewsDetailScreenState();
}

class _NewsDetailScreenState extends State<NewsDetailScreen> {
  bool _loading = true;
  NewsModel? _news;
  String? _error;

  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) async {
      final controller = context.read<NewsController>();

      try {
        if (controller.newsList.isEmpty) {
          await controller.fetchNews();
        }

        final item = controller.newsList.firstWhere(
          (e) => e.id == widget.newsId,
          orElse: () => NewsModel.empty(),
        );

        if (item.id.isNotEmpty) {
          setState(() {
            _news = item;
            _loading = false;
          });
        } else {
          setState(() {
            _error = "Berita tidak ditemukan";
            _loading = false;
          });
        }
      } catch (e) {
        setState(() {
          _error = "Terjadi kesalahan: $e";
          _loading = false;
        });
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    if (_loading) {
      return const Scaffold(body: Center(child: CircularProgressIndicator()));
    }

    if (_error != null) {
      return Scaffold(
        appBar: AppBar(title: const Text("Berita")),
        body: Center(child: Text(_error!)),
      );
    }

    return Scaffold(
      appBar: AppBar(title: Text(_news!.title)),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: NewsDetailView(news: _news!),
      ),
    );
  }
}
