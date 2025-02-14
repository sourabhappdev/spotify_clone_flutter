import 'package:flutter/material.dart';

class CommonTextField extends StatefulWidget {
  const CommonTextField({
    super.key,
    required this.controller,
    required this.hintText,
    this.isPassword = false,
    this.isRequired = false,
    this.validator,
  });

  final TextEditingController controller;
  final String hintText;
  final bool isPassword, isRequired;
  final Function(String?)? validator;

  @override
  State<CommonTextField> createState() => _CommonTextFieldState();
}

class _CommonTextFieldState extends State<CommonTextField> {
  bool isObscure = true;

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: widget.controller,
      obscureText: widget.isPassword ? isObscure : false,
      cursorColor: Colors.black45,
      // validator: widget.isRequired
      //     ? widget.validator != null
      //         ? widget.validator!
      //         : () {}
      //     : null,
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
