import 'package:classwix_orbit/provider/sample_provider.dart';
import 'package:classwix_orbit/routes/routes.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ConfirmationDialog extends StatelessWidget {
  final String message;
  final WidgetRef ref;

  const ConfirmationDialog(
      {super.key, required this.message, required this.ref});

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(15),
      ),
      title: const Center(child: Text("Confirmation")),
      content: Text(
        message,
        style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
      ),
      actions: [
        TextButton(
          onPressed: () {
            Navigator.of(context).pop();
          },
          child: const Text("Cancel", style: TextStyle(color: Colors.red)),
        ),
        ElevatedButton(
          onPressed: () {
            ref.read(sampleProvider.notifier).clearToken();
            Navigator.pushNamedAndRemoveUntil(
                context, Routes.signin, (route) => false);
          },
          style: ElevatedButton.styleFrom(
            backgroundColor: Colors.green,
          ),
          child: const Text(
            "Yes",
            style: TextStyle(
              color: Colors.white,
            ),
          ),
        ),
      ],
    );
  }
}

void showConfirmationDialog(
    BuildContext context, WidgetRef ref, String message) {
  showDialog(
    context: context,
    builder: (BuildContext context) {
      return ConfirmationDialog(message: message, ref: ref);
    },
  );
}
