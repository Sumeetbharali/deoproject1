import 'dart:convert';
import 'package:classwix_orbit/Screen/GroupDetails/group_details_model.dart';
import 'package:classwix_orbit/core/constants/api_endpoint.dart';
import 'package:classwix_orbit/provider/authentication.dart';
import 'package:classwix_orbit/provider/sample_provider.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:http/http.dart' as http;

final groupDetailsProvider =
    StateNotifierProvider.family<GroupDetailsNotifier, GroupDetailsState, int>(
  (ref, groupId) => GroupDetailsNotifier(ref, groupId),
);

class GroupDetailsNotifier extends StateNotifier<GroupDetailsState> {
  final Ref ref;
  final int groupId;

  GroupDetailsNotifier(this.ref, this.groupId)
      : super(GroupDetailsState.loading()) {
    fetchData();
    fetchLiveClassLink(); 
  }

  Future<void> fetchData() async {
    state = GroupDetailsState.loading();

    try {
      final groupDetails = await fetchGroupDetails();
      final videoList = await fetchVideos();
      final materialsList = await fetchMaterials();

      state = GroupDetailsState.loaded(
          groupDetails, videoList, materialsList, state.liveClassLink);
    } catch (e) {
      state = GroupDetailsState.error();
    }
  }

  Future<Map<String, dynamic>> fetchGroupDetails() async {
    final authToken = ref.read(sampleProvider);
    final url = "$mainUrl/admin/groups/$groupId";

    final response = await http
        .get(Uri.parse(url), headers: {"Authorization": "Bearer $authToken"});

    if (response.statusCode == 200) {
      final data = json.decode(response.body);
      return data["details"] ?? {};
    } else {
      throw Exception("Failed to load group details");
    }
  }

  Future<List<dynamic>> fetchVideos() async {
    final authToken = ref.read(sampleProvider);
    final url = "$mainUrl/courses/$groupId/videos";

    final response = await http
        .get(Uri.parse(url), headers: {"Authorization": "Bearer $authToken"});

    if (response.statusCode == 200) {
      return json.decode(response.body);
    } else {
      throw Exception("Failed to fetch videos");
    }
  }

  Future<List<dynamic>> fetchMaterials() async {
    final authToken = ref.read(sampleProvider);
    final url = "$mainUrl/materials/$groupId";

    final response = await http
        .get(Uri.parse(url), headers: {"Authorization": "Bearer $authToken"});

    if (response.statusCode == 200) {
      final data = jsonDecode(response.body);
      return data["materials"] ?? [];
    } else {
      throw Exception("Failed to fetch materials");
    }
  }
Future<void> submitLiveClassLink(String liveClassLink, String classTime) async {
  final authToken = ref.read(sampleProvider);
  String url = "$mainUrl/groups/$groupId/live-class";

  try {
    final response = await http.post(
      Uri.parse(url),
      headers: {
        "Content-Type": "application/json",
        "Authorization": "Bearer $authToken",
      },
      body: jsonEncode({
        "live_class_link": liveClassLink,
        "class_time": classTime,
      }),
    );

    if (response.statusCode == 200 || response.statusCode == 201) {
      state = state.copyWith(liveClassLink: liveClassLink);
    } else {
      throw Exception("Failed to save link: Server Error");
    }
  } catch (e) {
    throw Exception("Error submitting live class link: $e");
  }
}

  Future<void> fetchLiveClassLink() async {
    logger.f("Fetching live class link...");
    final url = "$mainUrl/groups/$groupId/live-class";

    try {
      final response = await http.get(Uri.parse(url));
      logger.i("Live Class API Response: ${response.body}");

      if (response.statusCode == 200) {
        final jsonData = jsonDecode(response.body);
        final liveClassLink = jsonData['live_class_link'];

        logger.i("Fetched Live Class Link: $liveClassLink");

        // Force state update
        state = GroupDetailsState(
          isLoading: state.isLoading,
          hasError: state.hasError,
          groupDetails: state.groupDetails,
          videoList: state.videoList,
          materialsList: state.materialsList,
          liveClassLink: liveClassLink, 
        );
      } else {
        logger.e(
            "Failed to fetch live class link, status: ${response.statusCode}");
      }
    } catch (e) {
      logger.e("Error fetching live class link: $e");
    }
  }
}

