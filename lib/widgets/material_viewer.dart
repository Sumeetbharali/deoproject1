import 'package:cached_network_image/cached_network_image.dart';
import 'package:classwix_orbit/widgets/ViewScreen/home_screen_audio.dart';
import 'package:classwix_orbit/widgets/ViewScreen/audio_view.dart';
import 'package:classwix_orbit/widgets/ViewScreen/image_viewer.dart';
import 'package:classwix_orbit/widgets/ViewScreen/pdf_viewer.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:classwix_orbit/core/constants/colors.dart';

class MaterialViewer extends StatelessWidget {
  final String title;
  final String? url;

  const MaterialViewer({super.key, required this.title, this.url});

  @override
  Widget build(BuildContext context) {
    if (url == null || url!.isEmpty) {
      return const SizedBox.shrink(); // Don't show if URL is empty
    }

    return ListTile(
      leading: Text(
        title,
        style: const TextStyle(fontSize: 15, fontWeight: FontWeight.bold),
      ),
      trailing: InkWell(
          onTap: () => _viewContent(context, url!),
          child: Image.asset(_getIconPath(title), width: 38, height: 38)),
    );
  }

  String _getIconPath(String type) {
    String assetPath;
    switch (type.toLowerCase()) {
      case "photo":
        assetPath = "assets/img_asset.jpg";
        break;
      case "audio":
        assetPath = "assets/audio_assert.jpg";
        break;
      case "pdf":
        assetPath = "assets/pdf_assert.jpg";
        break;
      default:
        assetPath = "assets/icons/default.png";
    }
    return assetPath;
  }

  void _viewContent(BuildContext context, String url) {
    if (url.endsWith('.pdf')) {
      Navigator.push(
        context,
        MaterialPageRoute(builder: (context) => PdfViewerScreen(pdfUrl: url)),
      );
    } else if (url.endsWith('.jpg') || url.endsWith('.png')) {
      _showImagePreview(url, context);
    } else if (url.endsWith('.mp3') ||
        url.endsWith('.wav') ||
        url.endsWith('.mp4')) {
      // Navigator.push(
      //   context,
      //   MaterialPageRoute(builder: (context) => AudioPlayerScreen(url: url)),
      // );
      _showAudioPlayer(context, url);
    } else {
      launchUrl(Uri.parse(url)); // Open in browser if unsupported
    }
  }
}

void _showAudioPlayer(BuildContext context, String audioUrl) {
  // Navigator.push(
  //       context,
  //       MaterialPageRoute(builder: (context) =>  HomeScreen(audioUrl: audioUrl,),)
  //     );
  // builder: (context) => AudioPlayerBottomSheet(url: audioUrl),
  // showModalBottomSheet(

  //   context: context,
  //   builder: (context) => HomeScreen(audioUrl: audioUrl,),

  // );
  showModalBottomSheet(
    context: context,
    isScrollControlled: true, // Allows it to take more space
    backgroundColor: Colors.transparent, // Makes it blend better with the UI
    builder: (context) => Container(
      height:
          MediaQuery.of(context).size.height * 0.3, // Adjust height as needed
      decoration: const BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.only(
          topLeft: Radius.circular(20),
          topRight: Radius.circular(20),
        ),
      ),
      child: HomeScreen(audioUrl: audioUrl),
    ),
  );
}

void _showImagePreview(String imageUrl, BuildContext context) {
  showDialog(
    useSafeArea: true,
    context: context,
    builder: (context) => Dialog(
      elevation: 5,
      backgroundColor: const Color.fromARGB(255, 223, 238, 245),
      child: SizedBox(
        width: double.infinity,
        height: 800, // Set a fixed height or make it scrollable
        child: Column(
          children: [
            AppBar(
              title: const Text(
                'Image Preview',
                style: TextStyle(color: AppColors.background),
              ),
              backgroundColor: const Color.fromARGB(255, 223, 238, 245),
              automaticallyImplyLeading:
                  false, // Prevents back button from showing
              actions: [
                IconButton(
                  icon: const Icon(
                    Icons.close,
                    color: AppColors.background,
                  ),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),
            Expanded(
              // Ensures it doesn't overflow
              child: InteractiveViewer(
                minScale: 0.1,
                maxScale: 4.0,
                child: CachedNetworkImage(
                  imageUrl: imageUrl,
                  placeholder: (context, url) =>
                      const Center(child: CircularProgressIndicator()),
                  errorWidget: (context, url, error) => const Icon(Icons.error),
                ),
              ),
            ),
          ],
        ),
      ),
    ),
  );
}

// import 'package:cached_network_image/cached_network_image.dart';
// import 'package:classwix_orbit/controller/auth_controller.dart';
// import 'package:classwix_orbit/core/constants/colors.dart';
// import 'package:classwix_orbit/widgets/ViewScreen/audio_view.dart';
// import 'package:classwix_orbit/widgets/ViewScreen/image_viewer.dart';
// import 'package:classwix_orbit/widgets/ViewScreen/pdf_viewer.dart';
// import 'package:flutter/material.dart';
// import 'package:url_launcher/url_launcher.dart';

// class MaterialViewer extends StatefulWidget {
//   final dynamic material;
//   MaterialViewer({super.key, this.material});

//   @override
//   State<MaterialViewer> createState() => _MaterialViewerState();
// }

// class _MaterialViewerState extends State<MaterialViewer> {
//   // final List<Map<String, String>> materials = [
//   //   {
//   //     'title': 'Resume (1)',
//   //     'group': 'Group 23',
//   //     'date': 'Feb 18, 2025',
//   //     'pdfUrl': 'https://example.com/resume.pdf',
//   //     'imageUrl': 'https://example.com/image.jpg',
//   //     'audioUrl': 'https://example.com/audio.mp3',
//   //   },
//   //   {
//   //     'title': 'Flutterresume.docx 1',
//   //     'group': 'Group 23',
//   //     'date': 'Feb 18, 2025',
//   //     'pdfUrl':
//   //         'http://ebooks.syncfusion.com/downloads/flutter-succinctly/flutter-succinctly.pdf',
//   //     'imageUrl':
//   //         'https://s3.classwix.com/classwix/photos/Sun%20Feb%2016%202025%2017:20:08%20GMT+0000%20(Coordinated%20Universal%20Time)/JPEG_20250216_224850_2089845301531067794.jpg',
//   //     'audioUrl':
//   //         'https://s3.classwix.com/classwix/audios/Sun Feb 16 2025 17:20:10 GMT+0000 (Coordinated Universal Time)/audio.mp3',
//   //   },
//   // ];

//   @override
//   Widget build(BuildContext context) {
//     logger.i(widget.material);
//     return Scaffold(
//       appBar: AppBar(
//         title: const Text('Study Material'),
//         backgroundColor: Colors.deepPurple,
//         leading: IconButton(
//           icon: const Icon(Icons.arrow_back),
//           onPressed: () => Navigator.pop(context),
//         ),
//       ),
//       body: ListView.builder(
//         itemCount: widget.material,
//         itemBuilder: (context, index) {
//           final material = widget.material[index];
//           return Card(
//             margin: const EdgeInsets.symmetric(horizontal: 12, vertical: 8),
//             child: Padding(
//               padding: const EdgeInsets.all(12),
//               child: Column(
//                 crossAxisAlignment: CrossAxisAlignment.start,
//                 children: [
//                   Row(
//                     mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                     children: [
//                       Row(
//                         children: [
//                           _iconButton('pdf', material['pdfUrl'], context),
//                           const SizedBox(width: 8),
//                           _iconButton('image', material['imageUrl'], context),
//                           const SizedBox(width: 8),
//                           _iconButton('audio', material['audioUrl'], context),
//                         ],
//                       ),
//                       Text(
//                         material['date'] ?? '',
//                         style: const TextStyle(color: Colors.grey),
//                       ),
//                     ],
//                   ),
//                   const SizedBox(height: 8),
//                   Text(
//                     material['title'] ?? '',
//                     style: const TextStyle(
//                         fontWeight: FontWeight.bold, fontSize: 16),
//                   ),
//                   const SizedBox(height: 4),
//                   Text(
//                     material['group'] ?? '',
//                     style: const TextStyle(
//                         color: Colors.blue, fontWeight: FontWeight.w500),
//                   ),
//                 ],
//               ),
//             ),
//           );
//         },
//       ),
//     );
//   }

//   Widget _iconButton(String type, String? url, BuildContext context) {
//     if (url == null || url.isEmpty) return const SizedBox();

//     IconData icon;
//     switch (type) {
//       case 'pdf':
//         icon = Icons.picture_as_pdf;
//         break;
//       case 'image':
//         icon = Icons.image;
//         break;
//       case 'audio':
//         icon = Icons.music_note;
//         break;
//       default:
//         icon = Icons.insert_drive_file;
//     }

//     return IconButton(
//       icon: Icon(icon, color: Colors.blue),
//       onPressed: () {
//         if (url.endsWith('.pdf')) {
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//                 builder: (context) => PdfViewerScreen(pdfUrl: url)),
//           );
//         } else if (url.endsWith('.jpg') || url.endsWith('.png')) {
//           // Navigator.push(
//           //   context,
//           //   MaterialPageRoute(
//           //       builder: (context) => ImageViewerScreen(url: url)),
//           // );
//           _showImagePreview(url, context);
//         } else if (url.endsWith('.mp3') || url.endsWith('.wav')) {
//           Navigator.push(
//             context,
//             MaterialPageRoute(
//                 builder: (context) => AudioPlayerScreen(url: url)),
//           );
//         } else {
//           launchUrl(Uri.parse(url)); // Open in browser if unsupported
//         }
//       },
//     );
//   }
// }
