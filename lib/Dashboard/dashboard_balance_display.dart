import 'package:flutter/material.dart';
import '../../Data/income_expense.dart';

class BalanceDisplay extends StatelessWidget {
  final double totalIncome;
  final double totalExpense;

  BalanceDisplay({
    required this.totalIncome,
    required this.totalExpense,
  });

  double getBalance() {
    return totalIncome - totalExpense;
  }

  @override
  Widget build(BuildContext context) {
    return Text(
      getBalance().toStringAsFixed(2),
      style: const TextStyle(fontSize: 40, fontWeight: FontWeight.bold),
    );
  }
}

double getTotalIncome(AllIncomes allIncomes) {
  double totalIncome = 0.0;
  for (var category in allIncomes.categories) {
    for (var income in category.incomes) {
      totalIncome += income.amount;
    }
  }
  return totalIncome;
}

double getTotalExpense(AllExpenses allExpenses) {
  double totalExpense = 0.0;
  for (var category in allExpenses.categories) {
    for (var expense in category.expenses) {
      totalExpense += expense.amount;
    }
  }
  return totalExpense;
}
