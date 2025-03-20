import 'package:flutter/material.dart';

class BottomSheetButtons extends StatelessWidget {
  final String selectedType;
  final VoidCallback addIncome;
  final VoidCallback addExpense;

  const BottomSheetButtons({
    required this.selectedType,
    required this.addIncome,
    required this.addExpense,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.spaceBetween,
        children: [
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.black,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () {
              selectedType == 'Income' ? addIncome() : addExpense();
            },
            child: Text(
              'Add',
              style: TextStyle(color: Colors.white),
            ),
          ),
          ElevatedButton(
            style: ElevatedButton.styleFrom(
              backgroundColor: Colors.grey.shade200,
              shape: RoundedRectangleBorder(
                borderRadius: BorderRadius.circular(8),
              ),
            ),
            onPressed: () {
              Navigator.pop(context);
            },
            child: Text('Cancel', style: TextStyle(color: Colors.black)),
          ),
        ],
      ),
    );
  }
}
