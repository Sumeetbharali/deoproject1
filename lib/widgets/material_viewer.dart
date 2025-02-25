import 'package:cached_network_image/cached_network_image.dart';
import 'package:classwix_orbit/widgets/ViewScreen/home_screen_audio.dart';
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
    if (url == null || url!.isEmpty || url!.contains("undefined")) {
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
    isScrollControlled: true, 
    backgroundColor: Colors.transparent,
    builder: (context) => Container(
      height:
          MediaQuery.of(context).size.height * 0.3, 
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
        height: 800, 
        child: Column(
          children: [
            AppBar(
              title: const Text(
                'Image Preview',
                style: TextStyle(color: AppColors.background),
              ),
              backgroundColor: const Color.fromARGB(255, 223, 238, 245),
              automaticallyImplyLeading:
                  false, 
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