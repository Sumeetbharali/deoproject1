import 'dart:convert';
import 'package:classwix_orbit/Screen/Home/carousel_widget.dart';
import 'package:classwix_orbit/Screen/Home/classgroup_card.dart';
import 'package:classwix_orbit/core/constants/api_endpoint.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '/provider/sample_provider.dart';

class HomePage extends ConsumerStatefulWidget {
  const HomePage({super.key});

  @override
  _HomePageState createState() => _HomePageState();
}

class _HomePageState extends ConsumerState<HomePage> {
  List<String> imageUrls = [];
  List<Map<String, dynamic>> classGroups = [];
  bool isLoading = true;
  bool hasError = false;

  @override
  void initState() {
    super.initState();
    fetchCarousels();
    fetchGroups();
  }

  Future<void> fetchCarousels() async {
    final authToken = ref.read(sampleProvider);
    const String url = "$mainUrl/admin/config/carousels";

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {"Authorization": "Bearer $authToken"},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        List<dynamic> carousels = data["carousels"];

        setState(() {
          imageUrls =
              carousels.map<String>((carousel) => carousel["path"]).toList();
        });
      } else {
        throw Exception("Failed to load carousels");
      }
    } catch (e) {
      print("Error fetching carousels: $e");
    }
  }


  Future<void> fetchGroups() async {
    setState(() {
      isLoading = true;
      hasError = false;
    });

    await Future.delayed(const Duration(seconds: 1));

    final authToken = ref.watch(sampleProvider);
    const String url = "$mainUrl/admin/groups";

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {"Authorization": "Bearer $authToken"},
      );

      if (response.statusCode == 200) {
        final data = json.decode(response.body);
        List<dynamic> groups = data["groups"];

        setState(() {
          classGroups = groups.map((group) {
            String courseTitle = "No Course Assigned";
            if (group.containsKey("course") && group["course"] != null) {
              courseTitle = group["course"]["title"] ?? "No Course Available";
            }
            return {
              "id": group["id"],
              "title": group["name"],
              "courseTitle": courseTitle,
              "image":
                  "https://img.freepik.com/free-vector/student-graduation-cap-using-computer-desk_1262-21421.jpg",
            };
          }).toList();
          isLoading = false;
          hasError = false;
        });
      } else {
        throw Exception("Failed to load data");
      }
    } catch (e) {
      setState(() {
        isLoading = false;
        hasError = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
        onRefresh: () async {
          await fetchCarousels();
          await fetchGroups();
        },
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : ListView(
                padding: const EdgeInsets.all(16),
                children: [
                  if (hasError)
                    Center(
                      child: Column(
                        mainAxisAlignment: MainAxisAlignment.center,
                        children: [
                          const Text(
                            "Failed to load data",
                            style: TextStyle(color: Colors.red, fontSize: 16),
                          ),
                          const SizedBox(height: 10),
                          ElevatedButton(
                            onPressed: () {
                              fetchCarousels();
                              fetchGroups();
                            },
                            child: const Text("Retry"),
                          ),
                        ],
                      ),
                    )
                  else if (classGroups.isEmpty)
                    const Center(
                      child: Text(
                        "No groups assigned yet",
                        style: TextStyle(fontSize: 16),
                      ),
                    )
                  else
                    Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        if (imageUrls.isNotEmpty)
                          CarouselWidget(imageUrls: imageUrls),

                        const SizedBox(height: 55),
                        // My Class Groups Section
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "My Class Groups",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            TextButton(
                                onPressed: () {}, child: const Text("See All"))
                          ],
                        ),
                        ListView.builder(
                          shrinkWrap: true,
                          physics: const NeverScrollableScrollPhysics(),
                          itemCount: classGroups.length,
                          itemBuilder: (context, index) {
                            return ClassgroupCard(group: classGroups[index]);
                          },
                        ),
                      ],
                    ),
                ],
              ),
      ),
    );
  }
}
