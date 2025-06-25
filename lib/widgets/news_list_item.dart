import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import '../controller/bookmark_controller.dart';
import '../model/news_model.dart';
import '../widgets/news_detail_view.dart';
import '../utils/helper.dart';

class NewsListItem extends StatefulWidget {
  final NewsModel news;
  final VoidCallback? onTap;

  const NewsListItem({super.key, required this.news, this.onTap});

  @override
  State<NewsListItem> createState() => _NewsListItemState();
}

class _NewsListItemState extends State<NewsListItem> {
  bool isBookmarked = false;

  @override
  void initState() {
    super.initState();
    _loadBookmarkState();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    final controller = context.read<BookmarkController>();
    isBookmarked = controller.isBookmarked(widget.news);
  }

  Future<void> _loadBookmarkState() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getStringList('bookmarks') ?? [];
    setState(() {
      isBookmarked = saved.contains(widget.news.id);
    });
  }

  Future<void> toggleBookmark() async {
    final prefs = await SharedPreferences.getInstance();
    final saved = prefs.getStringList('bookmarks') ?? [];
    if (saved.contains(widget.news.id)) {
      saved.remove(widget.news.id);
    } else {
      saved.add(widget.news.id);
    }
    await prefs.setStringList('bookmarks', saved);
    setState(() {
      isBookmarked = saved.contains(widget.news.id);
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      color: AppColors.paleCyan,
      margin: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      elevation: 2,
      child: InkWell(
        onTap:
            widget.onTap ??
            () {
              Navigator.push(
                context,
                MaterialPageRoute(
                  builder: (_) => NewsDetailView(news: widget.news),
                ),
              );
            },
        child: Padding(
          padding: const EdgeInsets.symmetric(vertical: 8),
          child: ListTile(
            leading:
                widget.news.image.isNotEmpty
                    ? Image.network(
                      widget.news.image,
                      width: 60,
                      height: 60,
                      fit: BoxFit.cover,
                      errorBuilder:
                          (_, __, ___) => const Icon(Icons.broken_image),
                    )
                    : const Icon(Icons.image, size: 48),
            title: Text(
              widget.news.title,
              style: const TextStyle(fontWeight: FontWeight.bold),
            ),
            subtitle: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.news.content,
                  maxLines: 2,
                  overflow: TextOverflow.ellipsis,
                ),
                const SizedBox(height: 4),
                Text(
                  'Author: ${widget.news.author}',
                  style: const TextStyle(fontSize: 12, color: Colors.black),
                ),
              ],
            ),
            trailing: IconButton(
              icon: Icon(
                isBookmarked ? CupertinoIcons.star_fill : CupertinoIcons.star,
                color:
                    isBookmarked ? AppColors.frozenTeal : AppColors.glacierGray,
              ),
              onPressed: toggleBookmark,
              tooltip: isBookmarked ? 'Hapus Bookmark' : 'Tambahkan Bookmark',
            ),
          ),
        ),
      ),
    );
  }
}
