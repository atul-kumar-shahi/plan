import 'dart:convert';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../models/income_expense_model.dart';
import '../../Data/income_expense.dart';

Future<void> loadIncomesFromStorage(FlutterSecureStorage storage, Function(List<IncomeCategory>) callback) async {
  String? allIncomesJson = await storage.read(key: 'allIncomes');
  if (allIncomesJson != null) {
    List<dynamic> jsonData = jsonDecode(allIncomesJson);
    List<IncomeCategory> categories = jsonData.map((category) {
      List<Income> incomes = (category['incomes'] as List).map((income) {
        return Income(
            description: income['description'],
            amount: income['amount'],
            additionalInfo: income['additionalInfo'],
            date: income['date'],
            repeating: income['repeating'],
            parent: income['parent']);
      }).toList();
      return IncomeCategory(name: category['name'], incomes: incomes);
    }).toList();
    callback(categories);
  } else {
    callback([]);
  }
}

Future<void> loadExpensesFromStorage(FlutterSecureStorage storage, Function(List<ExpenseCategory>) callback) async {
  String? allExpensesJson = await storage.read(key: 'allExpenses');
  if (allExpensesJson != null) {
    List<dynamic> jsonData = jsonDecode(allExpensesJson);
    List<ExpenseCategory> categories = jsonData.map((category) {
      List<Expense> expenses = (category['expenses'] as List).map((expense) {
        return Expense(
            description: expense['description'],
            amount: expense['amount'],
            additionalInfo: expense['additionalInfo'],
            date: expense['date'],
            repeating: expense['repeating'],
            parent: expense['parent']);
      }).toList();
      return ExpenseCategory(name: category['name'], expenses: expenses);
    }).toList();
    callback(categories);
  } else {
    callback([]);
  }
}

Future<void> saveIncomesToStorage(FlutterSecureStorage storage, AllIncomes allIncomes) async {
  String allIncomesJson = jsonEncode(allIncomes.categories.map((category) {
    return {
      'name': category.name,
      'incomes': category.incomes.map((income) {
        return {
          'description': income.description,
          'amount': income.amount,
          'additionalInfo': income.additionalInfo,
          'date': income.date,
          'repeating': income.repeating,
          'parent': income.parent
        };
      }).toList()
    };
  }).toList());
  await storage.write(key: 'allIncomes', value: allIncomesJson);
}

Future<void> saveExpensesToStorage(FlutterSecureStorage storage, AllExpenses allExpenses) async {
  String allExpensesJson = jsonEncode(allExpenses.categories.map((category) {
    return {
      'name': category.name,
      'expenses': category.expenses.map((expense) {
        return {
          'description': expense.description,
          'amount': expense.amount,
          'additionalInfo': expense.additionalInfo,
          'date': expense.date,
          'repeating': expense.repeating,
          'parent': expense.parent
        };
      }).toList()
    };
  }).toList());
  await storage.write(key: 'allExpenses', value: allExpensesJson);
}
