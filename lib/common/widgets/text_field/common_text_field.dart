import 'package:flutter/material.dart';

class CommonTextFormField extends StatefulWidget {
  const CommonTextFormField({
    super.key,
    required this.controller,
    required this.hintText,
    this.isEmail = false,
    this.isPassword = false,
    this.isRequired = true,
    this.validator,
    this.textInputType = TextInputType.text,
    this.textInputAction = TextInputAction.next,
  });

  final TextEditingController controller;
  final String hintText;
  final bool isEmail, isPassword, isRequired;
  final String? Function(String?)? validator;
  final TextInputType textInputType;
  final TextInputAction textInputAction;

  @override
  State<CommonTextFormField> createState() => _CommonTextFormFieldState();
}

class _CommonTextFormFieldState extends State<CommonTextFormField> {
  bool isObscure = true;

  String? _defaultValidator(String? value) {
    if (!widget.isRequired) return null;
    if (value == null || value.isEmpty) {
      return 'This field is required';
    }
    if (widget.isEmail) {
      final emailRegex =
          RegExp(r'^[a-zA-Z0-9._%+-]+@[a-zA-Z0-9.-]+\.[a-zA-Z]{2,}$');
      if (!emailRegex.hasMatch(value)) {
        return 'Enter a valid email';
      }
    }
    if (widget.isPassword) {
      final passwordRegex =
          RegExp(r'^(?=.*[a-z])(?=.*[A-Z])(?=.*\d)(?=.*[@#$%^&+=!]).{8,}$');
      if (!passwordRegex.hasMatch(value)) {
        return 'Password must be at least 8 characters with uppercase, lowercase, number, and symbol';
      }
    }
    return widget.validator?.call(value);
  }

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: widget.isPassword ? isObscure : false,
      cursorColor: Colors.black45,
      textInputAction: widget.textInputAction,
      keyboardType: widget.textInputType,
      autovalidateMode: AutovalidateMode.onUserInteraction,
      validator: _defaultValidator,
      decoration: InputDecoration(
        hintText: widget.hintText,
        suffixIcon: widget.isPassword
            ? GestureDetector(
                onTap: () {
                  setState(() {
                    isObscure = !isObscure;
                  });
                },
                child: Icon(
                  isObscure ? Icons.visibility : Icons.visibility_off,
                ),
              )
            : null,
      ).applyDefaults(Theme.of(context).inputDecorationTheme),
    );
  }
}
