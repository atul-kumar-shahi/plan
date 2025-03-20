// ignore_for_file: public_member_api_docs, sort_constructors_first
import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

// ignore: must_be_immutable
class NavBar extends StatefulWidget {
  int selectedIndex;
  PageController pageController;
  NavBar({
    Key? key,
    required this.selectedIndex,
    required this.pageController,
  }) : super(key: key);

  @override
  State<NavBar> createState() => _NavBarState();
}

class _NavBarState extends State<NavBar> {
  @override
  Widget build(BuildContext context) {
    return BottomNavigationBar(
      selectedItemColor: Colors.black,
      unselectedItemColor: Colors.black,
      showUnselectedLabels: true,
      items: const <BottomNavigationBarItem>[
        BottomNavigationBarItem(
            icon: Icon(Icons.dashboard, color: Colors.black),
            label: 'Dashborad'),
        BottomNavigationBarItem(
            icon: Icon(Icons.add, color: Colors.black), label: 'Screen1'),
        BottomNavigationBarItem(
            icon: Icon(Icons.add, color: Colors.black), label: 'Screen2'),
        BottomNavigationBarItem(
            icon: Icon(Icons.person, color: Colors.black), label: 'Profile'),
      ],
      currentIndex: widget.selectedIndex,
      onTap: (value) {
        setState(() {
          widget.selectedIndex = value;
          widget.pageController.animateToPage(widget.selectedIndex,
              duration: const Duration(milliseconds: 200),
              curve: Curves.linear);
        });
      },
    );
  }
}
