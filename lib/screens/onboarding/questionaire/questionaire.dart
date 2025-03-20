import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:plan/screens/onboarding/questionaire/questionaire_form.dart';

import '../../auth/secure_storage.dart';
import '../../home/home.dart'; // For making POST requests

const String API_URL = "your_api_endpoint";

class QuestionaireScreen extends StatefulWidget {
  @override
  _QuestionaireScreenState createState() => _QuestionaireScreenState();
}

class _QuestionaireScreenState extends State<QuestionaireScreen> {
  int _currentPage = 0; // Keeps track of current question page
  final _formKey = GlobalKey<FormState>(); // Form key for validation
  List<String> _answers = List.filled(4, ""); // Stores user answers for 4 questions

  // Define your answer options for each multiple-choice question
  final List<List<String>> _multipleChoiceOptions = [
    ["Comfortable", "Living paycheck to paycheck", "Saving for a specific goal"],
    ["Building an emergency fund", "Paying off debt", "Saving for retirement"],
    ["Very risk-averse", "Somewhat risk-tolerant", "Comfortable with high-risk investments"],
    ["Budgeting apps", "Spreadsheets", "Manual tracking"],
  ];

  // Define empty strings for optional open-ended questions
  String _biggestChallenge = "";
  String _additionalInfo = "";

  // Function to handle user selection on multiple choice questions
  void _handleSelection(String answer) {
    setState(() {
      _answers[_currentPage] = answer;
    });
  }

  // Function to handle form submission (optional questions)
  void _submitAnswers() async {
    if (_formKey.currentState!.validate()) {
      _formKey.currentState!.save();

      // Prepare data for API call
      Map<String, dynamic> data = {
        "financial_situation": _answers[0],
        "financial_goals": _answers[1],
        "risk_tolerance": _answers[2],
        "management_method": _answers[3],
        "biggest_challenge": _biggestChallenge,
        "additional_info": _additionalInfo,
      };

      // Send POST request to our API endpoint (NOT YET IMPLEMENTED)
      try {
        var response = await http.post(
          Uri.parse(API_URL),
          headers: {'Content-Type': 'application/json'},
          body: jsonEncode(data),
        );

        if (response.statusCode == 200) {
          print("Answers submitted successfully!");
          // NEXT LOGIC HERE
        } else {
          print("Error submitting answers: ${response.statusCode}");
        }
      } catch (e) {
        print("Network error: $e");
      }
    }
  }

  // Function to check if all mandatory questions are answered
  bool _allMandatoryAnswered() {
    return !_answers.contains("");
  }

  // Function to check if the current question has been answered
  bool _isCurrentQuestionAnswered() {
    return _answers[_currentPage].isNotEmpty;
  }

  // Function to handle "Next" button press
  void _nextPage() {
    if (_currentPage < _multipleChoiceOptions.length) {
      if (_isCurrentQuestionAnswered()) {
        setState(() {
          _currentPage++;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Financial Onboarding"),
      ),
      body: Padding(
        padding: const EdgeInsets.all(20.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              // Progress indicator
              LinearProgressIndicator(
                value: _currentPage / (_multipleChoiceOptions.length + 1),
              ),
              SizedBox(height: 20.0),

              // Question Text
              Text(
                _currentPage < _multipleChoiceOptions.length
                    ? "Question ${_currentPage + 1} of ${_multipleChoiceOptions.length}"
                    : "Optional Questions",
                style: TextStyle(fontSize: 18.0, fontWeight: FontWeight.bold),
              ),

              // Multiple Choice Question (if applicable)
              if (_currentPage < _multipleChoiceOptions.length)
                Column(
                  children: [
                    for (var option in _multipleChoiceOptions[_currentPage])
                      RadioListTile(
                        title: Text(option),
                        value: option,
                        groupValue: _answers[_currentPage],
                        onChanged: (value) => _handleSelection(value!),
                      ),
                  ],
                ),

              // Open Ended Question (if applicable)
              if (_currentPage == _multipleChoiceOptions.length)
                if (_currentPage == _multipleChoiceOptions.length)
                  QuestionaireForm(
                    formKey: _formKey,
                    biggestChallenge: _biggestChallenge,
                    additionalInfo: _additionalInfo,
                    onBiggestChallengeChanged: (value) => setState(() => _biggestChallenge = value),
                    onAdditionalInfoChanged: (value) => setState(() => _additionalInfo = value),
                    onSubmit: _submitAnswers,
                  ),

              // Navigation buttons
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  // "Back" button
                  if (_currentPage > 0 && _currentPage < _multipleChoiceOptions.length)
                    ElevatedButton(
                      onPressed: () {
                        setState(() {
                          _currentPage--;
                        });
                      },
                      child: Text("Back"),
                    ),
                  // "Skip" button for optional questions
                  if (_currentPage == _multipleChoiceOptions.length)
                    TextButton(
                      onPressed: () async {

                        await secureStorage.write(key: 'questionaire', value: 'complete');
                        print(await secureStorage.read(key: 'questionaire')); //test
                        print(await secureStorage.read(key: 'onboarding')); //test


                        Navigator.pushReplacement(
                        context,
                        MaterialPageRoute(builder: (context) => Home()), // Replace with your home screen route
                      );},
                      child: Text("Skip Optional Questions"),
                    ),
                  Spacer(),
                  // "Next" button for mandatory questions
                  if (_currentPage < _multipleChoiceOptions.length)
                    ElevatedButton(
                      onPressed: _isCurrentQuestionAnswered() ? _nextPage : null,
                      child: Text(_currentPage < _multipleChoiceOptions.length - 1 ? "Next" : "Continue"),
                    ),
                ],
              ),

            ],
          ),
        ),
      ),
    );
  }
}