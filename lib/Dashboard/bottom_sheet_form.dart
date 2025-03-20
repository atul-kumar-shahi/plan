import 'package:flutter/material.dart';
import '../../Data/income_expense.dart';
import '../../widgets/custom_incomeform.dart';

class BottomSheetForm extends StatelessWidget {
  final String selectedType;
  final TextEditingController descriptionController;
  final TextEditingController amountController;
  final TextEditingController dateController;
  final TextEditingController repeatingController;
  final TextEditingController parentController;
  final AllIncomes allIncomes;
  final AllExpenses allExpenses;
  final Function(String) handleCategorySelected;
  final StateSetter setModalState;
  final Function(String) onSelectedTypeChange;

  const BottomSheetForm({
    required this.selectedType,
    required this.descriptionController,
    required this.amountController,
    required this.dateController,
    required this.repeatingController,
    required this.parentController,
    required this.allIncomes,
    required this.allExpenses,
    required this.handleCategorySelected,
    required this.setModalState,
    required this.onSelectedTypeChange,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          mainAxisAlignment: MainAxisAlignment.spaceEvenly,
          children: [
            SizedBox(
              height: 50,
              width: 150,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: selectedType == 'Income'
                      ? Colors.green
                      : Colors.grey.shade200,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  onSelectedTypeChange('Income');
                },
                child: Text(
                  'Income',
                  style: TextStyle(
                    color: selectedType == 'Income'
                        ? Colors.white
                        : Colors.black,
                  ),
                ),
              ),
            ),
            SizedBox(
              height: 50,
              width: 150,
              child: ElevatedButton(
                style: ElevatedButton.styleFrom(
                  backgroundColor: selectedType == 'Expense'
                      ? Colors.red
                      : Colors.grey.shade200,
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                onPressed: () {
                  onSelectedTypeChange('Expense');
                },
                child: Text(
                  'Expense',
                  style: TextStyle(
                    color: selectedType == 'Expense'
                        ? Colors.white
                        : Colors.black,
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 20),
        TextFormField(
          controller: descriptionController,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.transparent,
            hintText: 'Salary, Bonus, Savings etc.',
            hintStyle: TextStyle(color: Color(0xFF8F8E93)),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
            ),
          ),
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Enter a description';
            }
            return null;
          },
        ),
        SizedBox(height: 15),
        TextFormField(
          controller: amountController,
          decoration: InputDecoration(
            filled: true,
            fillColor: Colors.transparent,
            hintText: 'Enter amount',
            hintStyle: TextStyle(color: Color(0xFF8F8E93)),
            border: OutlineInputBorder(
              borderRadius: BorderRadius.all(Radius.circular(10.0)),
            ),
          ),
          keyboardType: TextInputType.number,
          validator: (value) {
            if (value == null || value.isEmpty) {
              return 'Please enter an amount';
            }
            if (double.tryParse(value) == null) {
              return 'Please enter a valid number';
            }
            return null;
          },
        ),
        SizedBox(height: 15),
        Row(
          children: [
            Text(
              'Add more information',
              style: TextStyle(fontWeight: FontWeight.bold),
            ),
          ],
        ),
        SizedBox(height: 5),
        IncomeForm(
          categoryNames: selectedType == 'Income'
              ? allIncomes.categories.map((c) => c.name).toList()
              : allExpenses.categories.map((c) => c.name).toList(),
          onCategorySelected: handleCategorySelected,
          selectedState: selectedType,
        ),
        SizedBox(height: 15),
        Row(
          children: [
            Expanded(
              child: TextFormField(
                controller: dateController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.transparent,
                  hintText: 'DD/MM/YYYY',
                  hintStyle: TextStyle(color: Color(0xFF8F8E93)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                ),
              ),
            ),
            SizedBox(width: 10),
            Expanded(
              child: TextFormField(
                controller: repeatingController,
                decoration: InputDecoration(
                  filled: true,
                  fillColor: Colors.transparent,
                  hintText: 'Repeating',
                  hintStyle: TextStyle(color: Color(0xFF8F8E93)),
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.all(Radius.circular(10.0)),
                  ),
                ),
              ),
            ),
          ],
        ),
        SizedBox(height: 30),
      ],
    );
  }
}
