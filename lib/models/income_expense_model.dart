class Income {
  final String description;
  final double amount;
  final String additionalInfo;
  final String date;
  final String repeating;
  final String parent; // store the name of the IncomeCategory

  Income({
    required this.description,
    required this.amount,
    required this.additionalInfo,
    required this.date,
    required this.repeating,
    required this.parent
  });

  @override
  String toString() {
    return 'Income(description: $description, amount: $amount, additionalInfo: $additionalInfo, date: $date, repeating: $repeating, parent: $parent)';
  }
}

class Expense {
  final String description;
  final double amount;
  final String additionalInfo;
  final String date;
  final String repeating;
  final String parent; // store the name of the ExpenseCategory

  Expense({
    required this.description,
    required this.amount,
    required this.additionalInfo,
    required this.date,
    required this.repeating,
    required this.parent
  });

  @override
  String toString() {
    return 'Expense(description: $description, amount: $amount, additionalInfo: $additionalInfo, date: $date, repeating: $repeating, parent: $parent)';
  }
}