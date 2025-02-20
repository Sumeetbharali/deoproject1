import 'dart:convert';

import 'package:classwix_orbit/core/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:http/http.dart' as http;

import '../main.dart';

class LiveInformation extends StatefulWidget {
  final TextEditingController linkController;
  final TextEditingController timeController;
  final int groupId;

  const LiveInformation({super.key, required this.linkController, required this.timeController, required this.groupId});

  @override
  State<LiveInformation> createState() => _LiveInformationState();
}

class _LiveInformationState extends State<LiveInformation> {
  void _fetchLiveClassLink() async {
    String? url =
        "https://api.classwix.com/api/groups/${widget.groupId}/live-class";
    final response = await http.get(Uri.parse(url));
    if (response.statusCode == 200) {
      widget.linkController.text = jsonDecode(response.body)['live_class_link'];
      logger.i("Hari ${widget.linkController.text}");
    }
  }

  Future<void> submitLiveClassLink(
      String liveClassLink, String classTime) async {
    final prefs = await SharedPreferences.getInstance();
    final String? tokenCred = prefs.getString('token');
    String? url =
        "https://api.classwix.com/api/groups/${widget.groupId}/live-class";
    String token = "Bearer ${tokenCred.toString()}";

    try {
      final response = await http.post(
        Uri.parse(url),
        headers: {
          "Content-Type": "application/json",
          "Authorization": "Bearer $token",
        },
        body: jsonEncode({
          "live_class_link": liveClassLink,
          "class_time": classTime,
        }),
      );

      if (response.statusCode == 200 || response.statusCode == 201) {
        debugPrint("Live class link saved successfully!");
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
      } else {
        debugPrint("Failed to save link: ${response.body}");
      }
    } catch (e) {
      debugPrint("Error submitting live class link: $e");
    }
  }

  void _showLiveClassDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
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
              TextField(
                onTap: () {
                  showTimePicker(
                    helpText: "Select a Time",
                    cancelText: "Close",
                    confirmText: "Set Time",
                    hourLabelText: "Hour",
                    minuteLabelText: "Minute",
                    builder: (context, child) {
                      return Theme(
                        data: ThemeData.light().copyWith(
                            primaryColor: Colors.blue,
                            cardColor: AppColors.white,
                            timePickerTheme: TimePickerThemeData(
                              backgroundColor: Colors.white,
                              hourMinuteTextColor: Colors.black,
                              dialHandColor: AppColors.lightPurp,
                              dialTextColor: Colors.black,
                            )),
                        child: child!,
                      );
                    },
                    context: context,
                    initialTime: TimeOfDay.now(),
                  ).then((value) {
                    if (value != null) {
                      widget.timeController.text = value.format(context);
                    }
                  });
                },
                controller: widget.timeController,
                decoration: InputDecoration(
                  hintText: "Class Time",
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
              ),
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
                String classTime = widget.timeController.text.trim();
                if (link.isNotEmpty && classTime.isNotEmpty) {
                  await submitLiveClassLink(link, classTime);
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
      },
    );
  }

  @override
  void initState() {
    super.initState();
    _fetchLiveClassLink();
  }

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.end,
      children: [
        const SizedBox(width: 10),
        TextButton(
          onPressed: () {
            _showLiveClassDialog(context);
          },
          style: TextButton.styleFrom(
              backgroundColor: Colors.red,
              foregroundColor: Colors.white,
              shape: RoundedRectangleBorder(
                  borderRadius: BorderRadius.circular(5))),
          child: const Row(
            children: [
              Icon(Icons.ondemand_video_rounded, color: Colors.white),
              SizedBox(width: 5),
              Text('Live Class')
            ],
          ),
        ),
      ],
    );
  }
}
