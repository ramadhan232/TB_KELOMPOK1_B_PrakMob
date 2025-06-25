import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tb_kelompok1_b/screens/author_news_screen.dart';
import 'package:tb_kelompok1_b/screens/me_author_screen.dart';
import 'package:tb_kelompok1_b/widgets/author_app_bar.dart';
import 'package:tb_kelompok1_b/widgets/author_bottom_nav_bar.dart';
import 'home_screen.dart';
import '../utils/helper.dart';

class MainAuthorScreen extends StatefulWidget {
  const MainAuthorScreen({super.key});

  @override
  State<MainAuthorScreen> createState() => _MainAuthorScreenState();
}

class _MainAuthorScreenState extends State<MainAuthorScreen> {
  int authorcurrentindex = 0;

  final List<Widget> _pages = const [
    HomeScreen(),
    AuthorNewsScreen(),
    MeAuthorScreen(),
  ];

  void _onTap(int index) {
    setState(() {
      authorcurrentindex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return ScreenUtilInit(
      designSize: const Size(375, 812), // iPhone X layout as base
      minTextAdapt: true,
      splitScreenMode: true,
      builder: (context, child) {
        return MaterialApp(
          title: 'News App',
          home: Scaffold(
            appBar: const PreferredSize(
              preferredSize: Size.fromHeight(60),
              child: AuthorAppBar(),
            ),
            backgroundColor: AppColors.frostWhite,
            body: _pages[authorcurrentindex],
            bottomNavigationBar: AuthorBottomNavBar(
              currentIndex: authorcurrentindex,
              onTap: _onTap,
            ),
          ),
        );
      },
    );
  }
}
