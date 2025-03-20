import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:mockito/mockito.dart';
import 'package:plan/screens/auth/auth.dart';
import 'package:plan/screens/home/home.dart';
import 'package:plan/screens/other/splash.dart'; // Adjust the import according to your file structure

import 'mocks/shared_preferences_mock.mocks.dart';

void main() {
  TestWidgetsFlutterBinding.ensureInitialized();

  group('SplashScreen Test', () {
    late MockSharedPreferences mockSharedPreferences;

    setUp(() {
      mockSharedPreferences = MockSharedPreferences();
    });

    testWidgets('should navigate to SignUpScreen when user is not logged in', (WidgetTester tester) async {
      // Arrange
      when(mockSharedPreferences.getBool('loggedIn')).thenReturn(false);

      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: SplashScreen(),
        ),
      );

      // Simulate the passage of time
      await tester.pump(const Duration(milliseconds: 1000));

      // Assert
      expect(find.byType(AuthScreen), findsOneWidget);
    });

    testWidgets('should navigate to HomeScreen when user is logged in', (WidgetTester tester) async {
      // Arrange
      when(mockSharedPreferences.getBool('loggedIn')).thenReturn(true);

      // Act
      await tester.pumpWidget(
        const MaterialApp(
          home: SplashScreen(),
        ),
      );

      // Simulate the passage of time
      await tester.pump(const Duration(milliseconds: 500));

      // Assert
      expect(find.byType(Home), findsOneWidget);
    });
  });
}
