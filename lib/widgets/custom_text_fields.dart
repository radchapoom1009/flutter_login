import 'package:flutter/material.dart';

class CustomTextField extends StatefulWidget {
  const CustomTextField({
    super.key,
    required this.labelText,
    required this.prefixIcon,
    required this.controller,
    required this.validator,
  });

  final String labelText;
  final IconData prefixIcon;
  final TextEditingController controller;
  final String? Function(String?) validator;

  @override
  State<CustomTextField> createState() => _CustomTextFieldState();
}

class _CustomTextFieldState extends State<CustomTextField> {
  String? _errorText;

  void _validate() {
    setState(() {
      _errorText = widget.validator(widget.controller.text);
    });
  }

  @override
  Widget build(BuildContext context) {
    return TextField(
      style: const TextStyle(color: Colors.brown, fontWeight: FontWeight.bold),
      controller: widget.controller,
      onChanged: (_) => _validate(),
      obscureText: widget.prefixIcon == Icons.lock,
      decoration: InputDecoration(
        filled: true,
        fillColor: Colors.brown[50],
        prefixIcon: Icon(widget.prefixIcon, color: Colors.brown[700]),
        labelText: widget.labelText,
        labelStyle: const TextStyle(color: Colors.brown),
        border: OutlineInputBorder(borderRadius: BorderRadius.circular(8.0)),
        errorText: _errorText,
        errorStyle: const TextStyle(
          color: Colors.red,
          fontWeight: FontWeight.bold,
          fontSize: 12.0,
        ),
      ),
    );
  }
}
