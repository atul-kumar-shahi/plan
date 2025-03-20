import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import '../../Dashboard/dashboard_balance_display.dart';
import '../../Dashboard/load_dashboard_data.dart';
import 'profile.dart';
import '../../Data/income_expense.dart';
import '../../models/income_expense_model.dart';
import '../../widgets/custom_calendar.dart';
import '../../Dashboard/custom_listview.dart';
import '../../Dashboard/dashboard_bottom_sheet.dart';

class Dashboard extends StatefulWidget {
  const Dashboard({super.key});

  @override
  State<Dashboard> createState() => _DashboardState();
}

class _DashboardState extends State<Dashboard> {
  late AllIncomes allIncomes;
  late AllExpenses allExpenses;
  String _selectedType = 'Income';
  String? _selectedCategory;

  bool _isCalendarVisible = false;
  final FlutterSecureStorage secureStorage = const FlutterSecureStorage();

  @override
  void initState() {
    super.initState();
    allIncomes = AllIncomes(categories: []);
    allExpenses = AllExpenses(categories: []);
    loadAllIncomes();
    loadAllExpenses();
  }

  Future<void> loadAllIncomes() async {
    await loadIncomesFromStorage(secureStorage, (categories) {
      setState(() {
        allIncomes = AllIncomes(categories: categories);
      });
    });
  }

  Future<void> loadAllExpenses() async {
    await loadExpensesFromStorage(secureStorage, (categories) {
      setState(() {
        allExpenses = AllExpenses(categories: categories);
      });
    });
  }

  Future<void> saveAllIncomes() async {
    await saveIncomesToStorage(secureStorage, allIncomes);
  }

  Future<void> saveAllExpenses() async {
    await saveExpensesToStorage(secureStorage, allExpenses);
  }

  void _toggleCalendar() {
    setState(() {
      _isCalendarVisible = !_isCalendarVisible;
    });
  }

  void _addIncome(Income income) {
    setState(() {
      allIncomes.addIncome(income.parent, income);
    });
    saveAllIncomes();
  }

  void _addExpense(Expense expense) {
    setState(() {
      allExpenses.addExpense(expense.parent, expense);
    });
    saveAllExpenses();
  }

  Route _createRoute() {
    return PageRouteBuilder(
      transitionDuration: const Duration(milliseconds: 500),
      pageBuilder: (context, animation, secondaryAnimation) => const Profile(),
      transitionsBuilder: (context, animation, secondaryAnimation, child) {
        const begin = Offset(1.0, 0.0);
        const end = Offset.zero;
        const curve = Curves.ease;
        var tween =
        Tween(begin: begin, end: end).chain(CurveTween(curve: curve));
        return SlideTransition(
          position: animation.drive(tween),
          child: child,
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        backgroundColor: Colors.white,
        leading: IconButton(
          icon: const Icon(Icons.menu),
          onPressed: () {
            Scaffold.of(context).openDrawer();
          },
        ),
        title: const Center(
            child: Text('Total Balance at end of month',
                textAlign: TextAlign.center,
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold))),
        actions: [
          IconButton(
            icon: const Icon(Icons.person),
            onPressed: () {
              Navigator.of(context).push(_createRoute());
            },
          ),
        ],
      ),
      body: Center(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            const SizedBox(height: 20),
            BalanceDisplay(
              totalIncome: getTotalIncome(allIncomes),
              totalExpense: getTotalExpense(allExpenses),
            ),
            const SizedBox(height: 20),
            ElevatedButton(
              onPressed: _toggleCalendar,
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.black,
                shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(8),
                ),
              ),
              child: Text(
                _isCalendarVisible ? 'Hide Calendar' : 'Show Calendar',
                style: const TextStyle(color: Colors.white),
              ),
            ),
            const SizedBox(height: 20),
            if (_isCalendarVisible) CustomCalendar(),
            Expanded(
              child: IncomeExpenseListView(
                allIncomes: allIncomes,
                allExpenses: allExpenses,
              ),
            ),
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          showModalBottomSheet(
            context: context,
            shape: const RoundedRectangleBorder(
              borderRadius: BorderRadius.vertical(top: Radius.circular(15.0)),
            ),
            isScrollControlled: true,
            builder: (BuildContext context) {
              return DashboardBottomSheet(
                selectedType: _selectedType,
                allIncomes: allIncomes,
                allExpenses: allExpenses,
                onCategorySelected: (categoryName) {
                  setState(() {
                    _selectedCategory = categoryName;
                  });
                },
                addIncome: _addIncome,
                addExpense: _addExpense,
              );
            },
          );
        },
        backgroundColor: Colors.black,
        child: const Icon(Icons.add, color: Colors.white),
      ),
    );
  }
}
