import 'dart:convert';
import 'package:classwix_orbit/Screen/MyGroup/group_model.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../core/constants/api_endpoint.dart';
import '../../provider/sample_provider.dart';

final groupControllerProvider =
    StateNotifierProvider<GroupController, List<GroupData>>(
  (ref) => GroupController(ref),
);

class GroupController extends StateNotifier<List<GroupData>> {
  final Ref ref;
  bool isLoading = true;
  bool hasError = false;

  GroupController(this.ref) : super([]) {
    fetchGroups();
  }

  Future<void> fetchGroups() async {
    isLoading = true;
    hasError = false;
    state = []; // Clear existing data

    await Future.delayed(const Duration(seconds: 1)); // Smooth refresh delay
    final authToken = ref.read(sampleProvider);
    const String apiUrl = "$mainUrl/admin/groups";

    try {
      final response = await http.get(
        Uri.parse(apiUrl),
        headers: {"Authorization": "Bearer $authToken"},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        List<GroupData> fetchedGroups = (data["groups"] as List)
            .map((group) => GroupData.fromJson(group))
            .toList();

        state = fetchedGroups;
        hasError = false;
      } else {
        throw Exception("Failed to load groups");
      }
    } catch (e) {
      hasError = true;
    } finally {
      isLoading = false;
    }
  }
}
