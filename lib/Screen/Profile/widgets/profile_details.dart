import 'package:flutter/material.dart';

class ProfileDetails extends StatelessWidget {
  final String label;
  final String value;
  final double screenWidth;
  const ProfileDetails({super.key, required this.label, required this.value, required this.screenWidth});

  @override
  Widget build(BuildContext context) {
    return Column(
    children: [
      Text(
        label,
        style: TextStyle(
          color: const Color(0xFF8E44AD),
          fontSize: screenWidth * 0.04,
          fontWeight: FontWeight.bold,
        ),
      ),
      const SizedBox(height: 8),
      Text(
        value,
        style: TextStyle(
          color: Colors.black,
          fontSize: screenWidth * 0.05,
        ),
      ),
    ],
  );
  }
}
