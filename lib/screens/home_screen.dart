import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import '../controller/news_controller.dart';
import '../widgets/news_list_item.dart';
import '../widgets/top_stories_card.dart';
import '../widgets/news_detail_view.dart';
import '../model/news_model.dart';
import '../utils/helper.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> with TickerProviderStateMixin {
  NewsModel? selectedNews;
  late AnimationController _fadeController;
  late Animation<double> _fadeAnimation;

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NewsController>().fetchNews();
    });

    _fadeController = AnimationController(
      duration: const Duration(milliseconds: 300),
      vsync: this,
    );
    _fadeAnimation = CurvedAnimation(
      parent: _fadeController,
      curve: Curves.easeInOut,
    );
  }

  @override
  void dispose() {
    _fadeController.dispose();
    super.dispose();
  }

  void onNewsSelected(NewsModel news) {
    setState(() {
      selectedNews = news;
    });
    _fadeController.forward(from: 0);
  }

  void onBackFromDetail() {
    _fadeController.reverse().then((_) {
      setState(() {
        selectedNews = null;
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Consumer<NewsController>(
            builder: (context, controller, _) {
              if (controller.isLoading) {
                return const Center(child: CircularProgressIndicator());
              } else if (controller.error != null) {
                return Center(child: Text(controller.error!));
              }

              final topStory =
                  controller.newsList.isNotEmpty
                      ? controller.newsList.first
                      : null;
              final latestNews =
                  controller.newsList.length > 1
                      ? controller.newsList.sublist(1)
                      : [];

              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    const Text(
                      'Latest News',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.deepIce,
                      ),
                    ),
                    const SizedBox(height: 10),
                    if (topStory != null)
                      TopStoriesCard(
                        news: topStory,
                        onTap: () => onNewsSelected(topStory),
                      ),
                    const SizedBox(height: 20),
                    const Text(
                      'News',
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.bold,
                        color: AppColors.deepIce,
                      ),
                    ),
                    const SizedBox(height: 10),
                    ...latestNews.map(
                      (newsItem) => NewsListItem(
                        news: newsItem,
                        onTap: () => onNewsSelected(newsItem),
                      ),
                    ),
                    const SizedBox(height: 50),
                  ],
                ),
              );
            },
          ),
        ),

        if (selectedNews != null)
          FadeTransition(
            opacity: _fadeAnimation,
            child: Container(
              color: AppColors.frostWhite,
              padding: const EdgeInsets.all(16),
              child: Column(
                children: [
                  Align(
                    alignment: Alignment.topLeft,
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
      ],
    );
  }
}
