import 'package:flutter/material.dart';

class CustomTextField extends StatelessWidget {
  const CustomTextField(
      {super.key,
      required this.controller,
      required this.prefixIcon,
      required this.suffixIcon,
      required this.hintText,
      required this.isSuffixIconVisible,
      required this.keyboardType,
      required this.obscureText,
      required this.onSufficIconPressed,
      required this.isEnabled,
      required this.maxLines,
      required this.isPrefixVisible});
  final TextEditingController controller;
  final IconData prefixIcon;
  final IconData suffixIcon;
  final bool isSuffixIconVisible;
  final String hintText;
  final TextInputType keyboardType;
  final bool obscureText;
  final bool isEnabled;
  final VoidCallback onSufficIconPressed;
  final int maxLines;
  final bool isPrefixVisible;

  @override
  Widget build(BuildContext context) {
    return TextField(

      maxLines: maxLines,
      enabled: isEnabled,
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscureText,
      style: TextStyle(
        color: Theme.of(context).colorScheme.onBackground,
      ),
      decoration: InputDecoration(
        
          // prefixIconConstraints:
          //     BoxConstraints(maxWidth: isPrefixVisible ? 100 : 0),
          prefixIcon: isPrefixVisible ? Icon(prefixIcon) : const SizedBox(),
          hintStyle: TextStyle(
            fontFamily: "poppins",
            color: Theme.of(context).colorScheme.onBackground.withOpacity(0.5),
            fontSize: 14,
          ),
          suffixIcon: isSuffixIconVisible
              ? GestureDetector(
                  onTap: onSufficIconPressed, child: Icon(suffixIcon))
              : const SizedBox(),
          hintText: hintText,
          disabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          enabledBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide.none,
          ),
          focusedBorder: OutlineInputBorder(
            borderRadius: BorderRadius.circular(16),
            borderSide: BorderSide(
              color: Theme.of(context).colorScheme.primary.withOpacity(0.4),
            ),
          ),
          filled: true,
          fillColor: Theme.of(context).colorScheme.primary.withOpacity(0.1)),
    );
  }
}
