import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:plan/screens/onboarding/questionaire/questionaire.dart';

import '../auth/secure_storage.dart';
import 'package:http/http.dart' as http;

class UserService {
 static Future<void> updateUserDetails(BuildContext context, DateTime? DOB, String? gender,
      String? employment_status, String? living_status) async {
    final String token = await secureStorage.read(key: 'token');
    final response = await http.put(
      Uri.parse('https://researchrealm.world/user/update'),
      headers: {
        'Content-Type': 'application/json',
        'Authorization': token,
      },
      body: jsonEncode({
        'birthdate': DOB!.toIso8601String(),
        'gender': gender,
        'living_status': living_status,
        'employment_status': employment_status,
      }),
    );

    if (response.statusCode == 200) {
      // Successfully updated
      final updatedUser = jsonDecode(response.body);
      print('User updated: $updatedUser');
      await secureStorage.write(key: 'onboarding', value: 'complete');
      print(await secureStorage.read(key: 'onboarding')); // test

      // Navigate to QuestionaireScreen
      Navigator.pushReplacement(
        context,
        MaterialPageRoute(builder: (context) => QuestionaireScreen()),
      );
    } else {
      // Error occurred
      print('Failed to update user: ${response.reasonPhrase}');
    }
  }
}