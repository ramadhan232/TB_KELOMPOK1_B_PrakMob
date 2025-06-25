import 'package:flutter/material.dart';
import 'package:flutter/cupertino.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:tb_kelompok1_b/utils/helper.dart';
import '../controller/bookmark_controller.dart';
import '../model/news_model.dart';

class TopStoriesCard extends StatefulWidget {
  final NewsModel news;
  final VoidCallback? onTap;

  const TopStoriesCard({super.key, required this.news, this.onTap});

  @override
  State<TopStoriesCard> createState() => _TopStoriesCardState();
}

class _TopStoriesCardState extends State<TopStoriesCard> {
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
    return GestureDetector(
      onTap: widget.onTap, // ✅ gunakan callback eksternal
      child: ClipRRect(
        borderRadius: BorderRadius.circular(12),
        child: Stack(
          alignment: Alignment.bottomLeft,
          children: [
            // ✅ Gambar utama
            widget.news.image.isNotEmpty
                ? Image.network(
                  widget.news.image,
                  width: double.infinity,
                  height: 220,
                  fit: BoxFit.cover,
                  errorBuilder:
                      (_, __, ___) => Container(
                        width: double.infinity,
                        height: 220,
                        color: Colors.grey.shade300,
                        child: const Icon(Icons.broken_image, size: 48),
                      ),
                )
                : Container(
                  width: double.infinity,
                  height: 220,
                  color: Colors.grey.shade300,
                  child: const Icon(Icons.image, size: 48),
                ),
            // ✅ Overlay gradient
            Container(
              height: 220,
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [Colors.black, Colors.transparent],
                  begin: Alignment.bottomCenter,
                  end: Alignment.topCenter,
                ),
              ),
            ),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const SizedBox(width: 12),
                Expanded(
                  child: Text(
                    widget.news.title,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                    style: const TextStyle(
                      fontSize: 18,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                      shadows: [Shadow(color: Colors.black54, blurRadius: 6)],
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(16),
                  child: IconButton(
                    icon: Icon(
                      isBookmarked
                          ? CupertinoIcons.star_fill
                          : CupertinoIcons.star,
                      color:
                          isBookmarked
                              ? AppColors.frozenTeal
                              : AppColors.glacierGray,
                    ),
                    onPressed: toggleBookmark,
                    tooltip:
                        isBookmarked ? 'Hapus Bookmark' : 'Tambahkan Bookmark',
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
