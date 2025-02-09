import 'dart:convert';
import 'package:classwix_orbit/core/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;


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
    const String url = "https://api.classwix.com/api/admin/groups";
    const String token = "Bearer 481|WQb5u5l19G5u8fTeh1rkyreGTeu6uJtjFuZRLV0g8517d077"; // Replace with actual token

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
        });
      } else {
        setState(() {
          isLoading = false;
          hasError = true;
        });
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
      backgroundColor: AppColors.white,
      appBar: AppBar(title: const Text("My Class Groups",style: TextStyle(fontSize: 15,fontWeight: FontWeight.bold),),),
      body: isLoading
          ? const Center(child: CircularProgressIndicator(),)
          : hasError
              ? const Center(
                  child: Text("Failed to load groups",
                      style: TextStyle(color: Colors.red, fontSize: 16)),
                )
              : ListView.builder(
                  padding: const EdgeInsets.all(16.0),
                  itemCount: groups.length,
                  itemBuilder: (context, index) {
                    return _buildGroupItem(groups[index]);
                  },
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
                        style: const TextStyle(
                            fontSize: 14, color: Colors.grey)),
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

class GroupDetailsScreen extends StatefulWidget {
  final int groupId;

  const GroupDetailsScreen({super.key, required this.groupId});

  @override
  _GroupDetailsScreenState createState() => _GroupDetailsScreenState();
}

class _GroupDetailsScreenState extends State<GroupDetailsScreen> {
  Map<String, dynamic>? groupDetails;
  bool isLoading = true;
  bool hasError = false;

  @override
  void initState() {
    super.initState();
    fetchGroupDetails();
  }

  Future<void> fetchGroupDetails() async {
    final String url = "https://api.classwix.com/api/admin/groups/${widget.groupId}";
        const String token =
        "Bearer 481|WQb5u5l19G5u8fTeh1rkyreGTeu6uJtjFuZRLV0g8517d077"; // Replace with actual token

    try {
      final response = await http.get(
        Uri.parse(url),
        headers: {"Authorization": token},
      );

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        if (!mounted) return; // Prevents updating state after widget disposal

        setState(() {
          groupDetails = responseData["details"] ?? {}; // Default to empty map
          isLoading = false;
        });
      } else {
        if (!mounted) return;
        setState(() {
          isLoading = false;
          hasError = true;
        });
      }
    } catch (e) {
      if (!mounted) return;
      setState(() {
        isLoading = false;
        hasError = true;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(title: const Text("Group Details")),
      body: isLoading
          ? const Center(child: CircularProgressIndicator())
          : hasError || groupDetails == null
              ? const Center(
                  child: Text("Failed to load group details",
                      style: TextStyle(color: Colors.red, fontSize: 16)),
                )
              : Padding(
                  padding: const EdgeInsets.all(16.0),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text("Group Name: ${groupDetails!["name"] ?? "No Name"}",
                          style: const TextStyle(
                              fontSize: 20, fontWeight: FontWeight.bold)),
                      Text("Instructor: ${groupDetails!["instructor"]?["name"] ?? "No Instructor"}"),
                      const SizedBox(height: 10),
                      Text("Schedule: ${groupDetails!["routine"]?["wed"] ?? "No schedule"}"),
                      const SizedBox(height: 20),
                      const Text("Videos:"),
                      ...(groupDetails!["videos"] as List<dynamic>?)?.map((video) {
                        return ListTile(
                          title: Text(video["title"] ?? "No Title"),
                          subtitle: Text(video["video_path"] ?? "No Video Link"),
                        );
                      }).toList() ?? [const Text("No Videos Available")],
                    ],
                  ),
                ),
    );
  }
}



// import 'package:flutter/material.dart';

// class GroupsScreen extends StatelessWidget {
//   final List<GroupData> groups = [
//     GroupData("Design Team", 12, "2m ago"),
//     GroupData("Marketing Squad", 8, "5m ago"),
//     GroupData("Product Development", 15, "12m ago"),
//     GroupData("Customer Support", 6, "18m ago"),
//     GroupData("Sales Team", 10, "25m ago"),
//     GroupData("Engineering Team", 20, "32m ago"),
//     GroupData("Research Group", 7, "45m ago"),
//   ];

//   GroupsScreen({super.key});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       body: SafeArea(
//         child: Column(
//           children: [
//             _buildHeader(),
//             _buildSearchBar(),
//             Expanded(child: _buildGroupsList()),
//             _buildBottomNavBar(),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildHeader() {
//     return Padding(
//       padding: const EdgeInsets.all(16.0),
//       child: Row(
//         mainAxisAlignment: MainAxisAlignment.spaceBetween,
//         children: [
//           const Row(
//             children: [
//               CircleAvatar(
//                 radius: 15,
//                 backgroundColor: Colors.grey,
//               ),
//               SizedBox(width: 8),
//               Text(
//                 'Groups',
//                 style: TextStyle(
//                   fontSize: 24,
//                   fontWeight: FontWeight.bold,
//                 ),
//               ),
//             ],
//           ),
//           IconButton(
//             icon: const Icon(Icons.add_circle_outline),
//             color: Colors.blue,
//             iconSize: 30,
//             onPressed: () {},
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildSearchBar() {
//     return Padding(
//       padding: const EdgeInsets.symmetric(horizontal: 16.0),
//       child: Row(
//         children: [
//           Expanded(
//             child: Container(
//               padding: const EdgeInsets.symmetric(horizontal: 16.0),
//               decoration: BoxDecoration(
//                 color: Colors.grey[200],
//                 borderRadius: BorderRadius.circular(10),
//               ),
//               child: const TextField(
//                 decoration: InputDecoration(
//                   icon: Icon(Icons.search, color: Colors.grey),
//                   hintText: 'Search groups',
//                   border: InputBorder.none,
//                 ),
//               ),
//             ),
//           ),
//           const SizedBox(width: 8),
//           TextButton(
//             onPressed: () {},
//             child: const Text('Filter'),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildGroupsList() {
//     return ListView.builder(
//       padding: const EdgeInsets.all(16.0),
//       itemCount: groups.length,
//       itemBuilder: (context, index) {
//         return _buildGroupItem(groups[index]);
//       },
//     );
//   }

//   Widget _buildGroupItem(GroupData group) {
//     return Padding(
//       padding: const EdgeInsets.only(bottom: 16.0),
//       child: Row(
//         children: [
//           Container(
//             width: 50,
//             height: 50,
//             decoration: BoxDecoration(
//               color: Colors.grey[300],
//               borderRadius: BorderRadius.circular(10),
//             ),
//           ),
//           const SizedBox(width: 12),
//           Expanded(
//             child: Column(
//               crossAxisAlignment: CrossAxisAlignment.start,
//               children: [
//                 Text(
//                   group.name,
//                   style: const TextStyle(
//                     fontWeight: FontWeight.bold,
//                     fontSize: 16,
//                   ),
//                 ),
//                 Text(
//                   '${group.members} members • ${group.lastActive}',
//                   style: TextStyle(
//                     color: Colors.grey[600],
//                     fontSize: 14,
//                   ),
//                 ),
//               ],
//             ),
//           ),
//           TextButton(
//             onPressed: () {},
//             child: const Text(
//               'View >',
//               style: TextStyle(color: Colors.blue),
//             ),
//           ),
//         ],
//       ),
//     );
//   }

//   Widget _buildBottomNavBar() {
//     return BottomNavigationBar(
//       type: BottomNavigationBarType.fixed,
//       currentIndex: 2,
//       items: const [
//         BottomNavigationBarItem(
//           icon: Icon(Icons.home_outlined),
//           label: 'Home',
//         ),
//         BottomNavigationBarItem(
//           icon: Icon(Icons.search),
//           label: 'Search',
//         ),
//         BottomNavigationBarItem(
//           icon: Icon(Icons.group_outlined),
//           label: 'Groups',
//         ),
//         BottomNavigationBarItem(
//           icon: Icon(Icons.chat_bubble_outline),
//           label: 'Chat',
//         ),
//         BottomNavigationBarItem(
//           icon: Icon(Icons.person_outline),
//           label: 'Profile',
//         ),
//       ],
//     );
//   }
// }

// class GroupData {
//   final String name;
//   final int members;
//   final String lastActive;

//   GroupData(this.name, this.members, this.lastActive);
// }
