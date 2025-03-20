import 'dart:convert';

import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:lottie/lottie.dart';
import 'package:plan/screens/onboarding/questionaire/questionaire.dart';
import 'package:plan/screens/onboarding/user_service.dart';
import '../../widgets/custom_dropdown.dart';
import '../auth/secure_storage.dart';

class IntroScreen extends StatefulWidget {
  @override
  State<IntroScreen> createState() => _IntroScreenState();
}

class _IntroScreenState extends State<IntroScreen> {
  final _formKey = GlobalKey<FormState>();

  DateTime? _selectedDate;
  String? _selectedGender;
  String? _selectedLivingStatus;
  String? _selectedEmploymentStatus;

  SecureStorage secureStorage = SecureStorage();

  List<String> gender = ['Male', 'Female', 'Other'];
  List<String> livingStatus = ['Single', 'Married', 'Divorced', 'Widowed'];
  List<String> employmentStatus = [
    'Employed',
    'Unemployed',
    'Student',
    'Retired'
  ];

  Future<void> _selectDate(BuildContext context) async {
    final DateTime? picked = await showDatePicker(
      context: context,
      initialDate: _selectedDate ?? DateTime.now(),
      firstDate: DateTime(1920, 1, 1),
      lastDate: DateTime.now(),
      builder: (BuildContext context, Widget? child) {
        return Theme(
          data: ThemeData.light().copyWith(
            colorScheme: ColorScheme.light(
              primary: Colors.black, // Header background color
              onPrimary: Colors.white, // Header text color
              surface: Colors.grey[200]!, // Background color (light grey)
              onSurface: Colors.black, // Text color
            ),
            dialogBackgroundColor: Colors.grey[300]!, // Dialog background color
          ),
          child: child!,
        );
      },
    );

    if (picked != null && picked != _selectedDate) {
      setState(() {
        _selectedDate = picked;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      body: SafeArea(
        child: Stack(
          children: [
            Column(
              children: [
                Padding(
                  padding: const EdgeInsets.all(8.0),
                  child: Row(
                    children: [
                      Text(
                        'Tell us about yourself',
                        style: TextStyle(
                          color: Colors.black,
                          fontWeight: FontWeight.bold,
                          fontSize: 17,
                        ),
                      ),
                    ],
                  ),
                ),
                SizedBox(height: 10),
                Expanded(
                  child: SingleChildScrollView(
                    child: Container(
                      child: Column(
                        children: [
                          Container(
                            decoration: BoxDecoration(
                              color: Colors.white,
                              borderRadius:
                                  BorderRadius.all(Radius.circular(20)),
                            ),
                            child: Padding(
                              padding: const EdgeInsets.all(12.0),
                              child: Form(
                                key: _formKey,
                                child: Column(
                                  crossAxisAlignment: CrossAxisAlignment.start,
                                  children: <Widget>[
                                    Padding(
                                      padding: const EdgeInsets.all(8.0),
                                      child: Column(
                                        crossAxisAlignment:
                                            CrossAxisAlignment.start,
                                        children: [
                                          Padding(
                                            padding: const EdgeInsets.all(4.0),
                                            child: Text(
                                              'Date of Birth',
                                              style: TextStyle(
                                                  fontWeight: FontWeight.bold,
                                                  color: Color(0xFF29292B)),
                                            ),
                                          ),
                                          TextFormField(
                                            decoration: InputDecoration(
                                              filled: true,
                                              fillColor: Colors.transparent,
                                              hintText: 'Date of Birth',
                                              hintStyle: TextStyle(
                                                  color: Color(0xFF8F8E93)),
                                              border: OutlineInputBorder(
                                                borderRadius: BorderRadius.all(
                                                    Radius.circular(10.0)),
                                              ),
                                            ),
                                            readOnly: true,
                                            onTap: () => _selectDate(context),
                                            validator: (value) {
                                              if (_selectedDate == null) {
                                                return 'Please select your date of birth';
                                              }
                                              return null;
                                            },
                                            controller: TextEditingController(
                                              text: _selectedDate == null
                                                  ? ''
                                                  : "${_selectedDate!.toLocal()}"
                                                      .split(' ')[0],
                                            ),
                                            style: TextStyle(
                                                color: Color(0xFF8F8E93)),
                                          ),
                                        ],
                                      ),
                                    ),
                                    CustomDropdown(
                                      label: 'Gender',
                                      items: gender,
                                      selectedValue: _selectedGender,
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          _selectedGender = newValue;
                                        });
                                      },
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please select your gender';
                                        }
                                        return null;
                                      },
                                    ),
                                    CustomDropdown(
                                      label: 'Living Status',
                                      items: livingStatus,
                                      selectedValue: _selectedLivingStatus,
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          _selectedLivingStatus = newValue;
                                        });
                                      },
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please select your living status';
                                        }
                                        return null;
                                      },
                                    ),
                                    CustomDropdown(
                                      label: 'Employment Status',
                                      items: employmentStatus,
                                      selectedValue: _selectedEmploymentStatus,
                                      onChanged: (String? newValue) {
                                        setState(() {
                                          _selectedEmploymentStatus = newValue;
                                        });
                                      },
                                      validator: (value) {
                                        if (value == null || value.isEmpty) {
                                          return 'Please select your employment status';
                                        }
                                        return null;
                                      },
                                    ),
                                    SizedBox(height: 20),
                                    Center(
                                      child: SizedBox(
                                        height: 50,
                                        width: 250,
                                        child: ElevatedButton(
                                          onPressed: () async {
                                            if (_formKey.currentState!
                                                .validate()) {
                                              ScaffoldMessenger.of(context)
                                                  .showSnackBar(
                                                SnackBar(
                                                    content: Text(
                                                        'Processing Data')),
                                              );

                                              DateTime? DOB = _selectedDate;
                                              String? gender = _selectedGender;
                                              String? employmentStatus =
                                                  _selectedEmploymentStatus;
                                              String? livingStatus =
                                                  _selectedLivingStatus;

                                              await UserService
                                                  .updateUserDetails(
                                                context,
                                                // Pass the context to the function
                                                DOB,
                                                gender,
                                                employmentStatus,
                                                livingStatus,
                                              );
                                            }
                                          },
                                          child: Text(
                                            'Lets Plan',
                                            style: TextStyle(
                                              fontSize: 20,
                                              fontWeight: FontWeight.bold,
                                            ),
                                          ),
                                          style: ElevatedButton.styleFrom(
                                            backgroundColor: Colors.green,
                                            foregroundColor: Colors.white,
                                            shape: RoundedRectangleBorder(
                                              borderRadius:
                                                  BorderRadius.circular(10),
                                            ),
                                          ),
                                        ),
                                      ),
                                    ),
                                  ],
                                ),
                              ),
                            ),
                          ),
                          SizedBox(
                              height:
                                  20), // Adjust the spacing to avoid overlapping
                        ],
                      ),
                    ),
                  ),
                ),
              ],
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Image.asset(
                'assets/animations/Clip path group.png',
                width: MediaQuery.of(context).size.width,
                color: Colors.black45,
              ),
            ),
            Positioned(
              bottom: 0,
              left: 0,
              right: 0,
              child: Center(
                child: Lottie.asset(
                  'assets/animations/onboardingAnimation.json',
                  repeat: false,
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
