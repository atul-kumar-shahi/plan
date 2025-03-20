import 'package:flutter/material.dart';
import 'package:google_sign_in/google_sign_in.dart';
import 'package:http/http.dart' as http;
import 'package:plan/screens/home/home.dart';
import 'package:plan/screens/onboarding/on_boarding.dart';
import 'package:plan/screens/other/permissionScreen.dart';
import 'dart:convert';
import '../onboarding/questionaire/questionaire.dart';
import 'secure_storage.dart'; // Import the secure storage implementation

class AuthScreen extends StatelessWidget {
  const AuthScreen({Key? key});

  Future<void> _handleSignIn(BuildContext context) async {
    try {
      // Initialize GoogleSignIn with required scopes and server client ID
      final _googleSignIn = GoogleSignIn(
        scopes: [
          'email',
          'https://www.googleapis.com/auth/userinfo.profile',
          'openid',
        ],
        serverClientId:
            '180610885511-l96rtfbkh1ucdlsmgnaue8or4ujm7k98.apps.googleusercontent.com', // Replace with your Web Client ID
      );

      // Attempt to sign out any existing user
      await _googleSignIn.signOut();

      // Attempt Google Sign-In
      final GoogleSignInAccount? account = await _googleSignIn.signIn();

      if (account != null) {
        // Retrieve authentication details (ID token) from Google Sign-In
        final GoogleSignInAuthentication googleAuth =
            await account.authentication;
        final idToken = googleAuth.idToken;
        print("ID Token: $idToken");

        // Perform server-side validation of the ID token (optional)
        final response = await http.post(
          Uri.parse('https://researchrealm.world/auth/google/callback'),
          body: jsonEncode({'idToken': idToken}),
          headers: {'Content-Type': 'application/json'},
        );

        // Debug print to check server response
        print("Server Response: ${response.body}");

        if (response.statusCode == 200) {
          // Token validation successful, parse response and handle accordingly
          final data = jsonDecode(response.body);
          final token = data['token'];
          final isNew = data['isNew'];

          SecureStorage secureStorage = SecureStorage();

          // Storing token and isNew values
          await secureStorage.write(key: 'token', value: token.toString());
          await secureStorage.write(key: 'isNew', value: isNew.toString());

          // Debug prints to verify values
          String? storedToken = await secureStorage.read(key: 'token');
          print("Stored Token: $storedToken");
          String? storedIsNew = await secureStorage.read(key: 'isNew');
          print("Stored isNew: $storedIsNew");
          String? onboarding = await secureStorage.read(key: 'onboarding');
          String? questionaire = await secureStorage.read(key: 'questionaire');

          // Navigate to appropriate screen based on isNew value
          if (storedIsNew == 'true') {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(
                builder: (context) {
                  print("Navigating to Permission Screen");
                  return permissionScreen();
                },
              ),
            );
          } else {
            // Make the additional API call here
            final additionalResponse = await http.get(
              Uri.parse(
                  'https://researchrealm.world/user'), // Replace with your actual API URL
              headers: {
                'Authorization': await secureStorage.read(key: 'token'),
              },
            );

            if (additionalResponse.statusCode == 200) {
              final additionalData = jsonDecode(additionalResponse.body);
              print("additional data: $additionalData");
              // Extract required values
              final birthdate = additionalData['birthdate'];
              final gender = additionalData['gender'];
              final employmentStatus = additionalData['employment_status'];
              final livingStatus = additionalData['living_status'];

              // Check if any of the required values are null
              if (birthdate == 'NA' ||
                  gender == 'NA' ||
                  employmentStatus == 'NA' ||
                  livingStatus == 'NA') {
                print("Navigating to Onboarding Screen");
                Navigator.of(context).pushReplacement(
                  MaterialPageRoute(builder: (context) => OnboardingScreen()),
                );
              } else {
                await secureStorage.write(key: 'onboarding', value: 'complete');

                if (questionaire == 'complete') {
                  await secureStorage.write(
                      key: 'questionaire', value: 'complete');
                  Navigator.of(context).pushReplacement(
                      MaterialPageRoute(builder: (context) => Home()));
                } else {
                  Navigator.of(context).pushReplacement(MaterialPageRoute(
                      builder: (context) => QuestionaireScreen()));
                }
              }
            } else {
              // Handle API call failure
              print(
                  "API call failed with status: ${additionalResponse.statusCode}");
              ScaffoldMessenger.of(context).showSnackBar(
                SnackBar(content: Text('Failed to check onboarding status')),
              );
            }
          }
        } else {
          // Token validation failed, show error message
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(content: Text('Token validation failed')),
          );
        }
      } else {
        // User canceled Google Sign-In, do nothing
        print("Google Sign-In canceled by user.");
      }
    } catch (error) {
      // Handle errors
      print("Sign in failed with error: $error");
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Sign in failed: $error')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Center(
        child: ElevatedButton(
          onPressed: () => _handleSignIn(context),
          child: Text('Sign in with Google'),
        ),
      ),
    );
  }
}
