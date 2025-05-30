import 'package:flutter/material.dart';
import '../utils/helper.dart';

class NewsAppBar extends StatefulWidget {
  const NewsAppBar({super.key});

  @override
  State<NewsAppBar> createState() => _NewsAppBarState();
}

class _NewsAppBarState extends State<NewsAppBar> {
  @override
  Widget build(BuildContext context) {
    return AppBar(
      title: const Text('News', style: TextStyle(color: AppColors.deepIce)),
      backgroundColor: AppColors.iceBlue,
      elevation: 0,
      iconTheme: const IconThemeData(color: AppColors.deepIce),
      actions: const [
        Padding(
          padding: EdgeInsets.only(right: 12.0),
          child: Icon(Icons.account_circle, color: AppColors.deepIce),
        ),
      ],
    );
  }
}
