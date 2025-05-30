import 'package:flutter/material.dart';
import '../utils/helper.dart';

class TopStoriesCard extends StatefulWidget {
  const TopStoriesCard({super.key});

  @override
  State<TopStoriesCard> createState() => _TopStoriesCardState();
}

class _TopStoriesCardState extends State<TopStoriesCard> {
  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        color: AppColors.paleCyan,
        borderRadius: BorderRadius.circular(12),
      ),
      padding: const EdgeInsets.all(12),
      child: const ListTile(
        leading: CircleAvatar(
          backgroundColor: AppColors.frozenTeal,
          child: Icon(Icons.person, color: Colors.white),
        ),
        title: Text(
          'Header',
          style: TextStyle(
            fontWeight: FontWeight.bold,
            color: AppColors.deepIce,
          ),
        ),
        subtitle: Text(
          'Subhead',
          style: TextStyle(color: AppColors.glacierGray),
        ),
      ),
    );
  }
}
