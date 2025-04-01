import 'package:flutter/material.dart';
import 'package:rick_and_morty/constants/colors.dart';

class BottomNavBar extends StatelessWidget {

  const BottomNavBar({
    super.key,
    required this.currentIndex,
    required this.onTap,
  });
  final int currentIndex;
  final Function(int) onTap;

  @override
  Widget build(BuildContext context) => BottomNavigationBar(
      selectedItemColor: greenColor,
      currentIndex: currentIndex,
      onTap: onTap,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          activeIcon: Icon(Icons.home),
          icon: Icon(Icons.home_outlined),
          label: 'Characters',
        ),
        BottomNavigationBarItem(
          activeIcon: Icon(Icons.star),
          icon: Icon(Icons.star_border),
          label: 'Favorites',
        ),
      ],
    );
}
