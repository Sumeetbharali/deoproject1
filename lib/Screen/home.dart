import 'dart:convert';
import 'package:classwix_orbit/Screen/Group.dart';
import 'package:flutter/material.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class HomePage extends StatefulWidget {
  const HomePage({super.key});

  @override
  State<HomePage> createState() => _HomePageState();
}

class _HomePageState extends State<HomePage> {
  List<Map<String, dynamic>> classGroups = [];
  bool isLoading = true;
  bool hasError = false;

  @override
  void initState() {
    super.initState();
    fetchGroups();
  }

  Future<void> fetchGroups() async {
    print('Fetching data...');

    setState(() {
      isLoading = true; // Start loading
      hasError = false; // Reset error state
    });

    await Future.delayed(
        const Duration(seconds: 1)); // Simulating smooth refresh

    final prefs = await SharedPreferences.getInstance();
    final String? tokenCred = prefs.getString('token');
    const String url = "https://api.classwix.com/api/admin/groups";
    String token = "Bearer ${tokenCred.toString()}";

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {"Authorization": token},
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
          hasError = false; // Data loaded successfully
        });
      } else {
        throw Exception("Failed to load data");
      }
    } catch (e) {
      print("Error: $e");
      setState(() {
        isLoading = false;
        hasError = true; // Mark error state
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: RefreshIndicator(
          onRefresh: () async {
        await fetchGroups(); // Ensure refresh actually calls fetchGroups
      },  
        child: isLoading
            ? const Center(
                child: CircularProgressIndicator())
            : ListView(
                padding: const EdgeInsets.all(16.0),
                children: [
                  if (hasError) // Display error state but keep RefreshIndicator usable
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
                            onPressed: fetchGroups, // Retry manually
                            child: const Text("Retry"),
                          ),
                        ],
                      ),
                    )
                  else if (classGroups
                      .isEmpty) // Show message when no groups exist
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
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            const Text(
                              "Today's Schedule",
                              style: TextStyle(
                                  fontSize: 18, fontWeight: FontWeight.bold),
                            ),
                            TextButton(
                                onPressed: () {}, child: const Text("View All"))
                          ],
                        ),
                        Container(
                          height: 120,
                          decoration: BoxDecoration(
                            color: Colors.white,
                            borderRadius: BorderRadius.circular(12),
                            boxShadow: const [
                              BoxShadow(
                                color: Colors.black12,
                                blurRadius: 4,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                          child: ListTile(
                            leading: ClipRRect(
                              borderRadius: BorderRadius.circular(8),
                              child: CachedNetworkImage(
                                imageUrl:
                                    "https://img.freepik.com/free-vector/learning-concept-illustration_114360-6186.jpg",
                                fit: BoxFit.cover,
                                width: 60,
                                height: 60,
                                placeholder: (context, url) =>
                                    const CircularProgressIndicator(),
                                errorWidget: (context, url, error) =>
                                    const Icon(Icons.error,
                                        size: 40, color: Colors.red),
                              ),
                            ),
                            title: const Text(
                              "Mathematics",
                              style: TextStyle(
                                  fontSize: 16, fontWeight: FontWeight.bold),
                            ),
                            subtitle: Column(
                              crossAxisAlignment: CrossAxisAlignment.start,
                              children: [
                                const Text("Dr. Sarah Johnson"),
                                const SizedBox(height: 4),
                                LinearProgressIndicator(
                                  value: 0.5,
                                  backgroundColor: Colors.grey.shade300,
                                  color: Colors.blue,
                                ),
                              ],
                            ),
                            trailing: ElevatedButton(
                              onPressed: () {},
                              child: const Text("Join Class"),
                            ),
                          ),
                        ),
                        const SizedBox(height: 20),
                        // Quick Access Icons
                        Row(
                          mainAxisAlignment: MainAxisAlignment.spaceAround,
                          children: [
                            _buildQuickAccessIcon(
                                Icons.assignment, "Assignments"),
                            _buildQuickAccessIcon(Icons.book, "Materials"),
                            _buildQuickAccessIcon(Icons.chat, "Discussion"),
                            _buildQuickAccessIcon(
                                Icons.calendar_today, "Calendar"),
                          ],
                        ),
                        const SizedBox(height: 20),
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
                            return _buildClassGroupCard(classGroups[index]);
                          },
                        ),
                      ],
                    ),
                ],
              ),
      ),
    );
  }

  Widget _buildQuickAccessIcon(IconData icon, String label) {
    return Column(
      children: [
        CircleAvatar(
          radius: 24,
          backgroundColor: Colors.blue.shade100,
          child: Icon(icon, color: Colors.blue, size: 28),
        ),
        const SizedBox(height: 8),
        Text(label, style: const TextStyle(fontSize: 14)),
      ],
    );
  }

  Widget _buildClassGroupCard(Map<String, dynamic> group) {
    return GestureDetector(
      onTap: () => Navigator.push(context,
          MaterialPageRoute(builder: (context) => const GroupsScreen())),
      child: Container(
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(12),
          boxShadow: const [
            BoxShadow(
              color: Colors.black12,
              blurRadius: 4,
              spreadRadius: 2,
            ),
          ],
        ),
        child: Row(
          mainAxisAlignment: MainAxisAlignment.spaceBetween,
          children: [
            Flexible(
              child: Container(
                height: 80,
                width: 200,
                decoration: BoxDecoration(
                  color: Colors.white,
                  borderRadius: BorderRadius.circular(8),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.grey.withOpacity(0.2),
                      blurRadius: 4,
                      spreadRadius: 2,
                    ),
                  ],
                ),
                child: CachedNetworkImage(
                  imageUrl: group['image'],
                  fit: BoxFit.cover,
                  placeholder: (context, url) =>
                      const Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) =>
                      const Icon(Icons.error, size: 40, color: Colors.red),
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.only(right: 20.0),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.baseline,
                textBaseline: TextBaseline.alphabetic,
                children: [
                  Text(
                    group['title'],
                    style: const TextStyle(
                        fontSize: 16, fontWeight: FontWeight.bold),
                    textAlign: TextAlign.center,
                  ),
                  Padding(
                    padding: const EdgeInsets.only(top: 2.0),
                    child: Text(
                      group['courseTitle'],
                      style: const TextStyle(
                          color: Colors.grey,
                          fontSize: 16,
                          fontWeight: FontWeight.w300),
                      textAlign: TextAlign.center,
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
