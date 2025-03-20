import 'package:flutter/material.dart';
import '../Data/income_expense.dart';
import 'category_list_tile.dart';

class IncomeExpenseListView extends StatefulWidget {
  final AllIncomes allIncomes;
  final AllExpenses allExpenses;

  IncomeExpenseListView({required this.allIncomes, required this.allExpenses});

  @override
  _IncomeExpenseListViewState createState() => _IncomeExpenseListViewState();
}

class _IncomeExpenseListViewState extends State<IncomeExpenseListView> {
  @override
  Widget build(BuildContext context) {
    return DefaultTabController(
      length: 2,
      child: Scaffold(
        backgroundColor: Colors.white,
        body: Column(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 15.0),
              child: TabBar(
                indicatorColor: Colors.black,
                indicatorSize: TabBarIndicatorSize.tab,
                labelColor: Colors.black,
                labelStyle: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.bold,
                ),
                tabs: [
                  Tab(text: 'Income'),
                  Tab(text: 'Expense'),
                ],
              ),
            ),
            Expanded(
              child: TabBarView(
                children: [
                  // Income view
                  ListView.builder(
                    itemCount: widget.allIncomes.categories.length,
                    itemBuilder: (BuildContext context, int index) {
                      final incomeCategory = widget.allIncomes.categories[index];
                      return CategoryListTile(
                        category: incomeCategory,
                        isIncome: true,
                        onDeleteCategory: () {
                          setState(() {
                            widget.allIncomes.categories.removeAt(index);
                          });
                        },
                        onDeleteItem: (income) {
                          setState(() {
                            incomeCategory.incomes.remove(income);
                          });
                        },
                        onEditCategoryName: (newName) {
                          setState(() {
                            incomeCategory.categoryName = newName;
                          });
                        },
                      );
                    },
                  ),
                  // Expense view
                  ListView.builder(
                    itemCount: widget.allExpenses.categories.length,
                    itemBuilder: (BuildContext context, int index) {
                      final expenseCategory = widget.allExpenses.categories[index];
                      return CategoryListTile(
                        category: expenseCategory,
                        isIncome: false,
                        onDeleteCategory: () {
                          setState(() {
                            widget.allExpenses.categories.removeAt(index);
                          });
                        },
                        onDeleteItem: (expense) {
                          setState(() {
                            expenseCategory.expenses.remove(expense);
                          });
                        },
                        onEditCategoryName: (newName) {
                          setState(() {
                            expenseCategory.categoryName = newName;
                          });
                        },
                      );
                    },
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
