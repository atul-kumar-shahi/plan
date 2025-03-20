import 'package:flutter/material.dart';
import 'package:plan/core/sms_service.dart';
import 'package:plan/models/bank_data.dart';
import 'package:plan/widgets/bottom_sheet.dart';

class CategoryWidget extends StatefulWidget {
  final ScanResult scanResult;
  final void Function(Category) addCategory;
  final void Function(Category) updateCategory;
  final void Function(String, double) addAmount;
  final List<Category> categories;
  final String title;
  final String total;
  final bool isExpanded;
  final IconData icon;
  final List<Category> childCategories;
  final VoidCallback onTap;
  final VoidCallback onEdit;
  final bool isEditable;
  final void Function(Category, Category) onChildDelete;
  final void Function(Category) onParentDelete;
  final bool hasChildCategories;

  const CategoryWidget({
    Key? key,
    required this.title,
    required this.total,
    required this.isExpanded,
    required this.icon,
    required this.childCategories,
    required this.onTap,
    required this.onEdit,
    required this.addCategory,
    required this.addAmount,
    required this.categories,
    required this.scanResult,
    required this.updateCategory,
    required this.isEditable,
    required this.onChildDelete,
    required this.onParentDelete,
    required this.hasChildCategories,
  }) : super(key: key);

  @override
  _CategoryWidgetState createState() => _CategoryWidgetState();
}

class _CategoryWidgetState extends State<CategoryWidget> {
  final TextStyle headline4 = const TextStyle(
    fontFamily: 'PlusJakartaSans',
    fontSize: 40,
    fontWeight: FontWeight.bold,
  );

  final TextStyle subtitle1 = const TextStyle(
    fontFamily: 'PlusJakartaSans',
    fontSize: 18,
    fontWeight: FontWeight.bold,
  );

  final TextStyle bodyText2 = const TextStyle(
    fontFamily: 'PlusJakartaSans',
    fontSize: 14,
    color: Color(0xff6B6B6B),
  );

  bool hasChildCategories = false;
  late double amount;
  late String total;

  void editCategory(Category category, Category childCategory) async {
    SMSService smsService = SMSService();
    showModalBottomSheet(
      isScrollControlled: true,
      backgroundColor: Colors.white,
      context: context,
      builder: (context) => BottomSheetMenu(
        onCategoryUpdated: widget.updateCategory,
        onCategoryAdded: widget.addCategory,
        onAmountAdded: widget.addAmount,
        categories: widget.categories,
        scanResult: widget.scanResult,
        onScanResultUpdated: (updatedScanResult) async {
          setState(() {
            smsService.scanResultNotifier.value = updatedScanResult;
          });
        },
        toBeUpdated: category,
        childCategory: childCategory,
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    double amount = 0;
    for (var category in widget.childCategories) {
      amount += category.amount;
    }
    total = amount.toString();
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          GestureDetector(
            onTap: widget.onTap,
            child: Container(
              padding: const EdgeInsets.all(8.0),
              decoration: BoxDecoration(
                color: Colors.white,
              ),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Row(
                    children: [
                      Container(
                        width: 48,
                        height: 48,
                        decoration: BoxDecoration(
                          color: const Color(0xffEDEDED),
                          borderRadius: BorderRadius.circular(5),
                        ),
                        child: Icon(widget.icon, size: 20),
                      ),
                      const SizedBox(width: 24),
                      Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            widget.title,
                            style: subtitle1,
                          ),
                          Text('Total: ₹$total', style: bodyText2),
                        ],
                      ),
                    ],
                  ),
                  Row(
                    children: [
                      if (widget.isEditable)
                        IconButton(
                            onPressed: widget.onEdit,
                            icon: Icon(Icons.edit_outlined)),
                      if (widget.isEditable)
                        IconButton(
                            onPressed: () {
                              int index = widget.categories.indexWhere(
                                  (element) => widget.title == element.name);
                              widget.onParentDelete(widget.categories[index]);
                            },
                            icon: Icon(Icons.delete_outline)),
                      Icon(
                        widget.hasChildCategories
                            ? widget.isExpanded
                                ? Icons.arrow_drop_up
                                : Icons.arrow_drop_down
                            : null,
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          if (widget.isExpanded && widget.hasChildCategories)
            Padding(
              padding: const EdgeInsets.only(left: 60.0),
              child: Column(
                children: widget.childCategories.map((category) {
                  return ListTile(
                    title: Text(category.name, style: bodyText2),
                    trailing: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        Text(
                          '₹${category.amount.toStringAsFixed(2)}',
                          style: const TextStyle(
                            fontFamily: 'PlusJakartaSans',
                            fontSize: 14,
                          ),
                        ),
                        IconButton(
                          icon: Icon(Icons.edit_outlined),
                          onPressed: () {
                            int index = widget.categories.indexWhere(
                                (element) => element.name == widget.title);
                            if (widget.categories[index] == category.name) {
                              widget.onEdit;
                            } else {
                              editCategory(widget.categories[index], category);
                            }
                          },
                        ),
                        if (category.name != widget.title)
                          IconButton(
                              onPressed: () {
                                int index = widget.categories.indexWhere(
                                    (element) => element.name == widget.title);
                                widget.onChildDelete(
                                    category, widget.categories[index]);
                              },
                              icon: Icon(Icons.delete_outline))
                      ],
                    ),
                  );
                }).toList(),
              ),
            ),
        ],
      ),
    );
  }
}
