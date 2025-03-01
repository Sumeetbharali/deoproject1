import 'package:flutter/material.dart';
import 'package:flutter/services.dart';

class SignInTextfield extends StatelessWidget {
  final IconData icon;
  final String hintText;
  final TextEditingController controller;
  final bool obscureText;
  const SignInTextfield({super.key, required this.icon, required this.hintText, required this.controller, this.obscureText=false});

  @override
  Widget build(BuildContext context) {
    return TextFormField(
      controller: controller,
      obscureText: obscureText,
      textInputAction: TextInputAction.next,
      decoration: InputDecoration(
        hintText: hintText,
        hintStyle: const TextStyle(
          fontWeight: FontWeight.normal,
          color: Colors.grey,
        ),
        suffixIcon: Icon(
          obscureText ? Icons.lock : Icons.phone,
          color: Colors.grey.shade400,
        ),
      ),
      inputFormatters: [
        if (!obscureText) FilteringTextInputFormatter.digitsOnly,
        LengthLimitingTextInputFormatter(10),
      ],
    );
    ;
  }
}
