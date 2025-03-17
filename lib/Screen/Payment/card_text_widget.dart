import 'package:flutter/material.dart';

import 'package:classwix_orbit/core/constants/colors.dart';

class CardTextWidget extends StatelessWidget {
  final IconData icon;
  final String text;

  const CardTextWidget({
    super.key,
    required this.icon,
    required this.text,
  });

  @override
  Widget build(BuildContext context) {
    return Row(
      children: [
        Icon(icon, size: 16, color: AppColors.white),
        const SizedBox(width: 5),
        Text(
          text,
          style: const TextStyle(color: AppColors.white),
        ),
      ],
    );
  }
}
