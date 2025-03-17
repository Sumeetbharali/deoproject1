import 'package:auto_size_text/auto_size_text.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:classwix_orbit/Screen/MyGroup/group_screen.dart';
import 'package:flutter/material.dart';

class ClassgroupCard extends StatelessWidget {
  final Map<String, dynamic> group;
  const ClassgroupCard({super.key, required this.group});

  @override
  Widget build(BuildContext context) {
    double screenWidth = MediaQuery.of(context).size.width;
    double imageSize = screenWidth * 0.3;

    return GestureDetector(
      onTap: () => Navigator.push(context,
          MaterialPageRoute(builder: (context) =>  GroupsScreen(groupid: group['id'],))),
      child: Container(
        padding: const EdgeInsets.all(12),
        margin: const EdgeInsets.symmetric(vertical: 8),
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
            Container(
              height: imageSize*0.5,
              width: imageSize,
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
              child: ClipRRect(
                borderRadius: BorderRadius.circular(8),
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
            Expanded(
              child: Padding(
                padding: const EdgeInsets.only(left: 25.0),
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    AutoSizeText(
                      group['title'],
                      style: TextStyle(
                          fontSize: screenWidth * 0.045,
                          fontWeight: FontWeight.bold),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                    const SizedBox(height: 5),
                    AutoSizeText(
                      group['courseTitle'],
                      style: TextStyle(
                          color: Colors.grey,
                          fontSize: screenWidth * 0.04, 
                          fontWeight: FontWeight.w300),
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
