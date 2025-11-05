import 'package:flutter/material.dart';

class OutlinedInput extends StatelessWidget {
  final TextEditingController controller;
  final String label;
  final TextInputType? keyboardType;
  final String? hint;
  final bool obscure;
  const OutlinedInput({
    super.key,
    required this.controller,
    required this.label,
    this.keyboardType,
    this.hint,
    this.obscure = false,
  });

  @override
  Widget build(BuildContext context) {
    return TextField(
      textDirection: TextDirection.rtl,
      controller: controller,
      keyboardType: keyboardType,
      obscureText: obscure,
      decoration: InputDecoration(labelText: label, hintText: hint),
    );
  }
}
