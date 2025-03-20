  import 'package:flutter/material.dart';

  class IncomeForm extends StatefulWidget {
    final List<String> categoryNames;
    final Function(String) onCategorySelected;
    final String selectedState;

    IncomeForm({required this.categoryNames, required this.onCategorySelected, required this.selectedState});

    @override
    _IncomeFormState createState() => _IncomeFormState();
  }

  class _IncomeFormState extends State<IncomeForm> {
    String? _selectedCategory;
    bool _isOtherSelected = false;
    TextEditingController _otherCategoryController = TextEditingController();

    void _handleCategoryChange(String? value) {
      setState(() {
        print(widget.categoryNames);
        _selectedCategory = value;
        _isOtherSelected = value == 'Other';
        if (!_isOtherSelected && value != null) {
          widget.onCategorySelected(value);
        }
      });
    }

    List<String> getFilteredCategories() {
      if (widget.selectedState == 'Income') {
        return widget.categoryNames.toList();
      } else {
        return widget.categoryNames.toList();
      }
    }

    void _handleOtherCategorySubmit(String value) {
      if (value.isNotEmpty) {
        widget.onCategorySelected(value);
      }
    }

    @override
    Widget build(BuildContext context) {
      return Form(
        child: Row(
          children: [
            Flexible(
              flex: _isOtherSelected ? 1 : 4,
              child: DropdownButtonFormField<String>(
                value: _selectedCategory,
                hint: Text('Select Category'),
                onChanged: _handleCategoryChange,
                items: [
                  ...getFilteredCategories().map((name) {
                    return DropdownMenuItem(
                      value: name,
                      child: Text(name),
                    );
                  }).toList(),
                  DropdownMenuItem(
                    value: 'Other',
                    child: Text('Other'),
                  ),
                ],
                validator: (value) {
                  if (value == null || value.isEmpty) {
                    return 'Please select a category';
                  }
                  return null;
                },
              ),
            ),
            if (_isOtherSelected) SizedBox(width: 5),
            if (_isOtherSelected)
              SizedBox(
                width: 180,
                child: TextFormField(
                  controller: _otherCategoryController,
                  decoration: InputDecoration(
                    hintText: 'Enter category name',
                  ),
                  onFieldSubmitted: _handleOtherCategorySubmit,
                  validator: (value) {
                    if (value == null || value.isEmpty) {
                      return 'Please enter a category name';
                    }
                    return null;
                  },
                ),
              ),
          ],
        ),
      );
    }
  }
