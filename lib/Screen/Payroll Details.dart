// import 'package:flutter/material.dart';

// class PaymentsScreen extends StatelessWidget {
//   final List<Map<String, dynamic>> payments = [
//     {
//       "group": "Advanced Mathematics",
//       "creditDate": "2024-02-15",
//       "reference": "REF2024021501",
//       "classes": 8,
//       "perClass": 45.00,
//       "totalAmount": 360.00,
//     },
//     {
//       "group": "Physics Foundation",
//       "creditDate": "2024-02-14",
//       "reference": "REF2024021402",
//       "classes": 6,
//       "perClass": 50.00,
//       "totalAmount": 300.00,
//     },
//     {
//       "group": "Chemistry Lab",
//       "creditDate": "2024-02-13",
//       "reference": "REF2024021303",
//       "classes": 4,
//       "perClass": 55.00,
//       "totalAmount": 220.00,
//     },
//     {
//       "group": "Biology Advanced",
//       "creditDate": "2024-02-12",
//       "reference": "REF2024021204",
//       "classes": 10,
//       "perClass": 40.00,
//       "totalAmount": 400.00,
//     },
//   ];

//    PaymentsScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text("Payments"),
//         backgroundColor: Colors.white,
//         actions: [IconButton(onPressed: () {}, icon: const Icon(Icons.filter_list))],
//       ),
//       body: Padding(
//         padding: const EdgeInsets.all(16.0),
//         child: Column(
//           children: [
//             TextField(
//               decoration: InputDecoration(
//                 prefixIcon: const Icon(Icons.search),
//                 hintText: "Search payments...",
//                 border: OutlineInputBorder(
//                   borderRadius: BorderRadius.circular(10),
//                   borderSide: BorderSide.none,
//                 ),
//                 filled: true,
//                 fillColor: Colors.grey[200],
//               ),
//             ),
//             const SizedBox(height: 10),
//             Row(
//               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//               children: [
//                 FilterChip(label: const Text("All"), onSelected: (val) {}),
//                 FilterChip(label: const Text("This Month"), onSelected: (val) {}),
//                 FilterChip(label: const Text("Last Month"), onSelected: (val) {}),
//                 FilterChip(label: const Text("Custom Range"), onSelected: (val) {}),
//               ],
//             ),
//             const SizedBox(height: 10),
//             Expanded(
//               child: ListView.builder(
//                 itemCount: payments.length,
//                 itemBuilder: (context, index) {
//                   final payment = payments[index];
//                   return Card(
//                     elevation: 2,
//                     shape: RoundedRectangleBorder(
//                       borderRadius: BorderRadius.circular(10),
//                     ),
//                     child: Padding(
//                       padding: const EdgeInsets.all(16.0),
//                       child: Column(
//                         crossAxisAlignment: CrossAxisAlignment.start,
//                         children: [
//                           Text(
//                             payment["group"],
//                             style: const TextStyle(
//                               fontSize: 18,
//                               fontWeight: FontWeight.bold,
//                             ),
//                           ),
//                           const SizedBox(height: 5),
//                           Row(
//                             children: [
//                               const Icon(Icons.calendar_today, size: 16),
//                               const SizedBox(width: 5),
//                               Text("Credit Date: ${payment["creditDate"]}"),
//                             ],
//                           ),
//                           Row(
//                             children: [
//                               const Icon(Icons.receipt, size: 16),
//                               const SizedBox(width: 5),
//                               Text("Ref: ${payment["reference"]}"),
//                             ],
//                           ),
//                           Row(
//                             children: [
//                               const Icon(Icons.book, size: 16),
//                               const SizedBox(width: 5),
//                               Text("Classes: ${payment["classes"]}"),
//                             ],
//                           ),
//                           Row(
//                             children: [
//                               const Icon(Icons.monetization_on, size: 16),
//                               const SizedBox(width: 5),
//                               Text("Per Class: \$${payment["perClass"]}"),
//                             ],
//                           ),
//                           Align(
//                             alignment: Alignment.centerRight,
//                             child: Text(
//                               "\$${payment["totalAmount"]}",
//                               style: const TextStyle(
//                                 fontSize: 18,
//                                 fontWeight: FontWeight.bold,
//                                 color: Colors.blue,
//                               ),
//                             ),
//                           ),
//                         ],
//                       ),
//                     ),
//                   );
//                 },
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }
// }


import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';

class PaymentsScreen extends StatefulWidget {
  const PaymentsScreen({super.key});

  @override
  State<PaymentsScreen> createState() => _PaymentsScreenState();
}

class _PaymentsScreenState extends State<PaymentsScreen> {
  List<Map<String, dynamic>> allPayments = []; // Stores all fetched payments
  List<Map<String, dynamic>> filteredPayments = []; // Stores filtered payments
  bool isLoading = true;
  TextEditingController searchController = TextEditingController(); // Search Controller

  @override
  void initState() {
    super.initState();
    fetchPayments();
  }

  Future<void> fetchPayments() async {
    const String apiUrl = "https://api.classwix.com/api/admin/payrolls";
    const String apiKey = "Bearer 707|H2qmW2qVfMyoHY606J5MzzXpsb2kjJHgOkwjBMIub4d270ce";

    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          "Authorization": apiKey,
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> apiPayments = data["payments"];

        setState(() {
          allPayments = apiPayments.map((payment) {
            return {
              "group": payment["group"]["name"],
              "creditDate": payment["created_at"].split("T")[0],
              "reference": payment["transaction"],
              "classes": payment["no_of_classes"],
              "perClass": double.parse(payment["per_class_payment"]),
              "totalAmount": double.parse(payment["total_amount"]),
            };
          }).toList();

          filteredPayments = List.from(allPayments); // Initially, show all payments
          isLoading = false;
        });
      } else {
        throw Exception("Failed to load payments");
      }
    } catch (e) {
      debugPrint("Error fetching payments: $e");
      setState(() {
        isLoading = false;
      });
    }
  }

  void filterPayments(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredPayments = List.from(allPayments); // Reset to all data
      } else {
        filteredPayments = allPayments
            .where((payment) =>
                payment["group"].toLowerCase().contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text("Payments"),
        backgroundColor: Colors.white,
        actions: [
          IconButton(
            onPressed: fetchPayments, // Refresh payments when clicked
            icon: const Icon(Icons.refresh),
          )
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              controller: searchController,
              onChanged: filterPayments, // Calls filter function on text change
              decoration: InputDecoration(
                prefixIcon: const Icon(Icons.search),
                hintText: "Search by Group Name...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
            ),
            const SizedBox(height: 10),

            if (isLoading)
              const Center(child: CircularProgressIndicator())
            else if (filteredPayments.isEmpty)
              const Center(child: Text("No payments found"))
            else
              Expanded(
                child: ListView.builder(
                  itemCount: filteredPayments.length,
                  itemBuilder: (context, index) {
                    final payment = filteredPayments[index];
                    return Card(
                      elevation: 2,
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(10),
                      ),
                      child: Padding(
                        padding: const EdgeInsets.all(16.0),
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            Text(
                              payment["group"],
                              style: const TextStyle(
                                fontSize: 18,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            const SizedBox(height: 5),
                            Row(
                              children: [
                                const Icon(Icons.calendar_today, size: 16),
                                const SizedBox(width: 5),
                                Text("Credit Date: ${payment["creditDate"]}"),
                              ],
                            ),
                            Row(
                              children: [
                                const Icon(Icons.receipt, size: 16),
                                const SizedBox(width: 5),
                                Text("Ref: ${payment["reference"]}"),
                              ],
                            ),
                            Row(
                              children: [
                                const Icon(Icons.book, size: 16),
                                const SizedBox(width: 5),
                                Text("Classes: ${payment["classes"]}"),
                              ],
                            ),
                            Row(
                              children: [
                                const Icon(Icons.monetization_on, size: 16),
                                const SizedBox(width: 5),
                                Text("Per Class: \$${payment["perClass"]}"),
                              ],
                            ),
                            Align(
                              alignment: Alignment.centerRight,
                              child: Text(
                                "\$${payment["totalAmount"]}",
                                style: const TextStyle(
                                  fontSize: 18,
                                  fontWeight: FontWeight.bold,
                                  color: Colors.blue,
                                ),
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  },
                ),
              ),
          ],
        ),
      ),
    );
  }
}
