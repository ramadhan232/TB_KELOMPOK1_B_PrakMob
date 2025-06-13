import 'package:flutter/material.dart';
import '../model/article_model.dart';
import '../utils/helper.dart';
import '../controller/news_controller.dart';
import 'package:provider/provider.dart';

class NewsListItem extends StatefulWidget {
  const NewsListItem({super.key});

  @override
  State<NewsListItem> createState() => _NewsListItemState();
}

class _NewsListItemState extends State<NewsListItem>
    with SingleTickerProviderStateMixin {
  late TabController tabController;

  @override
  void initState() {
    super.initState();
    tabController = TabController(length: 3, vsync: this);
    WidgetsBinding.instance.addPostFrameCallback((_) {
      context.read<NewsController>().fetchEveryting(query: 'technology');
    });
  }

  @override
  void dispose() {
    tabController.dispose();
    super.dispose();
  }

  bool isBookmarked = false;

  void toggleBookmark() {
    setState(() {
      isBookmarked = !isBookmarked;
    });
  }

  @override
  Widget build(BuildContext context) {
    final controller = context.watch<NewsController>();
    final articles = controller.newsModel?.articles ?? [];

    if (controller.isLoading) {
      return const Center(child: CircularProgressIndicator());
    }

    if (controller.errorMessage != null) {
      return Center(child: Text(controller.errorMessage!));
    }

    if (articles.isEmpty) {
      return const Center(child: Text('No articles found.'));
    }

    return ListView.builder(
      padding: const EdgeInsets.all(16),
      itemCount: articles.length,
      itemBuilder: (context, index) {
        final article = articles[index];
        return _buildNewsCard(article);
      },
    );
  }

  Widget _buildNewsCard(Article article) {
    bool isBookmarked = false;

    return StatefulBuilder(
      builder: (context, setBookmarkState) {
        return Card(
          color: AppColors.iceBlue,
          margin: const EdgeInsets.only(bottom: 12),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(12),
          ),
          child: ListTile(
            contentPadding: const EdgeInsets.all(12),
            leading: ClipRRect(
              borderRadius: BorderRadius.circular(8),
              child:
                  (article.urlToImage?.isNotEmpty ?? false)
                      ? Image.network(
                        article.urlToImage!,
                        width: 50,
                        height: 50,
                        fit: BoxFit.cover,
                        errorBuilder:
                            (context, error, stackTrace) =>
                                const Icon(Icons.broken_image),
                      )
                      : Container(
                        width: 50,
                        height: 50,
                        color: AppColors.silverMist,
                        child: const Icon(Icons.image, color: Colors.white),
                      ),
            ),
            title: Text(
              article.title ?? 'No Title',
              style: const TextStyle(
                fontWeight: FontWeight.bold,
                color: AppColors.deepIce,
              ),
            ),
            subtitle: Text(
              article.description ?? 'No Description',
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(color: AppColors.glacierGray),
            ),
            trailing: IconButton(
              icon: Icon(
                isBookmarked ? Icons.bookmark : Icons.bookmark_border,
                color: AppColors.deepIce,
              ),
              onPressed: () {
                setBookmarkState(() {
                  isBookmarked = !isBookmarked;
                });
              },
            ),
            onTap: () {
              // TODO: navigate to detail or show dialog
            },
          ),
        );
      },
    );
  }
}
