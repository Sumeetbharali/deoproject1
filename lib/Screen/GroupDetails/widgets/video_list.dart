// import 'package:classwix_orbit/Screen/GroupDetails/group_details_model.dart';
// import 'package:flutter/material.dart';
// import 'package:url_launcher/url_launcher.dart';

// class VideoList extends StatelessWidget {
//   final List<Video> videoList;

//   const VideoList({super.key, required this.videoList});

//   @override
//   Widget build(BuildContext context) {
//     return videoList.isEmpty
//         ? const Center(
//             child: Text("No videos available", style: TextStyle(color: Colors.grey)),
//           )
//         : ListView.builder(
//             shrinkWrap: true,
//             physics: const NeverScrollableScrollPhysics(), // Disable inner scroll
//             padding: const EdgeInsets.all(10),
//             itemCount: videoList.length,
//             itemBuilder: (context, index) {
//               final video = videoList[index];
//               return _buildVideoTile(video);
//             },
//           );
//   }

//   Widget _buildVideoTile(Video video) {
//     return Card(
//       shape: RoundedRectangleBorder(
//         borderRadius: BorderRadius.circular(10),
//         side: const BorderSide(style: BorderStyle.solid, color: Colors.blue),
//       ),
//       color: Colors.white,
//       margin: const EdgeInsets.symmetric(vertical: 8),
//       child: ListTile(
//         title: Text(
//           video.title,
//           style: const TextStyle(fontSize: 18, fontWeight: FontWeight.bold, color: Colors.blue),
//         ),
//         minVerticalPadding: 15,
//         trailing: IconButton(
//           icon: const Icon(Icons.open_in_new, color: Colors.blue),
//           onPressed: () => launchUrl(Uri.parse(video.videoPath)),
//         ),
//       ),
//     );
//   }
// }
