import 'package:flutter/material.dart';

class CustomHorizontalLine extends StatelessWidget {
  const CustomHorizontalLine({super.key});

  @override
  Widget build(BuildContext context) {
    return  Padding(
      padding:const EdgeInsets.symmetric(horizontal: 25.0),
      child: Row(
        children: [
          Expanded(
            child: Divider(
              thickness: 1,
              color: Colors.grey[400],
            ),
          ),
          const SizedBox(height: 70,),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 10),
            child: Text('OR',style: TextStyle(
              color: Colors.grey.shade700,
            ),),
          ),
          Expanded(
            child: Divider(
              thickness: 1,
              color: Colors.grey[400],
            ),
          ),
        ],
      ),
    );
  }
}
