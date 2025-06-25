import 'package:flutter/material.dart';
import '../utils/helper.dart';

class AuthorAppBar extends StatefulWidget {
  const AuthorAppBar({super.key});

  @override
  State<AuthorAppBar> createState() => _AuthorAppBarState();
}

class _AuthorAppBarState extends State<AuthorAppBar> {
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
              decoration: BoxDecoration(color: AppColors.frostWhite),
              child: Text(
                'Author',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 24, color: Colors.black),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
