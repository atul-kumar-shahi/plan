import 'package:flutter/material.dart';
import 'package:plan/screens/home/dashboard.dart';
import 'package:plan/screens/home/profile.dart';
import 'package:plan/screens/home/screen1.dart';
import 'package:plan/screens/home/screen2.dart';
import 'package:plan/widgets/custom_navbar.dart';

// ignore: must_be_immutable
class PageView1 extends StatefulWidget {
  int selectedIndex;
  PageView1({
    super.key,
    required this.selectedIndex,
  });

  @override
  State<PageView1> createState() => _PageView1State();
}

class _PageView1State extends State<PageView1> {
  var pageController = PageController();
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      bottomNavigationBar: NavBar(
        selectedIndex: widget.selectedIndex,
        pageController: pageController,
      ),
      body: PageView(
        controller: pageController,
        onPageChanged: (value) {
          setState(() {
            widget.selectedIndex = value;
          });
        },
        children: const [Dashboard(), Screen1(), Screen2(), Profile()],
      ),
    );
  }
}
