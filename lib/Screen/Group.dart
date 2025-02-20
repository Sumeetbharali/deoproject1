import 'dart:convert';
import 'package:classwix_orbit/Screen/group_details_screen.dart';
import 'package:classwix_orbit/core/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class GroupsScreen extends StatefulWidget {
  const GroupsScreen({super.key});

  @override
  _GroupsScreenState createState() => _GroupsScreenState();
}

class _GroupsScreenState extends State<GroupsScreen> {
  List<GroupData> groups = [];
  bool isLoading = true;
  bool hasError = false;

  @override
  void initState() {
    super.initState();
    fetchGroups();
  }

  Future<void> fetchGroups() async {
    print('Fetching Groups...');

    setState(() {
      isLoading = true;
      hasError = false; // Reset error state before fetching
    });

    await Future.delayed(const Duration(seconds: 1)); // Smooth refresh delay

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
        List<dynamic> fetchedGroups = data["groups"];

        setState(() {
          groups = fetchedGroups.map((group) {
            return GroupData(
              id: group["id"],
              name: group["name"] ?? "Unnamed Group",
              courseTitle: group["course"]?["title"] ?? "No Course Assigned",
            );
          }).toList();
          isLoading = false;
          hasError = false; // Successfully loaded data
        });
      } else {
        throw Exception("Failed to load groups");
      }
    } catch (e) {
      print("Error: $e");
      setState(() {
        isLoading = false;
        hasError = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.white,
      appBar: AppBar(
        automaticallyImplyLeading: false,
      ),
      body: RefreshIndicator(
        onRefresh:fetchGroups, 
       
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            const Padding(
              padding: EdgeInsets.only(left: 16.0),
              child: Text(
                "My Class Groups",
                style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                    color: AppColors.black), 
              ),
            ),
            Expanded(
              child: isLoading
                  ? const Center(
                      child:
                          CircularProgressIndicator()) // Show loader while fetching
                  : hasError
                      ? Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              const Text(
                                "Failed to load groups",
                                style:
                                    TextStyle(color: Colors.red, fontSize: 16),
                              ),
                              const SizedBox(height: 10),
                              ElevatedButton(
                                onPressed: fetchGroups, // Retry manually
                                child: const Text("Retry"),
                              ),
                            ],
                          ),
                        )
                      : ListView.builder(
                          padding: const EdgeInsets.all(16.0),
                          itemCount: groups.length,
                          itemBuilder: (context, index) {
                            return _buildGroupItem(groups[index]);
                          },
                        ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildGroupItem(GroupData group) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(
              builder: (context) => GroupDetailsScreen(groupId: group.id)),
        );
      },
      child: Padding(
        padding: const EdgeInsets.only(bottom: 16.0),
        child: Container(
          padding: const EdgeInsets.all(12),
          decoration: BoxDecoration(
            color: Colors.white,
            borderRadius: BorderRadius.circular(12),
            boxShadow: const [
              BoxShadow(color: Colors.black12, blurRadius: 4, spreadRadius: 2),
            ],
          ),
          child: Row(
            children: [
              Container(
                width: 50,
                height: 50,
                decoration: BoxDecoration(
                  color: Colors.grey[300],
                  borderRadius: BorderRadius.circular(10),
                ),
                child: const Icon(Icons.group, size: 30, color: Colors.blue),
              ),
              const SizedBox(width: 12),
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(group.name,
                        style: const TextStyle(
                            fontWeight: FontWeight.bold, fontSize: 16)),
                    Text("Course: ${group.courseTitle}",
                        style:
                            const TextStyle(fontSize: 14, color: Colors.grey)),
                  ],
                ),
              ),
              const Icon(Icons.arrow_forward_ios, size: 16),
            ],
          ),
        ),
      ),
    );
  }
}

class GroupData {
  final int id;
  final String name;
  final String courseTitle;

  GroupData({required this.id, required this.name, required this.courseTitle});
}
