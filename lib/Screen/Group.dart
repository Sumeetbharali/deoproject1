import 'dart:convert';
import 'package:classwix_orbit/Screen/group_details_screen.dart';
import 'package:classwix_orbit/core/constants/colors.dart';
import 'package:classwix_orbit/core/constants/styles.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';

class GroupsScreen extends StatefulWidget {
  const GroupsScreen({super.key});

  @override
  _GroupsScreenState createState() => _GroupsScreenState();
}

class _GroupsScreenState extends State<GroupsScreen>
    with SingleTickerProviderStateMixin {
  late AnimationController _controller;
  late Animation<Alignment> _animation;
  List<GroupData> groups = [];
  bool isLoading = true;
  bool hasError = false;

  @override
  void initState() {
    super.initState();
    fetchGroups();
    _controller = AnimationController(
      duration: const Duration(seconds: 3),
      vsync: this,
    )..repeat(reverse: true);

    _animation = Tween<Alignment>(
      begin: const Alignment(-1.0, 0.0), // Start from left
      end: const Alignment(1.0, 0.0), // Move to right
    ).animate(_controller);
  }

  @override
  void dispose() {
    _controller.stop(); 
    _controller.dispose(); 
    super.dispose();
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
        elevation: 0,
        automaticallyImplyLeading: false,
        title: const Text(
          "My Class Groups",
          style: TextStyle(
              fontSize: 18,
              fontWeight: FontWeight.bold,
              color: AppColors.black),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: fetchGroups,
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
                : ListView.builder(
                    padding: const EdgeInsets.all(16.0),
                    itemCount: groups.length,
                    itemBuilder: (context, index) {
                      return _buildGroupItem(groups[index]);
                    },
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
      // child: Row(
      //   children: [
      //     Container(
      //       width: 50,
      //       height: 50,
      //       decoration: BoxDecoration(
      //         color: Colors.grey[300],
      //         borderRadius: BorderRadius.circular(10),
      //       ),
      //       child: const Icon(Icons.group, size: 30, color: Colors.blue),
      //     ),
      //     const SizedBox(width: 12),
      //     Expanded(
      //       child: Column(
      //         crossAxisAlignment: CrossAxisAlignment.start,
      //         children: [
      //           Text(group.name,
      //               style: const TextStyle(
      //                   fontWeight: FontWeight.bold, fontSize: 16)),
      //           Text("Course: ${group.courseTitle}",
      //               style:
      //                   const TextStyle(fontSize: 14, color: Colors.grey)),
      //         ],
      //       ),
      //     ),
      //     const Icon(Icons.arrow_forward_ios, size: 16),
      //   ],
      // ),
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Container(
            padding: const EdgeInsets.all(25),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              // gradient: AppStyles.startClassGradient,.
              // gradient: const LinearGradient(
              //   begin: Alignment.bottomLeft,
              //   end: Alignment.topRight,
              //   stops: [0.4, 0.8],
              //   colors: [
              //     // Color.fromARGB(255, 0, 0, 139),
              //     // Color.fromARGB(255, 65, 105, 225),
              //     Color(0XFF2563eb),
              //     Color(0XFF9333ea),
              //   ],
              // ),
              gradient: LinearGradient(
                begin: _animation.value,
                end: const Alignment(1.0, 0.0), // End alignment remains fixed
                colors: const [
                  Colors.blue,
                  Colors.purple
                ], // Change colors as needed
              ),
              boxShadow: const [
                BoxShadow(
                    color: Colors.black12, blurRadius: 4, spreadRadius: 2),
              ],
            ),
            child: Column(
              mainAxisAlignment: MainAxisAlignment.start,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  group.name,
                  style: const TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: 20,
                      color: AppColors.white),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Course: ${group.courseTitle}",
                        style: TextStyle(
                            fontSize: 14,
                            color: AppColors.white.withOpacity(0.8))),
                    OutlinedButton(
                        style: TextButton.styleFrom(
                          side: const BorderSide(color: AppColors.white),
                          backgroundColor: AppColors.white,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(20.0),
                          ),
                        ),
                        onPressed: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    GroupDetailsScreen(groupId: group.id)),
                          );
                        },
                        child: Text(
                          'View Details',
                          style: TextStyle(
                              color: AppColors.grad_blue,
                              fontWeight: FontWeight.bold,
                              fontSize: 15),
                        ))
                  ],
                )
              ],
            ),
          );
        },
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
