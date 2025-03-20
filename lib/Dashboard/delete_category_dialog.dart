import 'package:flutter/material.dart';

class DeleteCategoryDialog {
  static void show(BuildContext context, String categoryName, VoidCallback onDeleteCategory) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Category'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Are you sure you want to delete "$categoryName" and all its items?'),
              ],
            ),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Delete'),
              onPressed: () {
                onDeleteCategory();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
