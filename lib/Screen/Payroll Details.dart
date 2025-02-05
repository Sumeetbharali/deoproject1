import 'package:flutter/material.dart';

class PaymentsScreen extends StatelessWidget {
  final List<Map<String, dynamic>> payments = [
    {
      "group": "Advanced Mathematics",
      "creditDate": "2024-02-15",
      "reference": "REF2024021501",
      "classes": 8,
      "perClass": 45.00,
      "totalAmount": 360.00,
    },
    {
      "group": "Physics Foundation",
      "creditDate": "2024-02-14",
      "reference": "REF2024021402",
      "classes": 6,
      "perClass": 50.00,
      "totalAmount": 300.00,
    },
    {
      "group": "Chemistry Lab",
      "creditDate": "2024-02-13",
      "reference": "REF2024021303",
      "classes": 4,
      "perClass": 55.00,
      "totalAmount": 220.00,
    },
    {
      "group": "Biology Advanced",
      "creditDate": "2024-02-12",
      "reference": "REF2024021204",
      "classes": 10,
      "perClass": 40.00,
      "totalAmount": 400.00,
    },
  ];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text("Payments"),
        actions: [IconButton(onPressed: () {}, icon: Icon(Icons.filter_list))],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          children: [
            TextField(
              decoration: InputDecoration(
                prefixIcon: Icon(Icons.search),
                hintText: "Search payments...",
                border: OutlineInputBorder(
                  borderRadius: BorderRadius.circular(10),
                  borderSide: BorderSide.none,
                ),
                filled: true,
                fillColor: Colors.grey[200],
              ),
            ),
            SizedBox(height: 10),
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                FilterChip(label: Text("All"), onSelected: (val) {}),
                FilterChip(label: Text("This Month"), onSelected: (val) {}),
                FilterChip(label: Text("Last Month"), onSelected: (val) {}),
                FilterChip(label: Text("Custom Range"), onSelected: (val) {}),
              ],
            ),
            SizedBox(height: 10),
            Expanded(
              child: ListView.builder(
                itemCount: payments.length,
                itemBuilder: (context, index) {
                  final payment = payments[index];
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
                            style: TextStyle(
                              fontSize: 18,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                          SizedBox(height: 5),
                          Row(
                            children: [
                              Icon(Icons.calendar_today, size: 16),
                              SizedBox(width: 5),
                              Text("Credit Date: ${payment["creditDate"]}"),
                            ],
                          ),
                          Row(
                            children: [
                              Icon(Icons.receipt, size: 16),
                              SizedBox(width: 5),
                              Text("Ref: ${payment["reference"]}"),
                            ],
                          ),
                          Row(
                            children: [
                              Icon(Icons.book, size: 16),
                              SizedBox(width: 5),
                              Text("Classes: ${payment["classes"]}"),
                            ],
                          ),
                          Row(
                            children: [
                              Icon(Icons.monetization_on, size: 16),
                              SizedBox(width: 5),
                              Text("Per Class: \$${payment["perClass"]}"),
                            ],
                          ),
                          Align(
                            alignment: Alignment.centerRight,
                            child: Text(
                              "\$${payment["totalAmount"]}",
                              style: TextStyle(
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


