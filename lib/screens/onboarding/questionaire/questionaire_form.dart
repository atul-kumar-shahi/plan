// questionaire_form.dart
import 'package:flutter/material.dart';

class QuestionaireForm extends StatelessWidget {
  final GlobalKey<FormState> formKey;
  final String biggestChallenge;
  final String additionalInfo;
  final Function(String) onBiggestChallengeChanged;
  final Function(String) onAdditionalInfoChanged;
  final VoidCallback onSubmit;

  const QuestionaireForm({
    Key? key,
    required this.formKey,
    required this.biggestChallenge,
    required this.additionalInfo,
    required this.onBiggestChallengeChanged,
    required this.onAdditionalInfoChanged,
    required this.onSubmit,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Form(
      key: formKey,
      child: Column(
        children: [
          TextFormField(
            decoration: InputDecoration(labelText: "Describe your biggest financial challenge"),
            validator: (value) => value == null || value.isEmpty ? "Please enter your biggest challenge" : null,
            onChanged: onBiggestChallengeChanged,
          ),
          TextFormField(
            decoration: InputDecoration(labelText: "Is there anything else you'd like Plan Friend to know?"),
            onChanged: onAdditionalInfoChanged,
          ),
          SizedBox(height: 10),
          ElevatedButton(
            onPressed: onSubmit,
            child: Text("Submit Answers"),
          ),
        ],
      ),
    );
  }
}
