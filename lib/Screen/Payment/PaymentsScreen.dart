import 'package:classwix_orbit/core/constants/colors.dart';
import 'package:classwix_orbit/core/utils/widgets/custom_snack_bar.dart';
import 'package:classwix_orbit/provider/sample_provider.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'dart:convert';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PaymentsScreen extends ConsumerStatefulWidget {
  const PaymentsScreen({super.key});

  @override
  _PaymentsScreenState createState() => _PaymentsScreenState();
}

class _PaymentsScreenState extends ConsumerState<PaymentsScreen> {
  List<Map<String, dynamic>> allPayments = [];
  List<Map<String, dynamic>> filteredPayments = [];
  bool isLoading = true;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    fetchPayments();
  }

  Future<void> fetchPayments() async {
    setState(() {
      isLoading = true;
    });

    final authToken = ref.read(sampleProvider);
    const String apikey = "https://api.classwix.com/api/admin/payrolls";

    try {
      final response = await http.get(
        Uri.parse(apikey),
        headers: {
          "Authorization": "Bearer $authToken",
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> apiPayments = data["payments"];

        setState(() {
          allPayments = apiPayments.map((payment) {
            return {
              "instructorName": payment["user"]?["name"] ?? "N/A",
              "email": payment["user"]?["email"] ?? "N/A",
              "phone": payment["user"]?["phone"] ?? "N/A",
              "classes": payment["no_of_classes"] ?? "0",
              "month": payment["month"] ?? "N/A",
              "year": payment["year"] ?? "N/A",
              "creditDate": payment["created_at"] != null
                  ? payment["created_at"].split("T")[0]
                  : "N/A",
              "totalAmount": payment["total_amount"] ?? "0",
            };
          }).toList();

          filteredPayments = List.from(allPayments);
          isLoading = false;
        });
      } else {
        throw Exception("Failed to load payments");
      }
    } catch (e) {
      CustomSnackBar.showSnackBar(
          context, "Error fetching payments: $e", SnackBarType.failure);
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
            .where((payment) => payment["instructorName"]
                .toString()
                .toLowerCase()
                .contains(query.toLowerCase()))
            .toList();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          "Payments",
          style: TextStyle(
              color: AppColors.black,
              fontSize: 20,
              fontWeight: FontWeight.bold),
        ),
        backgroundColor: Colors.white,
      ),
      body: RefreshIndicator(
        onRefresh: () async {
          await fetchPayments();
        },
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () {
            FocusScope.of(context).unfocus();
          },
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                Container(
                  height: 40,
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(20),
                  ),
                  child: TextField(
                    controller: searchController,
                    onChanged: filterPayments,
                    decoration: InputDecoration(
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide.none,
                      ),
                      prefixIcon: const Icon(Icons.search),
                      hintText: "Search by Instructor Name...",
                      enabledBorder: const UnderlineInputBorder(
                          borderSide: BorderSide.none),
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(20),
                        borderSide: BorderSide.none,
                      ),
                      filled: true,
                      fillColor: AppColors.appbar.withOpacity(0.1),
                    ),
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
                          elevation: 5,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(16),
                          ),
                          child: Container(
                            decoration: BoxDecoration(
                                borderRadius: BorderRadius.circular(16),
                                color: AppColors.appbar),
                            child: Padding(
                              padding: const EdgeInsets.all(14.0),
                              child: Column(
                                crossAxisAlignment: CrossAxisAlignment.start,
                                children: [
                                  const SizedBox(height: 15),
                                  Row(
                                    mainAxisAlignment:
                                        MainAxisAlignment.spaceBetween,
                                    children: [
                                      Text(
                                        payment["instructorName"].toString(),
                                        style: const TextStyle(
                                          fontSize: 20,
                                          fontWeight: FontWeight.bold,
                                          color: AppColors.white,
                                        ),
                                      ),
                                      Text(
                                        payment["creditDate"].toString(),
                                        style: const TextStyle(
                                          color: AppColors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 10),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.mail_outline_rounded,
                                        size: 16,
                                        color: AppColors.white,
                                      ),
                                      const SizedBox(width: 5),
                                      Text(
                                        "Email: ${payment["email"]}",
                                        style: const TextStyle(
                                          color: AppColors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.local_phone_rounded,
                                        size: 16,
                                        color: AppColors.white,
                                      ),
                                      const SizedBox(width: 5),
                                      Text(
                                        "Phone: ${payment["phone"]}",
                                        style: const TextStyle(
                                          color: AppColors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.calendar_month_sharp,
                                        size: 16,
                                        color: AppColors.white,
                                      ),
                                      const SizedBox(width: 5),
                                      Text(
                                        "Month: ${payment["month"]} / ${payment["year"]}",
                                        style: const TextStyle(
                                          color: AppColors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(height: 5),
                                  Row(
                                    children: [
                                      const Icon(
                                        Icons.book,
                                        size: 16,
                                        color: AppColors.white,
                                      ),
                                      const SizedBox(width: 5),
                                      Text(
                                        "Classes: ${payment["classes"]}",
                                        style: const TextStyle(
                                          color: AppColors.white,
                                        ),
                                      ),
                                    ],
                                  ),
                                  const SizedBox(
                                    height: 5,
                                  ),
                                  const SizedBox(height: 5),
                                  Align(
                                    alignment: Alignment.centerRight,
                                    child: Text(
                                      "\$${payment["totalAmount"]}",
                                      style: const TextStyle(
                                        fontFamily: 'Varela',
                                        fontSize: 22,
                                        fontWeight: FontWeight.bold,
                                        color: Colors.white,
                                      ),
                                    ),
                                  ),
                                ],
                              ),
                            ),
                          ),
                        );
                      },
                    ),
                  ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
