import 'package:classwix_orbit/Screen/Payment/Payment_details.dart';
import 'package:classwix_orbit/controller/auth_controller.dart';
import 'package:classwix_orbit/core/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PaymentsScreen extends ConsumerStatefulWidget {
  const PaymentsScreen({super.key});

  @override
  _PaymentsScreenState createState() => _PaymentsScreenState();
}

class _PaymentsScreenState extends ConsumerState<PaymentsScreen> {
  List<Map<String, dynamic>> allPayments = [];
  List<Map<String, dynamic>> filteredPayments = [];
  int? groupidentity;
  bool isLoading = true;
  TextEditingController searchController = TextEditingController();

  @override
  void initState() {
    super.initState();
    Future.microtask(() {
      final userData = ref.read(authProvider);
      groupidentity = userData?.user.id;

      if (groupidentity != null) {
        fetchPayments();
      }
    });
  }

  Future<void> fetchPayments() async {
    setState(() {
      isLoading = true;
    });

    final paymentsRepo = ref.read(paymentsRepositoryProvider);
    final fetchedPayments =
        await paymentsRepo.fetchPayments(context, groupidentity);

    setState(() {
      allPayments = fetchedPayments;
      filteredPayments = List.from(fetchedPayments);
      isLoading = false;
    });
  }

  void filterPayments(String query) {
    setState(() {
      if (query.isEmpty) {
        filteredPayments = List.from(allPayments);
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
    final userData = ref.watch(authProvider);
    if (groupidentity == null && userData?.user.id != null) {
      setState(() {
        groupidentity = userData?.user.id;
        fetchPayments();
      });
    }
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
        onRefresh: fetchPayments,
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => FocusScope.of(context).unfocus(),
          child: Padding(
            padding: const EdgeInsets.all(16.0),
            child: Column(
              children: [
                TextField(
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
                
                const SizedBox(height: 10),
                if (isLoading)
                  const Center(child: CircularProgressIndicator())
                else if (filteredPayments.isEmpty)
                  const Center(child: Text("No payments found for this group"))
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
                                  const SizedBox(height: 5),
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
                                  const SizedBox(height: 5),
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
                                  const SizedBox(height: 10),
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
