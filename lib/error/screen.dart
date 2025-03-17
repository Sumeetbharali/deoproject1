import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../controller/auth_controller.dart';
import '../core/constants/colors.dart';
import '../routes/routes.dart';

class ErrorScreen extends ConsumerWidget {
  const ErrorScreen({super.key});
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return Scaffold(
      backgroundColor: AppColors.red,
      appBar: AppBar(
        backgroundColor: AppColors.lightPurp,
        automaticallyImplyLeading: false,
        title: const Text(
          'Error',
          style: TextStyle(color: AppColors.white),
        ),
        actions: [
          IconButton(
              icon: const Icon(Icons.logout, color: AppColors.white),
              onPressed: () {
                ref.read(authProvider.notifier).logout();
                Navigator.of(context).pushNamedAndRemoveUntil(Routes.initial, (route) => false);
              }),
        ],
      ),
      body: const Center(
        child: Text(
          'Page not found',
          style: TextStyle(color: AppColors.white),
        ),
      ),
    );
  }
}
