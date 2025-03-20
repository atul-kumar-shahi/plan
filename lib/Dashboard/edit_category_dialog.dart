import 'package:flutter/material.dart';

class EditCategoryDialog {
  static void show(BuildContext context, String currentName, Function(String) onEditCategoryName) {
    TextEditingController _controller = TextEditingController(text: currentName);

    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: Text('Edit Category Name'),
          content: TextField(
            controller: _controller,
            decoration: InputDecoration(labelText: 'New Category Name'),
          ),
          actions: <Widget>[
            TextButton(
              child: Text('Cancel'),
              onPressed: () {
                Navigator.of(context).pop();
              },
            ),
            TextButton(
              child: Text('Save'),
              onPressed: () {
                String newName = _controller.text.trim();
                onEditCategoryName(newName);
                Navigator.of(context).pop();
              },
            ),
          ],
        );
      },
    );
  }
}
