import '../models/income_expense_model.dart';

class IncomeCategory {
  String name;
  List<Income> incomes;

  IncomeCategory({
    required this.name,
    required this.incomes,
  });

  // Setter for name
  set categoryName(String newName) {
    this.name = newName;
  }

  @override
  String toString() {
    return 'IncomeCategory(name: $name, incomes: $incomes)';
  }
}

class ExpenseCategory {
  String name;
  List<Expense> expenses;

  ExpenseCategory({
    required this.name,
    required this.expenses,
  });

  // Setter for name
  set categoryName(String newName) {
    this.name = newName;
  }

  @override
  String toString() {
    return 'ExpenseCategory(name: $name, expenses: $expenses)';
  }
}



class AllIncomes{
  final List<IncomeCategory> categories;

  AllIncomes({
    required this.categories
  });

  void addIncome(String categoryName, Income income) {
    for (var category in categories) {
      if (category.name == categoryName) {
        category.incomes.add(income);
        return;
      }
    }
    // If the category does not exist, you might want to create it
    categories.add(IncomeCategory(name: categoryName, incomes: [income]));
  }

  List<Income> getIncomes(String categoryName) {
    for (var category in categories) {
      if (category.name == categoryName) {
        return category.incomes;
      }
    }
    return [];
  }
}

class AllExpenses{
  final List<ExpenseCategory> categories;

  AllExpenses({
    required this.categories
  });

  void addExpense(String categoryName, Expense expense) {
    for (var category in categories) {
      if (category.name == categoryName) {
        category.expenses.add(expense);
        return;
      }
    }
    // If the category does not exist, you might want to create it
    categories.add(ExpenseCategory(name: categoryName, expenses: [expense]));
  }

  List<Expense> getExpenses(String categoryName) {
    for (var category in categories) {
      if (category.name == categoryName) {
        return category.expenses;
      }
    }
    return [];
  }
}