import 'package:flutter/material.dart';

class ErrorWidgetCustom extends StatelessWidget {
  final VoidCallback onRetry;

  const ErrorWidgetCustom({super.key, required this.onRetry});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text("Failed to load groups",
              style: TextStyle(color: Colors.red, fontSize: 16)),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: onRetry,
            child: const Text("Retry"),
          ),
        ],
      ),
    );
  }
}

class GroupError extends StatelessWidget {
  final dynamic fetchData;
  const GroupError({super.key, required this.fetchData});

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          const Text(
            "No internet connection. Please try again.",
            style: TextStyle(color: Colors.red, fontSize: 16),
          ),
          const SizedBox(height: 10),
          ElevatedButton(
            onPressed: fetchData, 
            child: const Text("Retry"),
          ),
        ],
      ),
    );
  }
}
