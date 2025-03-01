import 'package:classwix_orbit/Screen/GroupDetails/group_details_screen.dart';
import 'package:classwix_orbit/Screen/MyGroup/group_model.dart';
import 'package:classwix_orbit/Screen/group_details_screen.dart';
import 'package:classwix_orbit/core/constants/colors.dart';
import 'package:flutter/material.dart';

class GroupItem extends StatelessWidget {
  final GroupData group;
  final AnimationController controller;
  final Animation<Alignment> animation;

  const GroupItem({
    super.key,
    required this.group,
    required this.controller,
    required this.animation,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: () {
        Navigator.push(
          context,
          MaterialPageRoute(builder: (context) => GroupDetailsScreen(groupId: group.id)),
        );
      },
      child: AnimatedBuilder(
        animation: controller,
        builder: (context, child) {
          return Container(
            padding: const EdgeInsets.all(25),
            decoration: BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.circular(20),
              gradient: LinearGradient(
                begin: animation.value, 
                end: const Alignment(1.0, 0.0),
                colors: const [Colors.blue, Colors.purple],
              ),
              boxShadow: const [
                BoxShadow(color: Colors.black12, blurRadius: 4, spreadRadius: 2),
              ],
            ),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  group.name,
                  style: const TextStyle(fontWeight: FontWeight.bold, fontSize: 20, color: AppColors.white),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text("Course: ${group.courseTitle}",
                        style: TextStyle(fontSize: 14, color: AppColors.white.withOpacity(0.8))),
                    OutlinedButton(
                      style: TextButton.styleFrom(
                        side: const BorderSide(color: AppColors.white),
                        backgroundColor: AppColors.white,
                        shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(20.0)),
                      ),
                      onPressed: () {
                        Navigator.push(
                          context,
                          MaterialPageRoute(builder: (context) => GroupDetailsScreen(groupId: group.id)),
                        );
                      },
                      child: Text(
                        'View Details',
                        style: TextStyle(color: AppColors.grad_blue, fontWeight: FontWeight.bold, fontSize: 15),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
