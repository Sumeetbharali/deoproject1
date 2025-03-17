import 'package:auto_size_text/auto_size_text.dart';
import 'package:classwix_orbit/Screen/GroupDetails/group_details_screen.dart';
import 'package:classwix_orbit/Screen/MyGroup/group_model.dart';
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
    double screenWidth = MediaQuery.of(context).size.width; 
    double paddingSize = screenWidth * 0.05; 

    return Padding(
      padding: const EdgeInsets.only(bottom: 10.0),
      child: GestureDetector(
        onTap: () {
          Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => GroupDetailsScreen(groupId: group.id)),
          );
        },
        child: AnimatedBuilder(
          animation: controller,
          builder: (context, child) {
            return Container(
              padding: EdgeInsets.all(paddingSize), 
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(15),
                gradient: LinearGradient(
                  begin: animation.value,
                  end: const Alignment(1.0, 0.0),
                  colors: const [Colors.blue, Colors.purple],
                ),
                boxShadow: const [
                  BoxShadow(
                      color: Colors.black12, blurRadius: 4, spreadRadius: 2),
                ],
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  AutoSizeText(
                    group.name,
                    style: TextStyle(
                      fontWeight: FontWeight.bold,
                      fontSize: screenWidth *
                          0.06, 
                      color: AppColors.white,
                    ),
                    maxLines: 1,
                    overflow: TextOverflow.ellipsis,
                  ),
                  const SizedBox(height: 8),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Expanded(
                        child: AutoSizeText(
                          "Course: ${group.courseTitle}",
                          style: TextStyle(
                            fontSize: screenWidth *
                                0.04, 
                            color: AppColors.white.withOpacity(0.8),
                          ),
                          maxLines: 1,
                          overflow: TextOverflow.ellipsis,
                        ),
                      ),

                      const SizedBox(width: 8),

                      SizedBox(
                        height: screenWidth *
                            0.1, 
                        child: OutlinedButton(
                          style: TextButton.styleFrom(
                            side: const BorderSide(color: AppColors.white),
                            backgroundColor: AppColors.white,
                            shape: RoundedRectangleBorder(
                                borderRadius: BorderRadius.circular(20.0)),
                          ),
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                  builder: (context) =>
                                      GroupDetailsScreen(groupId: group.id)),
                            );
                          },
                          child: AutoSizeText(
                            'View Details',
                            style: TextStyle(
                              color: AppColors.grad_blue,
                              fontWeight: FontWeight.bold,
                              fontSize: screenWidth *
                                  0.04,
                            ),
                            maxLines: 1,
                            minFontSize:
                                10, 
                          ),
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            );
          },
        ),
      ),
    );
  }
}
