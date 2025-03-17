import 'dart:convert';
import 'package:classwix_orbit/core/constants/api_endpoint.dart';
import 'package:classwix_orbit/core/utils/widgets/custom_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/provider/sample_provider.dart';

final paymentsRepositoryProvider = Provider((ref) => PaymentsRepository(ref));

class PaymentsRepository {
  final Ref ref;
  PaymentsRepository(this.ref);

  Future<List<Map<String, dynamic>>> fetchPayments(BuildContext context, int? groupId) async {
    if (groupId == null) {
      return [];
    }

    final authToken = ref.read(sampleProvider);
    const String apiUrl = "$mainUrl/admin/payrolls";

    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {
          "Authorization": "Bearer $authToken",
          "Content-Type": "application/json",
        },
      );

      if (response.statusCode == 200) {
        final data = jsonDecode(response.body);
        final List<dynamic> apiPayments = data["payments"];

        return apiPayments
            .where((payment) => payment["instructor_id"] == groupId)
            .map((payment) {
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
      } else {
        throw Exception("Failed to load payments");
      }
    } catch (e) {
      CustomSnackBar.showSnackBar(
          context, "Error fetching payments: $e", SnackBarType.failure);
      return [];
    }
  }
}
