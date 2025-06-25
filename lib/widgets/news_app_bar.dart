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
      backgroundColor: AppColors.frostWhite,
      toolbarHeight: 70,
      title: Row(
        children: [
          Image.asset('assets/images/logo1.png', width: 60, height: 60),
          const SizedBox(width: 8),
          Expanded(
            child: Container(
              height: 36,
              decoration: BoxDecoration(
                color: AppColors.frostWhite,
                borderRadius: BorderRadius.circular(24),
              ),
              child: Text(
                'News Frost',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24, color: Colors.black),
              ),
            ),
          ),
          const SizedBox(width: 8),
          const CircleAvatar(
            backgroundImage: AssetImage('assets/images/profile.jpg'),
            radius: 16,
          ),
        ],
      ),
    );
  }
}
