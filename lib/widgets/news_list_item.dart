import 'package:flutter/material.dart';
import '../utils/helper.dart';

class NewsListItem extends StatefulWidget {
  const NewsListItem({super.key});

  @override
  State<NewsListItem> createState() => _NewsListItemState();
}

class _NewsListItemState extends State<NewsListItem> {
  bool isBookmarked = false;

  void toggleBookmark() {
    setState(() {
      isBookmarked = !isBookmarked;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.iceBlue,
      margin: const EdgeInsets.only(bottom: 12),
      shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
      child: ListTile(
        leading: Container(
          width: 50,
          height: 50,
          decoration: BoxDecoration(
            color: AppColors.silverMist,
            borderRadius: BorderRadius.circular(8),
          ),
          child: const Icon(Icons.image, color: Colors.white),
        ),
        title: const Text(
          'List item',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.deepIce,
          ),
        ),
        subtitle: const Text(
          'Supporting line text lorem ipsum dolor sit amet, consectetur.',
          style: TextStyle(color: AppColors.glacierGray),
        ),
        trailing: IconButton(
          icon: Icon(
            isBookmarked ? Icons.bookmark : Icons.bookmark_border,
            color: AppColors.deepIce,
          ),
          onPressed: toggleBookmark,
        ),
      ),
    );
  }
}
