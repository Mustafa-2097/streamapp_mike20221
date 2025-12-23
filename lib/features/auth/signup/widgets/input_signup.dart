import 'package:flutter/material.dart';

Widget inputField({
  required TextEditingController controller,
  required String hint,
  bool obscureText = false,
  Widget? suffixIcon,
  Function(String)? onChanged,
}) {
  return TextField(
    controller: controller,
    obscureText: obscureText,
    onChanged: onChanged,
    style: const TextStyle(color: Colors.white),
    decoration: InputDecoration(
      hintText: hint,
      hintStyle: const TextStyle(color: Colors.grey),
      filled: true,
      fillColor: const Color(0xFF1B1B1B),
      border: OutlineInputBorder(
        borderRadius: BorderRadius.circular(30),
        borderSide: BorderSide.none,
      ),
      suffixIcon: suffixIcon,
    ),
  );
}
