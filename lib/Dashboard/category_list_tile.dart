import 'package:flutter/material.dart';
import 'delete_parent_item_dialog.dart';
import 'edit_category_dialog.dart';
import 'delete_category_dialog.dart';

class CategoryListTile extends StatelessWidget {
  final dynamic category;
  final bool isIncome;
  final VoidCallback onDeleteCategory;
  final Function(dynamic) onDeleteItem;
  final Function(String) onEditCategoryName;

  CategoryListTile({
    required this.category,
    required this.isIncome,
    required this.onDeleteCategory,
    required this.onDeleteItem,
    required this.onEditCategoryName,
  });

  @override
  Widget build(BuildContext context) {
    final totalAmount = isIncome
        ? category.incomes.fold(0.0, (sum, item) => sum + item.amount)
        : category.expenses.fold(0.0, (sum, item) => sum + item.amount);

    return Padding(
      padding: const EdgeInsets.only(bottom: 4.0),
      child: ExpansionTile(
        leading: Container(
          height: 48,
          width: 48,
          child: Icon(isIncome ? Icons.savings_outlined : Icons.money_off_csred_outlined),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Color.fromARGB(255, 237, 237, 237),
          ),
        ),
        title: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  category.name,
                  style: TextStyle(
                    fontFamily: 'PlusJakartaSans',
                    fontSize: 16,
                    fontWeight: FontWeight.bold,
                  ),
                ),
                SizedBox(height: 4),
                Text(
                  'Total: ' + totalAmount.toString(),
                  style: TextStyle(
                    fontFamily: 'PlusJakartaSans',
                    fontSize: 14,
                    fontWeight: FontWeight.normal,
                  ),
                ),
              ],
            ),
            Row(
              children: [
                IconButton(
                  icon: Icon(Icons.edit),
                  onPressed: () {
                    EditCategoryDialog.show(context, category.name, onEditCategoryName);
                  },
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    DeleteCategoryDialog.show(context, category.name, onDeleteCategory);
                  },
                ),
              ],
            ),
          ],
        ),
        children: (isIncome ? category.incomes : category.expenses).map<Widget>((item) {
          return ListTile(
            title: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      item.description.toString(),
                      style: TextStyle(
                        fontFamily: 'PlusJakartaSans',
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                    Text(
                      item.date.toString(),
                      style: TextStyle(
                        fontFamily: 'PlusJakartaSans',
                        fontSize: 12,
                      ),
                    ),
                  ],
                ),
                Text(
                  item.amount.toString(),
                  style: TextStyle(
                    fontFamily: 'PlusJakartaSans',
                    fontSize: 16,
                  ),
                ),
                IconButton(
                  icon: Icon(Icons.delete),
                  onPressed: () {
                    DeleteItemDialog.show(context, item.description, () => onDeleteItem(item));
                  },
                ),
              ],
            ),
          );
        }).toList(),
      ),
    );
  }
}
