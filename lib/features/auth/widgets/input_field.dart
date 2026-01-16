import 'package:flutter/material.dart';
import '../../../core/const/app_colors.dart';

class InputField extends StatelessWidget {
  final TextEditingController controller;
  final String hint;
  final bool obscureText;
  final Widget? suffixIcon;
  final Function(String)? onChanged;
  final String? Function(String?)? validator;
  final bool enabled;
  final int maxLines;
  final EdgeInsetsGeometry? contentPadding;

  const InputField({
    super.key,
    required this.controller,
    required this.hint,
    this.obscureText = false,
    this.suffixIcon,
    this.onChanged,
    this.validator,
    this.enabled = true,
    this.maxLines = 1,
    this.contentPadding,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      onChanged: onChanged,
      validator: validator,
      enabled: enabled,
      maxLines: maxLines,
      style: const TextStyle(color: Colors.white),
      decoration: InputDecoration(
        hintText: hint,
        hintStyle: const TextStyle(color: Colors.grey),
        filled: true,
        fillColor: AppColors.boxColor,
        contentPadding: contentPadding ??
            const EdgeInsets.symmetric(horizontal: 16, vertical: 14),
        border: OutlineInputBorder(
          borderRadius: BorderRadius.circular(24),
          borderSide: BorderSide.none,
        ),
        suffixIcon: suffixIcon,
      ),
    );
  }
}

