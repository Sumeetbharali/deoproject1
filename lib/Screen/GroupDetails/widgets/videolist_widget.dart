import 'package:classwix_orbit/Screen/GroupDetails/widgets/videotile_widet.dart';
import 'package:flutter/material.dart';

class VideolistWidget extends StatelessWidget {
  final List<dynamic> videoList;
  const VideolistWidget({super.key, required this.videoList});

  @override
  Widget build(BuildContext context) {
    return videoList.isEmpty
        ? const Center(
            child: Text("No videos available",
                style: TextStyle(color: Colors.grey)))
        : ListView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: videoList.length,
            itemBuilder: (context, index) {
              final video = videoList[index];
              return VideotileWidet(
                video: video,
              );
            },
          );
  }
}
