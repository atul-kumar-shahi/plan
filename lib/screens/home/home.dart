import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:plan/screens/auth/auth.dart';
import 'package:plan/screens/auth/secure_storage.dart';
import 'package:plan/screens/home/screen1.dart';

import 'dashboard.dart';

class Home extends StatefulWidget {
  const Home({super.key});

  @override
  State<Home> createState() => _HomeState();
}

class _HomeState extends State<Home> {
  int _currentIndex = 0;
  var pageController = PageController();

  void _onItemTapped(int index) {
    setState(() {
      _currentIndex = index;
    });
    pageController.jumpToPage(index);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: BottomNavigationBar(
        backgroundColor: Colors.white,
        selectedItemColor: Colors.black,
        unselectedItemColor: Colors.black,
        showUnselectedLabels: true,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard, color: Colors.black),
            label: 'Dashboard',
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.wallet_outlined, color: Colors.black),
            label: 'Net Worth',
          ),
        ],
        currentIndex: _currentIndex,
        onTap: _onItemTapped,
      ),
      body: PageView(
        controller: pageController,
        onPageChanged: (value) {
          setState(() {
            _currentIndex = value;
          });
        },
        children: const [
          Dashboard(),
          Screen1(),
        ],
      ),
    );
  }
}
