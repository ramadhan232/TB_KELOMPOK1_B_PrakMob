import 'package:flutter/material.dart';
import 'package:tb_kelompok1_b/widgets/author_news_detail_form.dart';
import '../model/author_news_model.dart';

class AuthorNewsListItem extends StatelessWidget {
  final AuthorNewsModel news;
  final VoidCallback? onTap;

  const AuthorNewsListItem({super.key, required this.news, this.onTap});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: Card(
        margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
        child: ListTile(
          leading:
              news.featuredImageUrl.isNotEmpty
                  ? Image.network(
                    news.featuredImageUrl,
                    width: 60,
                    height: 60,
                    fit: BoxFit.cover,
                    errorBuilder:
                        (_, __, ___) =>
                            const Icon(Icons.broken_image, size: 48),
                  )
                  : const Icon(Icons.image, size: 48),
          title: Text(
            news.title,
            style: const TextStyle(fontWeight: FontWeight.bold),
          ),
          subtitle: Text(
            news.summary,
            maxLines: 2,
            overflow: TextOverflow.ellipsis,
          ),
          onTap:
              onTap ??
              () {
                Navigator.push(
                  context,
                  MaterialPageRoute(
                    builder: (_) => AuthorNewsDetailForm(newsId: news.id),
                  ),
                );
              },
        ),
      ),
    );
  }
}
