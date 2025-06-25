import 'package:flutter/material.dart';
import 'package:flutter_screenutil/flutter_screenutil.dart';
import 'package:tb_kelompok1_b/screens/bookmark_screen.dart';
import 'package:tb_kelompok1_b/screens/search_screen.dart';
import 'home_screen.dart';
import '../utils/helper.dart';
import '../widgets/bottom_nav_bar.dart';
import 'me_screen.dart';
import '../widgets/news_app_bar.dart';

class MainScreen extends StatefulWidget {
  const MainScreen({super.key});

  @override
  State<MainScreen> createState() => _MainScreenState();
}

class _MainScreenState extends State<MainScreen> {
  int _currentIndex = 0;

  final List<Widget> _pages = const [
    HomeScreen(),
    SearchScreen(),
    BookmarkScreen(),
    MeScreen(),
  ];

  void _onTap(int index) {
    setState(() {
      _currentIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      title: 'News App',
      home: ScreenUtilInit(
        designSize: const Size(375, 812),
        minTextAdapt: true,
        builder:
            (context, _) => Scaffold(
              appBar: const PreferredSize(
                preferredSize: Size.fromHeight(60),
                child: NewsAppBar(),
              ),
              backgroundColor: AppColors.frostWhite,
              body: _pages[_currentIndex],
              bottomNavigationBar: BottomNavBar(
                currentIndex: _currentIndex,
                onTap: _onTap,
              ),
            ),
      ),
    );
  }
}
