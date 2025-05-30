import 'package:flutter/material.dart';
import '../widgets/news_app_bar.dart';
import '../widgets/top_stories_card.dart';
import '../widgets/news_list_item.dart';
import '../utils/helper.dart';

class HomeScreen extends StatefulWidget {
  const HomeScreen({super.key});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.frostWhite,
      appBar: const PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: NewsAppBar(),
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Text(
              'Top Stories',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.deepIce,
              ),
            ),
            const SizedBox(height: 10),
            const TopStoriesCard(),
            const SizedBox(height: 20),
            const Text(
              'Latest News',
              style: TextStyle(
                fontSize: 18,
                fontWeight: FontWeight.bold,
                color: AppColors.deepIce,
              ),
            ),
            const SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: 3,
                itemBuilder: (context, index) => const NewsListItem(),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
