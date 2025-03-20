import 'package:flutter/material.dart';

class DeleteItemDialog {
  static void show(BuildContext context, String itemName, VoidCallback onDeleteItem) {
    showDialog<void>(
      context: context,
      barrierDismissible: false,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Delete Item'),
          content: SingleChildScrollView(
            child: ListBody(
              children: <Widget>[
                Text('Are you sure you want to delete "$itemName"?'),
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
                onDeleteItem();
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
