import 'dart:async';
import 'package:flutter/material.dart';
import 'package:plan/screens/auth/auth.dart';
import 'package:plan/screens/auth/secure_storage.dart';
import 'package:plan/screens/onboarding/on_boarding.dart';
import 'package:plan/screens/onboarding/questionaire/questionaire.dart';

import '../home/home.dart';

class SplashScreen extends StatefulWidget {
  const SplashScreen({super.key});

  @override
  State<SplashScreen> createState() => _SplashScreenState();
}

class _SplashScreenState extends State<SplashScreen>
    with TickerProviderStateMixin {
  @override
  void initState() {
    super.initState();

    Timer(
      const Duration(milliseconds: 1000),
      () => checkLoggedIn(),
    );
  }

  Future<void> checkLoggedIn() async {
    SecureStorage secureStorage = SecureStorage();
    String? token = await secureStorage.read(key: 'token');
    String? onboarding = await secureStorage.read(key: 'onboarding');
    String? questionaire = await secureStorage.read(key: 'questionaire');

    print(await secureStorage.read(key: 'onboarding')); //test
    print(await secureStorage.read(key: 'questionaire')); //test

    if (token != null) {
      if (onboarding == 'complete') {
        if(questionaire == 'complete'){
          Navigator.of(context)
              .pushReplacement(MaterialPageRoute(builder: (context) => Home()));
        }
        else{
          Navigator.of(context)
              .pushReplacement(MaterialPageRoute(builder: (context) => QuestionaireScreen()));
        }
      } else {
        Navigator.of(context).pushReplacement(
            MaterialPageRoute(builder: (context) => OnboardingScreen()));
      }
    } else {
      Navigator.pushReplacement(
          context, MaterialPageRoute(builder: (context) => const AuthScreen()));
    }
  }

  @override
  Widget build(BuildContext context) {
    return const Scaffold(
      body: SafeArea(
        top: false,
        child: Center(
          child: Text('Plan'),
        ),
      ),
    );
  }
}
