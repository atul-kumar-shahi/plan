import 'package:after_layout/after_layout.dart';
import 'package:flutter/material.dart';
import 'intro_screen.dart';

class OnboardingScreen extends StatefulWidget {
  @override
  State<OnboardingScreen> createState() => _OnboardingScreenState();
}

class _OnboardingScreenState extends State<OnboardingScreen>
    with AfterLayoutMixin<OnboardingScreen> {
  Future checkFirstSeen() async {
    Navigator.of(context).pushReplacement(
        new MaterialPageRoute(builder: (context) => IntroScreen()));
  }

  @override
  void afterFirstLayout(BuildContext context) => checkFirstSeen();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: Text('Loading...'),
      ),
    );
  }
}