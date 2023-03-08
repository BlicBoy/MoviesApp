import 'package:flutter/material.dart';

class BottomBar extends StatelessWidget {
  final selectedIndex;
  ValueChanged<int> onClicked;
  BottomBar({super.key, required this.selectedIndex, required this.onClicked});

  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
          icon: Icon(Icons.movie),
          label: 'Movies',
        ),
        BottomNavigationBarItem(
          icon: Icon(Icons.favorite),
          label: 'Follow',
        ),
         BottomNavigationBarItem(
          icon: Icon(Icons.person),
          label: 'Profile',
        ),
      ],
      currentIndex: selectedIndex,
      onTap: onClicked,
    );
  }
}
