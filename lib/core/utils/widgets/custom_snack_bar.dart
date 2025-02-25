import 'package:flutter/material.dart';

enum SnackBarType { success, failure }

class CustomSnackBar {
  static void showSnackBar(
      BuildContext context, String message, SnackBarType type) {
    if (context.mounted) {
      Color backgroundColor;
      switch (type) {
        case SnackBarType.success:
          backgroundColor = Colors.green;
          break;
        case SnackBarType.failure:
          backgroundColor = Colors.red;
          break;
      }

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(message),
          behavior: SnackBarBehavior.floating,
          backgroundColor: backgroundColor,
          duration: const Duration(seconds: 3),
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          margin: const EdgeInsets.all(10),
        ),
      );
    }
  }
}
