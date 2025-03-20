import 'package:flutter/material.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:plan/models/bank_data.dart';
import 'dart:convert';

// Add the extension method
extension IterableExtension<E> on Iterable<E> {
  E? firstWhereOrNull(bool Function(E element) test) {
    for (E element in this) {
      if (test(element)) return element;
    }
    return null;
  }
}

// Other code remains the same...

class BottomSheetMenu extends StatefulWidget {
  final void Function(Category) onCategoryAdded;
  final void Function(String, double) onAmountAdded;
  final void Function(Category) onCategoryUpdated;
  final List<Category> categories;
  final ScanResult scanResult;
  final void Function(ScanResult) onScanResultUpdated;
  final Category? toBeUpdated;
  final Category? childCategory;
  final int? index;

  BottomSheetMenu(
      {required this.onCategoryAdded,
      required this.onAmountAdded,
      required this.scanResult,
      required this.onScanResultUpdated,
      required this.categories,
      this.toBeUpdated,
      this.index,
      this.childCategory,
      required this.onCategoryUpdated});

  @override
  _BottomSheetMenuState createState() => _BottomSheetMenuState();
}

class _BottomSheetMenuState extends State<BottomSheetMenu> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _amountController = TextEditingController();
  final TextEditingController _accountNameController = TextEditingController();
  final TextEditingController _accountAmountController =
      TextEditingController();
  Category? _selectedParentCategory;
  bool _isAddingAccount = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    if (widget.toBeUpdated != null && widget.childCategory != null) {
      // Edit mode for a child category
      print(widget.toBeUpdated!.name);
      print(widget.childCategory!.name);
      var childCategory = widget.childCategory!;
      _nameController.text = childCategory.name;
      _amountController.text = childCategory.amount.toString();
      _selectedParentCategory = widget.toBeUpdated!;
      widget.toBeUpdated!.childCategories.remove(childCategory);
    } else if (widget.toBeUpdated != null) {
      int index = widget.categories
          .indexWhere((element) => element.name == widget.toBeUpdated!.name);
      print(index);
      int index1 = widget.categories[index].childCategories
          .indexWhere((element) => element.name == widget.toBeUpdated!.name);
      print(index1);
      _nameController.text =
          widget.categories[index].childCategories[index1].name;
      _amountController.text =
          widget.categories[index].childCategories[index1].amount.toString();
      if (widget.toBeUpdated!.childCategories
          .any((element) => element.name == widget.toBeUpdated!.name)) {
        widget.toBeUpdated!.childCategories
            .indexWhere((element) => element.name == widget.toBeUpdated!.name);
      } else {
        print(widget.toBeUpdated!.parentCategoryName);
        widget.categories.indexWhere((element) =>
            element.name == widget.toBeUpdated!.parentCategoryName);
      }
    }
  }

  void _addCategory() async {
    final String name = _nameController.text;
    final double? amount = double.tryParse(_amountController.text);

    if (name.isNotEmpty && amount != null) {
      if (widget.toBeUpdated != null) {
        widget.onCategoryUpdated(Category(
            name: name,
            amount: amount,
            parentCategoryName: _selectedParentCategory?.name));
      } else {
        widget.onCategoryAdded(
          Category(
            name: name,
            amount: amount,
            parentCategoryName: _selectedParentCategory?.name,
          ),
        );
      }

      _nameController.clear();
      _amountController.clear();
      setState(() {
        _selectedParentCategory = null;
      });

      Navigator.of(context).pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter valid name and amount')),
      );
    }
  }

  void _addAccount() async {
    final String accountName = _accountNameController.text;
    final double? accountAmount =
        double.tryParse(_accountAmountController.text);

    if (accountName.isNotEmpty && accountAmount != null) {
      final newAccount = AccountBalance(
        name: accountName,
        total: accountAmount,
      );

      // Update scanResult in the widget
      widget.scanResult.bankAccounts.add(newAccount);
      widget.scanResult.bankTotal += accountAmount;

      // Notify the parent widget about the updated scanResult
      widget.onScanResultUpdated(widget.scanResult);

      // Clear text controllers
      _accountNameController.clear();
      _accountAmountController.clear();

      // Update secure storage
      final storage = FlutterSecureStorage();
      final jsonScanResult = json.encode(widget.scanResult.toJson());
      await storage.write(key: 'scanned_messages1', value: jsonScanResult).then(
        (value) {
          print('saved successfully');
        },
      );

      // Dismiss the bottom sheet
      Navigator.of(context).pop();
    } else {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Please enter valid account name and amount')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      child: SafeArea(
          child: Padding(
        padding: EdgeInsets.only(
          bottom: MediaQuery.of(context).viewInsets.bottom + 20,
          left: 16,
          right: 16,
          top: 16,
        ),
        child: Column(
          mainAxisSize: MainAxisSize.min,
          children: [
            Row(
              children: [
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _isAddingAccount = false;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: !_isAddingAccount
                            ? Colors.black
                            : const Color(0xffEDEDED),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          'Category',
                          style: TextStyle(
                            fontFamily: 'PlusJakartaSans',
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: !_isAddingAccount
                                ? Colors.white
                                : const Color(0xff161618),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 8),
                Expanded(
                  child: GestureDetector(
                    onTap: () {
                      setState(() {
                        _isAddingAccount = true;
                      });
                    },
                    child: Container(
                      padding: const EdgeInsets.symmetric(vertical: 12),
                      decoration: BoxDecoration(
                        color: _isAddingAccount
                            ? Colors.black
                            : const Color(0xffEDEDED),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Center(
                        child: Text(
                          'Account',
                          style: TextStyle(
                            fontFamily: 'PlusJakartaSans',
                            fontSize: 16,
                            fontWeight: FontWeight.bold,
                            color: _isAddingAccount
                                ? Colors.white
                                : const Color(0xff161618),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
            const SizedBox(height: 16),
            if (_isAddingAccount) ...[
              TextField(
                controller: _accountNameController,
                decoration: InputDecoration(
                  hintText: 'Account Name',
                  border: OutlineInputBorder(
                    borderSide:
                        const BorderSide(width: 2, color: Color(0xffEDEDED)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _accountAmountController,
                decoration: InputDecoration(
                  hintText: 'Enter amount',
                  border: OutlineInputBorder(
                    borderSide:
                        const BorderSide(width: 2, color: Color(0xffEDEDED)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 84,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: _addAccount,
                      child: Text(
                        'Add',
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        textStyle: const TextStyle(
                          fontFamily: 'PlusJakartaSans',
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    width: 84,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        'Cancel',
                        style: TextStyle(color: Colors.black),
                      ),
                      style: OutlinedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: const Color(0xffEDEDED),
                        textStyle: const TextStyle(
                          fontFamily: 'PlusJakartaSans',
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff6B6B6B),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ] else ...[
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  hintText: 'Bank Accounts, Paytm etc.',
                  border: OutlineInputBorder(
                    borderSide:
                        const BorderSide(width: 2, color: Color(0xffEDEDED)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: _amountController,
                decoration: InputDecoration(
                  hintText: 'Enter amount',
                  border: OutlineInputBorder(
                    borderSide:
                        const BorderSide(width: 2, color: Color(0xffEDEDED)),
                    borderRadius: BorderRadius.circular(8),
                  ),
                ),
                keyboardType: TextInputType.number,
              ),
              const SizedBox(height: 16),
              Container(
                color: Colors.white,
                child: DropdownButtonFormField<Category>(
                  value: _selectedParentCategory != null
                      ? _selectedParentCategory
                      : null,
                  decoration: InputDecoration(
                    hintText: 'Select parent category (optional)',
                    border: OutlineInputBorder(
                      borderSide:
                          const BorderSide(width: 2, color: Color(0xffEDEDED)),
                      borderRadius: BorderRadius.circular(8),
                    ),
                  ),
                  items: widget.categories.map((category) {
                    return DropdownMenuItem<Category>(
                      value: category,
                      child: Container(
                        color: Colors.white,
                        child: Text(category.name),
                      ),
                    );
                  }).toList(),
                  onChanged: (Category? value) {
                    setState(() {
                      _selectedParentCategory = value;
                    });
                  },
                ),
              ),
              const SizedBox(height: 16),
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    width: 84,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: _addCategory,
                      child: Text(
                        widget.toBeUpdated == null ? 'Add' : 'Update',
                        style: TextStyle(color: Colors.white),
                      ),
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        textStyle: const TextStyle(
                          fontFamily: 'PlusJakartaSans',
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 8),
                  Container(
                    width: 84,
                    height: 48,
                    child: ElevatedButton(
                      onPressed: () {
                        Navigator.of(context).pop();
                      },
                      child: Text(
                        'Cancel',
                        style: TextStyle(color: Colors.black),
                      ),
                      style: OutlinedButton.styleFrom(
                        elevation: 0,
                        backgroundColor: const Color(0xffEDEDED),
                        textStyle: const TextStyle(
                          fontFamily: 'PlusJakartaSans',
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                          color: Color(0xff6B6B6B),
                        ),
                        padding: const EdgeInsets.symmetric(vertical: 12),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ],
        ),
      )),
    );
  }
}
