import 'package:classwix_orbit/core/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class VideotileWidet extends StatelessWidget {
  final dynamic video;
  const VideotileWidet({super.key, this.video});

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side:
            const BorderSide(style: BorderStyle.solid, color: AppColors.purple),
      ),
      color: AppColors.white,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        title: Text(
          video["title"] ?? "Untitled",
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.purple,
          ),
        ),
        minVerticalPadding: 15,
        trailing: IconButton(
          icon: const Icon(Icons.open_in_new, color: Colors.blue),
          onPressed: () => launch((video["video_path"])),
        ),
      ),
    );
  }
}
