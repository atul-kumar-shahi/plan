import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:plan/core/sms_service.dart';
import 'package:plan/models/bank_data.dart';
import 'package:plan/widgets/bank_category.dart';
import 'package:plan/widgets/bottom_sheet.dart';
import 'package:plan/widgets/build_category.dart';

class Screen1 extends StatefulWidget {
  const Screen1({super.key});

  @override
  State<Screen1> createState() => _Screen1State();
}

class _Screen1State extends State<Screen1> {
  bool _isExpanded = false;
  late Future<ScanResult?> scan;

  late SMSService smsService;
  List<Category> _categories = [];
  Map<String, bool> _categoryExpansionStates = {};

  static const TextStyle headline4 = TextStyle(
    fontFamily: 'PlusJakartaSans',
    fontSize: 40,
    fontWeight: FontWeight.bold,
  );

  static const TextStyle bodyText1 = TextStyle(
    fontFamily: 'PlusJakartaSans',
    fontSize: 16,
  );

  @override
  void initState() {
    List<Category> initialCategories = Category.getInitialCategories();
    super.initState();
    smsService = SMSService();
    _initScreen();
    _categories.addAll(initialCategories);
    _retrieveCategories();
  }

  Future<void> _initScreen() async {
    await smsService.scanIncomingMessages(context);
    await smsService.retrieveScanResult().then((value) {
      smsService.scanResultNotifier.value = value;
      print(value!.bankTotal);
    });
  }

  Future<void> _retrieveCategories() async {
    final storage = FlutterSecureStorage();
    final jsonCategories = await storage.read(key: 'categories');
    if (jsonCategories != null) {
      List<Category> loadedCategories = (json.decode(jsonCategories) as List)
          .map((categoryJson) => Category.fromJson(categoryJson))
          .toList();

      // Create a map of parent categories
      Map<String, Category> categoryMap = {
        for (var category in loadedCategories) category.name: category
      };

      // Ensure child categories are correctly associated with their parent categories
      for (var category in loadedCategories) {
        if (category.parentCategoryName != null) {
          var parentCategory = categoryMap[category.parentCategoryName];
          if (parentCategory != null) {
            parentCategory.childCategories.add(category);
          }
        }
      }

      setState(() {
        _categories = loadedCategories
            .where((c) => c.parentCategoryName == null)
            .toList();
        for (var category in loadedCategories) {
          _categoryExpansionStates[category.name] = false;
        }
      });
    }
  }

  void _toggleCategoryExpansion(String categoryName) {
    setState(() {
      _categoryExpansionStates[categoryName] =
          !(_categoryExpansionStates[categoryName] ?? false);
    });
  }

  void editCategory(Category category, BuildContext content) async {
    var scanResult = smsService.scanResultNotifier.value;
    if (scanResult != null) {
      showModalBottomSheet(
        isScrollControlled: true,
        backgroundColor: Colors.white,
        context: content,
        builder: (content) => BottomSheetMenu(
          onCategoryUpdated: _updateCategory,
          onCategoryAdded: _addCategory,
          onAmountAdded: _addAmount,
          categories: _categories,
          scanResult: scanResult,
          onScanResultUpdated: (updatedScanResult) async {
            setState(() {
              smsService.scanResultNotifier.value = updatedScanResult;
            });
          },
          toBeUpdated: category,
        ),
      );
    }
  }

  void _deleteChildCategory(
      Category childCategory, Category parentCategory) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Category'),
          content: Text('Do you really want to delete ${childCategory.name}?'),
          actions: <Widget>[
            TextButton(
              child: Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Yes'),
              onPressed: () async {
                setState(() {
                  int index = _categories.indexWhere(
                      (element) => element.name == parentCategory.name);
                  int i = _categories[index].childCategories.indexWhere(
                      (element) => element.name == childCategory.name);
                  _categories[index]
                      .childCategories
                      .remove(_categories[index].childCategories[i]);
                });

                final storage = FlutterSecureStorage();
                final jsonCategories =
                    json.encode(_categories.map((c) => c.toJson()).toList());
                await storage.write(key: 'categories', value: jsonCategories);

                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _deleteParentCategory(Category parentCategory) async {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Category'),
          content: Text('Do you really want to delete ${parentCategory.name}?'),
          actions: <Widget>[
            TextButton(
              child: Text('No'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Yes'),
              onPressed: () async {
                setState(() {
                  int index = _categories.indexWhere(
                      (element) => element.name == parentCategory.name);
                  _categories.remove(_categories[index]);
                });

                final storage = FlutterSecureStorage();
                final jsonCategories =
                    json.encode(_categories.map((c) => c.toJson()).toList());
                await storage.write(key: 'categories', value: jsonCategories);

                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }

  void _addCategory(Category category) async {
    if (_categories
        .any((existingCategory) => existingCategory.name == category.name)) {
      setState(() {
        final existingCategoryIndex = _categories.indexWhere(
            (existingCategory) => existingCategory.name == category.name);
        final index =
            _categories[existingCategoryIndex].childCategories.indexWhere(
                  (element) => element.name == category.name,
                );
        _categories[existingCategoryIndex].childCategories[index].amount +=
            category.amount;
      });
    } else {
      if (category.parentCategoryName != null) {
        final parentCategoryIndex = _categories.indexWhere((existingCategory) =>
            existingCategory.name == category.parentCategoryName);
        if (parentCategoryIndex != -1) {
          if (_categories[parentCategoryIndex]
              .childCategories
              .any((element) => element.name == category.name)) {
            setState(() {
              var childIndex = _categories[parentCategoryIndex]
                  .childCategories
                  .indexWhere((element) => element.name == category.name);
              _categories[parentCategoryIndex]
                  .childCategories[childIndex]
                  .amount += category.amount;
            });
          } else {
            setState(() {
              _categories[parentCategoryIndex].childCategories.add(category);
            });
          }
        }
      } else {
        _categories.add(category);
        category.childCategories.add(Category(
          name: category.name,
          amount: category.amount,
          parentCategoryName: category.name,
        ));
      }
    }

    setState(() async {
      final storage = FlutterSecureStorage();
      final jsonCategories =
          json.encode(_categories.map((c) => c.toJson()).toList());
      await storage.write(key: 'categories', value: jsonCategories);
    });
  }

  void _updateCategory(Category category) async {
    setState(() {
      if (_categories
          .any((existingCategory) => existingCategory.name == category.name)) {
        final existingCategoryIndex = _categories.indexWhere(
            (existingCategory) => existingCategory.name == category.name);
        final parentCategory = _categories[existingCategoryIndex];
        final index =
            _categories[existingCategoryIndex].childCategories.indexWhere(
                  (element) => element.name == category.name,
                );
        _categories.remove(parentCategory);
        parentCategory.childCategories[index].amount = category.amount;
        parentCategory.childCategories[index].name = category.name;
        _categories.add(parentCategory);
      } else {
        if (category.parentCategoryName != null) {
          final parentCategoryIndex = _categories.indexWhere(
              (existingCategory) =>
                  existingCategory.name == category.parentCategoryName);
          if (parentCategoryIndex != -1) {
            if (_categories[parentCategoryIndex]
                .childCategories
                .any((element) => element.name == category.name)) {
              var childIndex = _categories[parentCategoryIndex]
                  .childCategories
                  .indexWhere((element) => element.name == category.name);
              _categories[parentCategoryIndex]
                  .childCategories[childIndex]
                  .amount = category.amount;
              _categories[parentCategoryIndex]
                  .childCategories[childIndex]
                  .name = category.name;
            } else {
              _categories[parentCategoryIndex].childCategories.add(category);
            }
          }
        } else {
          _categories.add(category);
          category.childCategories.add(Category(
            name: category.name,
            amount: category.amount,
            parentCategoryName: category.name,
          ));
        }
      }
    });

    final storage = FlutterSecureStorage();
    final jsonCategories =
        json.encode(_categories.map((c) => c.toJson()).toList());
    await storage.write(key: 'categories', value: jsonCategories);
  }

  void _addAmount(String categoryName, double amount) {
    setState(() {
      // Check if the category exists in the top-level categories
      var existingCategory = _categories.firstWhereOrNull(
        (category) => category.name == categoryName,
      );

      // If it exists, update its amount
      if (existingCategory != null) {
        existingCategory.amount += amount;
      } else {
        // If it doesn't exist, check if it's a child category
        for (var parentCategory in _categories) {
          var existingChildCategory =
              parentCategory.childCategories.firstWhereOrNull(
            (category) => category.name == categoryName,
          );

          // If the child category exists, update its amount
          if (existingChildCategory != null) {
            existingChildCategory.amount += amount;
            break;
          }
        }
      }
    });
  }

  double calculateNetWorth(List<Category> categories) {
    double totalAmount = 0;
    for (var category in categories) {
      totalAmount += category.amount;
      if (category.childCategories.isNotEmpty) {
        if (category.childCategories.contains(category)) {
          continue;
        } else {
          totalAmount += calculateNetWorth(category.childCategories);
        }
        totalAmount -= category.amount;
      }
    }
    return totalAmount;
  }

  void _toggleExpansion() {
    setState(() {
      _isExpanded = !_isExpanded;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.white,
      appBar: AppBar(
        title: const Text('Net Worth', style: bodyText1),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: ValueListenableBuilder<ScanResult?>(
        valueListenable: smsService.scanResultNotifier,
        builder: (context, scanResult, child) {
          if (scanResult == null) {
            return const Center(child: CircularProgressIndicator());
          }

          final bankAccounts = scanResult.bankAccounts;
          final bankTotal = scanResult.bankTotal;

          double netWorth = calculateNetWorth(_categories) + bankTotal;

          return SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                // Display net worth
                Center(
                  child: Text(
                    '₹${netWorth.toStringAsFixed(0)}',
                    style: headline4,
                  ),
                ),
                const SizedBox(height: 20),
                // Display bank accounts using bankAccounts
                BankCategoryWidget(
                  bankAccounts: bankAccounts,
                  onTap: _toggleExpansion,
                  isExpanded: _isExpanded,
                ),
                // Display other categories using _categories
                ..._categories.map((category) {
                  return CategoryWidget(
                    onChildDelete: _deleteChildCategory,
                    onParentDelete: _deleteParentCategory,
                    updateCategory: _updateCategory,
                    scanResult: scanResult,
                    addAmount: _addAmount,
                    addCategory: _addCategory,
                    categories: _categories,
                    title: category.name,
                    total: category.amount.toStringAsFixed(0),
                    isExpanded:
                        _categoryExpansionStates[category.name] ?? false,
                    icon: category.name == 'Bank Accounts'
                        ? Icons.account_balance_wallet_outlined
                        : category.name == 'Digital Wallets'
                            ? Icons.account_balance_wallet_outlined
                            : category.name == 'Investments'
                                ? Icons.show_chart_outlined
                                : category.name == 'Cash'
                                    ? Icons.money_outlined
                                    : Icons.handshake,
                    childCategories: category.childCategories,
                    onTap: () {
                      _toggleCategoryExpansion(category.name);
                    },
                    onEdit: () {
                      print(category.name);
                      editCategory(category, context);
                    },
                    isEditable: !(category.name == 'Investments' ||
                        category.name == 'Digital Wallets' ||
                        category.name == 'Cash' ||
                        category.name == 'Lent'),
                    hasChildCategories: category.childCategories.isNotEmpty,
                  );
                }).toList(),
              ],
            ),
          );
        },
      ),
      floatingActionButton: ValueListenableBuilder<ScanResult?>(
        valueListenable: smsService.scanResultNotifier,
        builder: (context, scanResult, child) {
          return FloatingActionButton(
            backgroundColor: Colors.black,
            onPressed: () {
              if (scanResult != null) {
                showModalBottomSheet(
                  isScrollControlled: true,
                  backgroundColor: Colors.white,
                  context: context,
                  builder: (context) => BottomSheetMenu(
                    onCategoryUpdated: _updateCategory,
                    onCategoryAdded: _addCategory,
                    onAmountAdded: _addAmount,
                    categories: _categories,
                    scanResult: scanResult,
                    onScanResultUpdated: (updatedScanResult) async {
                      setState(() {
                        smsService.scanResultNotifier.value = updatedScanResult;
                      });
                    },
                  ),
                );
              } else {
                // Handle case where scan result is not available
                ScaffoldMessenger.of(context).showSnackBar(
                  SnackBar(
                    content: Text(
                        'No scan result available. Please wait or check permissions.'),
                  ),
                );
              }
            },
            child: const Icon(Icons.add, color: Colors.white),
          );
        },
      ),
    );
  }
}
