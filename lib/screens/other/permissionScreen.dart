import 'package:flutter/material.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:plan/core/sms_service.dart';
import 'package:plan/screens/home/home.dart';
import 'package:plan/screens/onboarding/on_boarding.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:lottie/lottie.dart';

class permissionScreen extends StatefulWidget {
  @override
  _permissionScreenState createState() => _permissionScreenState();
}

class _permissionScreenState extends State<permissionScreen> {
  bool permissionDenied = false;
  SMSService smsService = SMSService();
  @override
  void initState() {
    super.initState();
    _checkPermission();
  }

  Future<void> _checkPermission() async {
    final status = await smsService.requestPermissions();
    if (status) {
      await smsService.scanIncomingMessages(context).then(
        (value) {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => OnboardingScreen()));
        },
      );
    } else {
      _requestPermission();
    }
  }

  Future<void> _requestPermission() async {
    final status = await smsService.requestPermissions();
    if (status) {
      await smsService.scanIncomingMessages(context).then(
        (value) {
          Navigator.of(context).pushReplacement(
              MaterialPageRoute(builder: (context) => OnboardingScreen()));
        },
      );
    } else {
      setState(() {
        permissionDenied = true;
      });
    }
  }

  Future<void> _completeOnboarding() async {
    SharedPreferences prefs = await SharedPreferences.getInstance();
    await prefs.setBool('onboardingComplete', true);
    Navigator.of(context).pushReplacement(
      MaterialPageRoute(builder: (context) => OnboardingScreen()),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: permissionDenied
            ? Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Lottie.asset('assets/animations/error.json'),
                  SizedBox(height: 20),
                  Text(
                    'Permission required to read messages.',
                    style: TextStyle(fontSize: 18),
                  ),
                  SizedBox(height: 20),
                  ElevatedButton(
                    onPressed: () {
                      openAppSettings();
                    },
                    child: Text('Enable Permissions'),
                  ),
                ],
              )
            : CircularProgressIndicator(),
      ),
    );
  }
}
