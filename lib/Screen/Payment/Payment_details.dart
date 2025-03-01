// import 'package:flutter/material.dart';

// class PaymentDetailsScreen extends StatelessWidget {
//   final Map<String, dynamic> payment;

//   const PaymentDetailsScreen({super.key, required this.payment});
  

//   @override
//   Widget build(BuildContext context) {
    
//     return Scaffold(
//       appBar: AppBar(
//         title: Text(payment["instructorName"] ?? "Payment Details"),
//         backgroundColor: Colors.white,
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Text(
//               "Instructor Name: ${payment["instructorName"]}",
//               style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
//             ),
//             const SizedBox(height: 10),
//             Text("Email: ${payment["email"]}"),
//             Text("Phone: ${payment["phone"]}"),
//             Text("Number of Classes: ${payment["classes"]}"),
//             Text("Month: ${payment["month"]} / ${payment["year"]}"),
//             Text("Total Amount: \$${payment["totalAmount"]}"),
//             Text("Credit Date: ${payment["creditDate"]}"),
//           ],
//         ),
//       ),
//     );
//   }
// }
