import 'package:flutter/material.dart';
import 'package:tb_kelompok1_b/utils/helper.dart';
import '../model/news_model.dart';

class NewsDetailView extends StatelessWidget {
  final NewsModel news;

  const NewsDetailView({super.key, required this.news});

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    final screenWidth = MediaQuery.of(context).size.width;
    return Container(
      color: AppColors.frostWhite,
      child: SingleChildScrollView(
        padding: const EdgeInsets.only(bottom: 24),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            if (news.image.isNotEmpty)
              Padding(
                padding: const EdgeInsets.only(top: 16, bottom: 8),
                child: Align(
                  alignment: Alignment.center,
                  child: ClipRRect(
                    borderRadius: BorderRadius.circular(12),
                    child: SizedBox(
                      width: screenWidth * 0.50, //
                      child: AspectRatio(
                        aspectRatio: 16 / 9,
                        child: Image.network(
                          news.image,
                          fit: BoxFit.cover,
                          errorBuilder:
                              (_, __, ___) =>
                                  const Center(child: Icon(Icons.broken_image)),
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                news.title,
                style: textTheme.titleLarge?.copyWith(
                  fontWeight: FontWeight.bold,
                  color: AppColors.deepIce,
                ),
              ),
            ),
            const SizedBox(height: 8),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                'By ${news.author}',
                style: textTheme.bodyMedium?.copyWith(
                  color: AppColors.deepIce,
                  fontStyle: FontStyle.italic,
                ),
              ),
            ),
            const Divider(height: 32),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 16),
              child: Text(
                news.content,
                style: const TextStyle(
                  fontSize: 16,
                  color: AppColors.deepIce,
                  height: 1.6,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
