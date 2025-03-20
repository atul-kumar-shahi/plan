import 'package:flutter/material.dart';
import '../../Data/income_expense.dart';
import '../../models/income_expense_model.dart';
import 'bottom_sheet_button.dart';
import 'bottom_sheet_form.dart';

class DashboardBottomSheet extends StatefulWidget {
  final String selectedType;
  final AllIncomes allIncomes;
  final AllExpenses allExpenses;
  final Function(String) onCategorySelected;
  final Function(Income) addIncome;
  final Function(Expense) addExpense;

  const DashboardBottomSheet({
    super.key,
    required this.selectedType,
    required this.allIncomes,
    required this.allExpenses,
    required this.onCategorySelected,
    required this.addIncome,
    required this.addExpense,
  });

  @override
  _DashboardBottomSheetState createState() => _DashboardBottomSheetState();
}

class _DashboardBottomSheetState extends State<DashboardBottomSheet> {
  late String _selectedType;
  final _incomeFormKey = GlobalKey<FormState>();
  final _descriptionController = TextEditingController();
  final _amountController = TextEditingController();
  final _additionalInfoController = TextEditingController();
  final _dateController = TextEditingController();
  final _repeatingController = TextEditingController();
  final _parentController = TextEditingController();

  @override
  void initState() {
    super.initState();
    _selectedType = widget.selectedType;
  }

  void _clearFormFields() {
    _descriptionController.clear();
    _amountController.clear();
    _additionalInfoController.clear();
    _dateController.clear();
    _repeatingController.clear();
    _parentController.clear();
  }

  void _handleCategorySelected(String categoryName) {
    setState(() {
      widget.onCategorySelected(categoryName);
    });
    _parentController.text = categoryName;
  }

  void _addIncome() {
    if (_incomeFormKey.currentState!.validate() && _parentController.text.isNotEmpty) {
      final income = Income(
        description: _descriptionController.text,
        amount: double.parse(_amountController.text),
        additionalInfo: _additionalInfoController.text,
        date: _dateController.text,
        repeating: _repeatingController.text,
        parent: _parentController.text,
      );
      widget.addIncome(income);
      _clearFormFields();
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select a category')),
      );
    }
  }

  void _addExpense() {
    if (_incomeFormKey.currentState!.validate() && _parentController.text.isNotEmpty) {
      final expense = Expense(
        description: _descriptionController.text,
        amount: double.parse(_amountController.text),
        additionalInfo: _additionalInfoController.text,
        date: _dateController.text,
        repeating: _repeatingController.text,
        parent: _parentController.text,
      );
      widget.addExpense(expense);
      _clearFormFields();
      Navigator.pop(context);
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please select a category')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return FractionallySizedBox(
      heightFactor: 0.6,
      child: StatefulBuilder(
        builder: (BuildContext context, StateSetter setModalState) {
          return Stack(
            children: [
              Padding(
                padding: const EdgeInsets.all(16.0),
                child: Form(
                  key: _incomeFormKey,
                  child: Column(
                    children: [
                      Container(
                        margin: EdgeInsets.symmetric(vertical: 10.0),
                        width: 40,
                        height: 5,
                        decoration: BoxDecoration(
                          color: Colors.black,
                          borderRadius: BorderRadius.circular(10),
                        ),
                      ),
                      Expanded(
                        child: SingleChildScrollView(
                          child: BottomSheetForm(
                            selectedType: _selectedType,
                            descriptionController: _descriptionController,
                            amountController: _amountController,
                            dateController: _dateController,
                            repeatingController: _repeatingController,
                            parentController: _parentController,
                            allIncomes: widget.allIncomes,
                            allExpenses: widget.allExpenses,
                            handleCategorySelected: _handleCategorySelected,
                            setModalState: setModalState,
                            onSelectedTypeChange: (String newType) {
                              setModalState(() {
                                _selectedType = newType;
                              });
                            },
                          ),
                        ),
                      ),
                    ],
                  ),
                ),
              ),
              Align(
                alignment: Alignment.bottomCenter,
                child: BottomSheetButtons(
                  selectedType: _selectedType,
                  addIncome: _addIncome,
                  addExpense: _addExpense,
                ),
              ),
            ],
          );
        },
      ),
    );
  }
}
