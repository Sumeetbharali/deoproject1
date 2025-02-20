import 'dart:io';

import 'package:flutter/material.dart';

class Filepicker extends StatelessWidget {
  final String label;
  final File? file;
  final VoidCallback onTap;

  const Filepicker({
    super.key,
    required this.label,
    required this.file,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.symmetric(vertical: 5),
            decoration: BoxDecoration(
                border: Border.all(color: Colors.blue),
                borderRadius: BorderRadius.circular(5)),
            child: Text(
                file != null ? file!.path.split('/').last : "Select File",
                style: const TextStyle(color: Colors.blue)),
          ),
        ),
      ],
    );
  }
}