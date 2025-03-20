  import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  final TextEditingController controller;
  final TextInputType? keyboardType;
  final bool? isObscuredText;
  final String? obscuredCharacter;
  final String hintText;
  final IconData? suffixIcon;
  final Widget? prefixIcon;
  final IconData? iconBefore;
  final IconData? iconAfter;
  final Function()? onPressed;
  final String labelText;

  const CustomTextField(
      {super.key,
      required this.controller,
      this.keyboardType = TextInputType.text,
      this.isObscuredText = false,
      this.obscuredCharacter = '*',
      required this.hintText,
      this.suffixIcon,
      this.prefixIcon,
      this.iconBefore,
      this.iconAfter,
      this.onPressed,
      required this.labelText});

  @override
  Widget build(BuildContext context) {
    double height = MediaQuery.of(context).size.height;
    double width = MediaQuery.of(context).size.width;
    return Padding(
      padding: const EdgeInsets.symmetric(
        horizontal: 20,
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text(
            labelText,
            style: const TextStyle(
              fontSize: 15,
            ),
          ),
          const SizedBox(
            height: 5,
          ),
          TextFormField(
            controller: controller,
            keyboardType: keyboardType,
            obscureText: isObscuredText!,
            obscuringCharacter: obscuredCharacter!,
            decoration: InputDecoration(
              contentPadding:
                  const EdgeInsets.only(top: 9, left: 15, bottom: 15),
              constraints: BoxConstraints(
                maxHeight: height * 0.565,
                maxWidth: width,
              ),
              filled: true,
              fillColor: Colors.white,
              hintText: hintText,
              hintStyle: TextStyle(color: Colors.grey.shade500),
              prefixIcon: prefixIcon,
              suffixIcon:
                  IconButton(icon: Icon(suffixIcon), onPressed: onPressed),
              focusedBorder: OutlineInputBorder(
                borderRadius: BorderRadius.circular(15),
                borderSide: const BorderSide(
                  color: Colors.black45,
                  width: 1,
                ),
              ),
              enabledBorder: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(15),
                  borderSide: const BorderSide(
                    color: Colors.black45,
                    width: 1,
                  )),
            ),
          ),
        ],
      ),
    );
  }
}
