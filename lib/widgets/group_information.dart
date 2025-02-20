import 'package:flutter/material.dart';
import '../core/constants/colors.dart';

class GroupInformation extends StatefulWidget {
  final Map<String, dynamic> groupDetails;
  const GroupInformation({super.key, required this.groupDetails});

  @override
  State<GroupInformation> createState() => _GroupInformationState();
}

class _GroupInformationState extends State<GroupInformation> {
  
  @override
  Widget build(BuildContext context) {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        border: Border.all(style: BorderStyle.solid, color: AppColors.purple),
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
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Text("Group: ${widget.groupDetails["name"] ?? "No Name"}",
              style:
                  const TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
          const SizedBox(height: 10),
          Text(
            "Instructor: ${widget.groupDetails["instructor"]?["name"] ?? "No Instructor"}",
          ),
          const SizedBox(height: 10),
          Text("Description: ${widget.groupDetails["description"] ?? "No schedule"}"),
          const SizedBox(height: 10),
          Text("Course: ${widget.groupDetails["course"]?["title"] ?? "No schedule"}"),
        ],
      ),
    );
  }
}