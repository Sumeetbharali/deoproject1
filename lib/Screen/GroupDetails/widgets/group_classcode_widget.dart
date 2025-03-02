import 'dart:math';
import 'package:classwix_orbit/Screen/GroupDetails/group_details_provider.dart';
import 'package:classwix_orbit/core/constants/styles.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:intl/intl.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
class GroupClasscode extends ConsumerStatefulWidget {
  final int groupId;
  const GroupClasscode( {required this.groupId,
    super.key,
  });

  @override
  _GroupClasscodeState createState() => _GroupClasscodeState();
}

class _GroupClasscodeState extends ConsumerState<GroupClasscode> {
  String classCode = "#########";
  String? startTime;
  bool classStarted = false;
  void _startClass() {
    const chars = "abcdefghijklmnopqrstuvwxyz0123456789@#";
    final random = Random();
    String generatedCode =
        List.generate(8, (index) => chars[random.nextInt(chars.length)]).join();

    String formattedTime = DateFormat('hh:mm a').format(DateTime.now());

    setState(() {
      classCode = generatedCode;
      startTime = formattedTime;
      classStarted = true;
    });

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Class Started"),
          content: Text(
              "Class has started at $formattedTime\nClass Code: $generatedCode"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
  TextEditingController linkController = TextEditingController();
  final groupState = ref.watch(groupDetailsProvider(widget.groupId));
    linkController.text = groupState.liveClassLink.toString();
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const Text("Class Code: ",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Container(
              margin: const EdgeInsets.only(left: 2),
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                border:
                    Border.all(style: BorderStyle.solid, color: Colors.grey),
              ),
              child: Text(
                classCode,
                style: const TextStyle(
                  color: Colors.blueGrey,
                ),
                softWrap: true,
              ),
            ),
          ],
        ),
        if (classStarted) ...[
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.3,
                  height: 37,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    gradient: LinearGradient(
                      colors: [Colors.blue, Colors.green],
                    ),
                  ),
                  child: TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                      overlayColor: Colors.white.withOpacity(0.2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    onPressed: () {
                      launch(linkController.text);
                    },
                    child: const Center(
                      child: Text(
                        "Join Class", 
                        style: TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 13,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
            ],
          ),
        ] else ...[
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.3,
              height: 37,
              decoration: const BoxDecoration(
                  borderRadius: BorderRadius.all(Radius.circular(5)),
                  gradient: AppStyles.startClassGradient),
              child: TextButton(
                style: TextButton.styleFrom(
                  foregroundColor: Colors.white,
                  overlayColor: Colors.white.withOpacity(0.2),
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(5),
                  ),
                ),
                onPressed: _startClass,
                child: const Center(
                  child: Text(
                    "Start Class",
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 13,
                    ),
                  ),
                ),
              ),
            ),
          ),
        ],
      ],
    );
  }
}
