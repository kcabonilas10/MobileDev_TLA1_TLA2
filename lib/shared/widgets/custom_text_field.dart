// lib/shared/widgets/custom_text_field.dart

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class CustomTextField extends StatelessWidget {
  final String label;
  final TextEditingController controller;
  final FocusNode focusNode;
  final TextInputType? keyboardType;
  final TextInputAction? textInputAction;
  final bool isMultiline;
  final int? maxLines;
  final List<TextInputFormatter>? inputFormatters;
  final String? Function(String?)? validator;
  final void Function(String)? onFieldSubmitted;

  const CustomTextField({
    super.key,
    required this.label,
    required this.controller,
    required this.focusNode,
    this.keyboardType,
    this.textInputAction,
    this.isMultiline = false,
    this.maxLines = 1,
    this.inputFormatters,
    this.validator,
    this.onFieldSubmitted,
  });

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      focusNode: focusNode,
      keyboardType: keyboardType,
      textInputAction: textInputAction,
      maxLines: maxLines,
      decoration: InputDecoration(
        labelText: label,
        border: const OutlineInputBorder(),
        filled: true,
      ),
      inputFormatters: inputFormatters,
      validator: validator,
      onFieldSubmitted: onFieldSubmitted,
    );
  }
}