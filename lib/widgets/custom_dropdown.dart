import 'package:flutter/cupertino.dart';
import 'package:flutter/material.dart';

class CustomDropdown extends StatelessWidget {
  final String label;
  final List<String> items;
  final String? selectedValue;
  final ValueChanged<String?> onChanged;
  final FormFieldValidator<String>? validator;

  const CustomDropdown({
    Key? key,
    required this.label,
    required this.items,
    this.selectedValue,
    required this.onChanged,
    this.validator,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Padding(
            padding: const EdgeInsets.all(4.0),
            child: Text(label,
                style: TextStyle( fontWeight: FontWeight.bold,
                    color: Color(0xFF29292B)
                )),
          ),
          DropdownButtonFormField<String>(
            decoration: InputDecoration(
              filled: true,
              fillColor: Colors.transparent,
              hintText: label,
              hintStyle: TextStyle(color: Color(0xFF8F8E93)),
              border: OutlineInputBorder(
                borderRadius: BorderRadius.all(Radius.circular(10.0)),
              ),
            ),
            value: selectedValue,
            onChanged: onChanged,
            validator: validator,
            dropdownColor: Colors.white,
            borderRadius: BorderRadius.all(Radius.circular(10)),
            items: items.map<DropdownMenuItem<String>>((String value) {
              return DropdownMenuItem<String>(
                value: value,
                child: Text(value, style: TextStyle(color: Color(0xFF8F8E93))),
              );
            }).toList(),
          ),
        ],
      ),
    );
  }
}