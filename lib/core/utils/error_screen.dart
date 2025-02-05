
import 'package:flutter/material.dart';
import '../constants/colors.dart';

class ErrorScreen extends StatelessWidget {
  const ErrorScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        centerTitle: true,
        title: const Text(
          'Error Screen',
          style: TextStyle(fontWeight: FontWeight.bold, color: AppColors.red),
        ),
      ),
      body: const Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              "Something went wrong...",
              style: TextStyle(color: AppColors.white, fontSize: 20),
            ),
            Icon(Icons.error_outline_rounded, color: AppColors.red, size: 50),
          ],
        ),
      ),
    );
  }
}
