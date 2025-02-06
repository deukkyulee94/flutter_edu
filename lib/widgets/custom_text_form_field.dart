import 'package:flutter/material.dart';

class CustomTextFormField extends StatefulWidget {
  const CustomTextFormField({
    super.key,
    this.lableText,
    this.validator,
    this.obscureText = false,
    required this.contorller,
  });

  final String? lableText;
  final FormFieldValidator<String>? validator;
  final TextEditingController contorller;
  final bool obscureText;

  @override
  State<CustomTextFormField> createState() => _CustomTextFormFieldState();
}

class _CustomTextFormFieldState extends State<CustomTextFormField> {
  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(widget.lableText ?? ''),
        TextFormField(
          decoration: InputDecoration(
            border: OutlineInputBorder(
              borderSide: BorderSide.none,
            ),
            filled: true,
            fillColor: Colors.white,
          ),
          validator: widget.validator ?? (s) => null,
          controller: widget.contorller,
          obscureText: widget.obscureText,
        )
      ],
    );
  }
}
