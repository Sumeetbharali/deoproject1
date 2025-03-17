// // import 'package:flutter/material.dart';

// // class ImageViewerScreen extends StatelessWidget {
// //   final String url;
// //   const ImageViewerScreen({super.key, required this.url});

// //   @override
// //   Widget build(BuildContext context) {
// //     return Scaffold(
// //       appBar: AppBar(title: const Text("Image Viewer")),
// //       body: Center(
// //         child: Image.network(url),
// //       ),
// //     );
// //   }
// // }

// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';

// class ImageViewerScreen extends StatelessWidget {
//   final String url;
//   const ImageViewerScreen({super.key, required this.url});

//   @override
//   Widget build(BuildContext context) {
    
//     return Scaffold(body: Center(child: InkWell(
//           onTap: () => _showImagePreview(url,context),
//           child: const Icon(Icons.image, color: Colors.green, size: 38),
//         ),),);
//   }
// }

// void _showImagePreview(String imageUrl,BuildContext context) {
//     showDialog(
//       context: context,
//       builder: (context) => Dialog(
//         child: Column(
//           mainAxisSize: MainAxisSize.min,
//           children: [
//             AppBar(
//               title: const Text('Image Preview'),
//               actions: [
//                 IconButton(
//                   icon: const Icon(Icons.close),
//                   onPressed: () => Navigator.pop(context),
//                 ),
//               ],
//             ),
//             InteractiveViewer(
//               minScale: 0.1,
//               maxScale: 4.0,
//               child: CachedNetworkImage(
//                 imageUrl: imageUrl,
//                 placeholder: (context, url) =>
//                     const Center(child: CircularProgressIndicator()),
//                 errorWidget: (context, url, error) => const Icon(Icons.error),
//               ),
//             ),
//           ],
//         ),
//       ),
//     );
//   }




