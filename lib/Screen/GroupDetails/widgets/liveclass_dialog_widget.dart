import 'package:classwix_orbit/Screen/GroupDetails/group_details_provider.dart';
import 'package:classwix_orbit/core/constants/colors.dart';
import 'package:classwix_orbit/core/utils/widgets/custom_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class LiveClassDialog extends ConsumerStatefulWidget {
  final TextEditingController linkController;
  final int groupId;

  const LiveClassDialog({
    super.key,
    required this.linkController,
    required this.groupId,
  });

  @override
  _LiveClassDialogState createState() => _LiveClassDialogState();
}

class _LiveClassDialogState extends ConsumerState<LiveClassDialog> {
  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
      ),
      content: Column(
        mainAxisSize: MainAxisSize.min,
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Text("Live Class Link",
              style: TextStyle(fontWeight: FontWeight.bold)),
          const SizedBox(height: 5),
          TextField(
            controller: widget.linkController,
            decoration: InputDecoration(
              hintText: "Paste your link here!",
              border: OutlineInputBorder(
                borderRadius: BorderRadius.circular(5),
              ),
            ),
          ),
          const SizedBox(height: 10),
         ],
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          style: TextButton.styleFrom(
            backgroundColor: Colors.white,
            foregroundColor: Colors.red,
          ),
          child: const Text("Cancel"),
        ),
        TextButton(
          onPressed: () async {
            String link = widget.linkController.text.trim();
            if (link.isNotEmpty) {
              try {
                await ref
                    .read(groupDetailsProvider(widget.groupId).notifier)
                    .submitLiveClassLink(link, "sample");

                ScaffoldMessenger.of(context).showSnackBar(
                  const SnackBar(
                    content: Text(
                      "Live class link saved successfully!",
                      style: TextStyle(color: AppColors.white),
                    ),
                    backgroundColor: Colors.green,
                    duration: Duration(seconds: 2),
                  ),
                );
              } catch (e) {
                CustomSnackBar.showSnackBar(
                    context, e.toString(), SnackBarType.failure);
              }
            } else {
              ScaffoldMessenger.of(context).showSnackBar(
                const SnackBar(
                  content: Text(
                    "Please fill all fields",
                    style: TextStyle(color: AppColors.white),
                  ),
                  backgroundColor: Colors.red,
                  duration: Duration(seconds: 2),
                ),
              );
            }
            Navigator.pop(context);
          },
          style: TextButton.styleFrom(
            backgroundColor: Colors.green,
            foregroundColor: Colors.white,
          ),
          child: const Text("Submit"),
        ),
      ],
    );
  }
}
