import 'package:flutter/material.dart';
import '../utils/helper.dart';
import 'package:flutter/cupertino.dart';

class AuthorBottomNavBar extends StatefulWidget {
  final int currentIndex;
  final ValueChanged<int> onTap;

  const AuthorBottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });

  @override
  State<AuthorBottomNavBar> createState() => _AuthorBottomNavBarState();
}

class _AuthorBottomNavBarState extends State<AuthorBottomNavBar> {
  late int _authorcurrentindex;

  @override
  void initState() {
    super.initState();
    _authorcurrentindex = widget.currentIndex;
  }

  void _onItemTapped(int index) {
    setState(() {
      _authorcurrentindex = index;
    });
    widget.onTap(index);
  }

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      backgroundColor: AppColors.frozenTeal,
      currentIndex: _authorcurrentindex,
      onTap: _onItemTapped,
      type: BottomNavigationBarType.fixed,
      selectedItemColor: AppColors.frostWhite,
      unselectedItemColor: Colors.black,
      showSelectedLabels: true,
      showUnselectedLabels: true,
      items: const [
        BottomNavigationBarItem(icon: Icon(CupertinoIcons.home), label: 'Home'),
        BottomNavigationBarItem(icon: Icon(CupertinoIcons.news), label: 'News'),
        BottomNavigationBarItem(
          icon: Icon(CupertinoIcons.person_circle),
          label: 'Profile',
        ),
      ],
    );
  }
}
