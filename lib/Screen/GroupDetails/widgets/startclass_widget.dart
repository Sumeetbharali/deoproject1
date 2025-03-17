import 'dart:convert';
import 'package:classwix_orbit/Screen/GroupDetails/group_details_provider.dart';
import 'package:classwix_orbit/core/constants/styles.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:url_launcher/url_launcher.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../../core/constants/colors.dart';
import '../../../core/constants/copies.dart';
import '../../../core/utils/widgets/custom_snack_bar.dart';
import '../../../provider/sample_provider.dart';

class GroupClasscode extends ConsumerStatefulWidget {
  final int groupId;
  const GroupClasscode({
    required this.groupId,
    super.key,
  });

  @override
  _GroupClasscodeState createState() => _GroupClasscodeState();
}

class _GroupClasscodeState extends ConsumerState<GroupClasscode> {
  final TextEditingController linkController = TextEditingController();
  final TextEditingController timeController = TextEditingController();
  String? selectedTimeWarning;
  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final groupState = ref.read(groupDetailsProvider(widget.groupId));
      if (groupState.liveClassLink != null) {
        linkController.text = groupState.liveClassLink!;
      }
    });
  }

  String classCode = "#########";
  String? startTime;
  bool classStarted = false;

  void _startClass() async {
    setState(() {
      classCode = "#########"; // Default value while fetching
    });

    try {
      final authToken = ref.read(sampleProvider);
      final String apiUrl =
          "https://api.classwix.com/api/groups/${widget.groupId}";

      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          "Authorization": "Bearer $authToken",
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final String? fetchedClassCode = data["class_code"];
        logger.i("Fetched class code: $fetchedClassCode");

        setState(() {
          classCode =
              fetchedClassCode ?? "#########"; // If null, show "#########"
        });
      } else {
        throw Exception("Failed to fetch class code");
      }
    } catch (e) {
      logger.e("Error fetching class code: $e");
      setState(() {
        classCode = "#########"; // Keep default if API fails
      });
    }

    await showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(10),
          ),
          content: StatefulBuilder(
            builder: (BuildContext context, StateSetter setState) {
              return Column(
                mainAxisSize: MainAxisSize.min,
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Text(
                    "Live Class Code",
                    style: TextStyle(fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 5),
                  Text(
                    classCode,
                    style: const TextStyle(
                        fontSize: 18, fontWeight: FontWeight.bold),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    controller: linkController,
                    decoration: InputDecoration(
                      hintText: "Paste your link here!",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                  ),
                  const SizedBox(height: 10),
                  TextField(
                    onTap: () async {
                      TimeOfDay now = TimeOfDay.now(); // Get current time
                      TimeOfDay? pickedTime = await showTimePicker(
                        helpText: "Select a Time",
                        cancelText: "Close",
                        confirmText: "Set Time",
                        hourLabelText: "Hour",
                        minuteLabelText: "Minute",
                        context: context,
                        initialTime: now,
                      );

                      if (pickedTime != null) {
                        String formattedTime = pickedTime.format(context);

                        Future.delayed(Duration.zero, () {
                          setState(() {
                            timeController.text = formattedTime;

                            DateTime nowDateTime = DateTime.now();
                            DateTime pickedDateTime = DateTime(
                              nowDateTime.year,
                              nowDateTime.month,
                              nowDateTime.day,
                              pickedTime.hour,
                              pickedTime.minute,
                            );

                            if (pickedDateTime.isBefore(nowDateTime)) {
                              selectedTimeWarning = AppCopies.timefalls;
                            } else {
                              selectedTimeWarning = null;
                            }
                          });
                        });
                      }
                    },
                    controller: timeController,
                    decoration: InputDecoration(
                      hintText: "Class Time",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    readOnly: true,
                  ),
                  const SizedBox(height: 10),
                  if (selectedTimeWarning != null)
                    Text(
                      selectedTimeWarning!,
                      style: const TextStyle(color: AppColors.red),
                    ),
                ],
              );
            },
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
                String link = linkController.text.trim();
                String classTime = timeController.text.trim();

                if (link.isNotEmpty && classTime.isNotEmpty) {
                  try {
                    await ref
                        .read(groupDetailsProvider(widget.groupId).notifier)
                        .submitLiveClassLink(link, classTime);
                    classStarted = true;

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
      },
    );
  }

  /// ----------using random code generation----------
//  void _startClass() async {
//     const chars = AppCopies.randomChar;
//     final random = Random();
//     String generatedCode =
//         List.generate(8, (index) => chars[random.nextInt(chars.length)]).join();

//     String formattedTime = DateFormat('hh:mm a').format(DateTime.now());

//     setState(() {
//       classCode = generatedCode;
//       startTime = formattedTime;
//     });

//     await showDialog(
//       context: context,
//       builder: (BuildContext context) {
//         return AlertDialog(
//           shape: RoundedRectangleBorder(
//             borderRadius: BorderRadius.circular(10),
//           ),
//           content: StatefulBuilder(
//             builder: (BuildContext context, StateSetter setState) {
//               return Column(
//                 mainAxisSize: MainAxisSize.min,
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   const Text(
//                     "Live Class Link",
//                     style: TextStyle(fontWeight: FontWeight.bold),
//                   ),
//                   const SizedBox(height: 5),
//                   TextField(
//                     controller: linkController,
//                     decoration: InputDecoration(
//                       hintText: "Paste your link here!",
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(5),
//                       ),
//                     ),
//                   ),
//                   const SizedBox(height: 10),
//                   TextField(
//                     onTap: () async {
//                       TimeOfDay now = TimeOfDay.now(); // Get current time
//                       TimeOfDay? pickedTime = await showTimePicker(
//                         helpText: "Select a Time",
//                         cancelText: "Close",
//                         confirmText: "Set Time",
//                         hourLabelText: "Hour",
//                         minuteLabelText: "Minute",
//                         context: context,
//                         initialTime: now,
//                       );

//                       if (pickedTime != null) {
//                         String formattedTime = pickedTime.format(context);

//                         Future.delayed(Duration.zero, () {
//                           setState(() {
//                             timeController.text = formattedTime;

//                             DateTime nowDateTime = DateTime.now();
//                             DateTime pickedDateTime = DateTime(
//                               nowDateTime.year,
//                               nowDateTime.month,
//                               nowDateTime.day,
//                               pickedTime.hour,
//                               pickedTime.minute,
//                             );

//                             if (pickedDateTime.isBefore(nowDateTime)) {
//                               selectedTimeWarning = AppCopies.timefalls;
//                             } else {
//                               selectedTimeWarning = null;
//                             }
//                           });
//                         });
//                       }
//                     },
//                     controller: timeController,
//                     decoration: InputDecoration(
//                       hintText: "Class Time",
//                       border: OutlineInputBorder(
//                         borderRadius: BorderRadius.circular(5),
//                       ),
//                     ),
//                     readOnly: true,
//                   ),
//                   const SizedBox(height: 10),
//                   if (selectedTimeWarning != null)
//                     Text(
//                       selectedTimeWarning!,
//                       style: const TextStyle(color: AppColors.red),
//                     ),
//                 ],
//               );
//             },
//           ),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               style: TextButton.styleFrom(
//                 backgroundColor: Colors.white,
//                 foregroundColor: Colors.red,
//               ),
//               child: const Text("Cancel"),
//             ),
//             TextButton(
//               onPressed: () async {
//                 String link = linkController.text.trim();
//                 String classTime = timeController.text.trim();

//                 if (link.isNotEmpty && classTime.isNotEmpty) {
//                   // if (link.isNotEmpty ) {
//                   try {
//                     await ref
//                         .read(groupDetailsProvider(widget.groupId).notifier)
//                         .submitLiveClassLink(link, classTime);
//                     // .submitLiveClassLink(link);
//                     classStarted = true;

//                     ScaffoldMessenger.of(context).showSnackBar(
//                       const SnackBar(
//                         content: Text(
//                           "Live class link saved successfully!",
//                           style: TextStyle(color: AppColors.white),
//                         ),
//                         backgroundColor: Colors.green,
//                         duration: Duration(seconds: 2),
//                       ),
//                     );
//                   } catch (e) {
//                     CustomSnackBar.showSnackBar(
//                         context, e.toString(), SnackBarType.failure);
//                   }
//                 } else {
//                   ScaffoldMessenger.of(context).showSnackBar(
//                     const SnackBar(
//                       content: Text(
//                         "Please fill all fields",
//                         style: TextStyle(color: AppColors.white),
//                       ),
//                       backgroundColor: Colors.red,
//                       duration: Duration(seconds: 2),
//                     ),
//                   );
//                 }
//                 Navigator.pop(context);
//               },
//               style: TextButton.styleFrom(
//                 backgroundColor: Colors.green,
//                 foregroundColor: Colors.white,
//               ),
//               child: const Text("Submit"),
//             ),
//           ],
//         );
//       },
//     );
//   }

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
