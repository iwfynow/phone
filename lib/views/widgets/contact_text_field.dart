import 'package:flutter/material.dart';

class ContactTextField extends StatelessWidget {
  final String label;
  final TextInputType keyboardType;
  final int maxLength;
  final String initialValue;
  final String? Function(String?) validator;
  final void Function(String?) onSaved;
  const ContactTextField({super.key, 
    required this.label,
    required this.keyboardType,
    required this.initialValue,
    required this.maxLength,
    required this.validator,
    required this.onSaved,
  });
  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    return Center(
      child: Container(
        padding: const EdgeInsets.only(bottom: 15),
        width: screenWidth * 0.8,
        child: TextFormField(
          keyboardType: keyboardType,
          maxLength: maxLength,
          initialValue: initialValue,
          validator: validator,
          onSaved: onSaved,
          decoration: InputDecoration(
            border: const OutlineInputBorder(),
            labelText: label,
          ),
        ),
      ),
    );
  }
}
