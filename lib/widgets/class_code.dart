// import 'dart:math';

// import 'package:classwix_orbit/core/constants/styles.dart';
// import 'package:flutter/foundation.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter/widgets.dart';
// import 'package:url_launcher/url_launcher.dart';
// import 'package:intl/intl.dart';

// class ClassCode extends StatefulWidget {
//   final bool classStarted;
//   final String classCode;
//   const ClassCode({super.key, required this.classStarted, required this.classCode});

//   @override
//   State<ClassCode> createState() => _ClassCodeState();
// }

// class _ClassCodeState extends State<ClassCode> {
//   @override
//   Widget build(BuildContext context) {
//     void _startClass() {
//     const chars = "abcdefghijklmnopqrstuvwxyz0123456789@#";
//     final random = Random();
//     String generatedCode =
//         List.generate(8, (index) => chars[random.nextInt(chars.length)]).join();

//     // Get current time
//     String formattedTime = DateFormat('hh:mm a').format(DateTime.now());

//     // Update UI with class code and time
//     setState(() {
//       classCode = generatedCode;
//       startTime = formattedTime;
//       classStarted = true; // Set class as started
//     });

//     // Show dialog confirming the class has started
//     showDialog(
//       context: context,
//       builder: (context) {
//         return AlertDialog(
//           title: const Text("Class Started"),
//           content: Text(
//               "Class has started at $formattedTime\nClass Code: $generatedCode"),
//           actions: [
//             TextButton(
//               onPressed: () => Navigator.pop(context),
//               child: const Text("OK"),
//             ),
//           ],
//         );
//       },
//     );
//   }

//     return Column(
//       mainAxisAlignment: MainAxisAlignment.end,
//       crossAxisAlignment: CrossAxisAlignment.end,
//       children: [
//         if (widget.classStarted) ...[
//           Row(
//             crossAxisAlignment: CrossAxisAlignment.end,
//             mainAxisAlignment: MainAxisAlignment.end,
//             children: [
//               Padding(
//                 padding: const EdgeInsets.only(top: 10.0),
//                 child: Container(
//                   width: MediaQuery.of(context).size.width * 0.3,
//                   height: 37,
//                   decoration: const BoxDecoration(
//                     borderRadius: BorderRadius.all(Radius.circular(5)),
//                     gradient: LinearGradient(
//                       colors: [Colors.blue, Colors.green], // Example gradient
//                     ),
//                   ),
//                   child: TextButton(
//                     style: TextButton.styleFrom(
//                       foregroundColor: Colors.white,
//                       overlayColor: Colors.white.withOpacity(0.2),
//                       shape: RoundedRectangleBorder(
//                         borderRadius: BorderRadius.circular(5),
//                       ),
//                     ),
//                     // onPressed: () => _joinClass(),
//                     onPressed: () =>
//                         launch("https://meet.google.com/acm-zvtb-yby"),
//                     // onPressed: () => launch(linkController.text), //dynamic

//                     child: const Center(
//                       child: Text(
//                         "Join Class", // Button label
//                         style: TextStyle(
//                           color: Colors.white,
//                           fontWeight: FontWeight.bold,
//                           fontSize: 13,
//                         ),
//                       ),
//                     ),
//                   ),
//                 ),
//               ),
//             ],
//           ),

//           //
//         ] else ...[
//           Row(
//             crossAxisAlignment: CrossAxisAlignment.end,
//             mainAxisAlignment: MainAxisAlignment.end,
//             children: [
//               const Text("Class Code: ",
//                   style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
//               const SizedBox(height: 10),
//               Container(
//                 margin: const EdgeInsets.only(left: 2),
//                 padding: const EdgeInsets.all(4),
//                 decoration: BoxDecoration(
//                   border:
//                       Border.all(style: BorderStyle.solid, color: Colors.grey),
//                 ),
//                 child: Text(
//                   widget.classCode, // Dynamically updated class code
//                   style: const TextStyle(
//                     color: Colors.blueGrey,
//                   ),
//                   softWrap: true,
//                 ),
//               ),
//             ],
//           ),
//           Padding(
//             padding: const EdgeInsets.only(top: 10.0),
//             child: Container(
//               width: MediaQuery.of(context).size.width * 0.3,
//               height: 37,
//               decoration: const BoxDecoration(
//                   borderRadius: BorderRadius.all(Radius.circular(5)),
//                   gradient: AppStyles.startClassGradient),
//               child: TextButton(
//                 style: TextButton.styleFrom(
//                   foregroundColor: Colors.white,
//                   overlayColor: Colors.white.withOpacity(0.2),
//                   shape: RoundedRectangleBorder(
//                     borderRadius: BorderRadius.circular(5),
//                   ),
//                 ),
//                 onPressed: _startClass, // Call function to start class
//                 child: const Center(
//                   child: Text(
//                     "Start Class", // Button label
//                     style: TextStyle(
//                       color: Colors.white,
//                       fontWeight: FontWeight.bold,
//                       fontSize: 13,
//                     ),
//                   ),
//                 ),
//               ),
//             ),
//           ),
//         ],
//       ],
//     );
//     ;
//   }
// }
