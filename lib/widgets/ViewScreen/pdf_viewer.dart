// import 'package:flutter/material.dart';
// import 'package:flutter_pdfview/flutter_pdfview.dart';

// class PDFViewerScreen extends StatelessWidget {
//   final String url;
//   const PDFViewerScreen({super.key, required this.url});

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar: AppBar(title: const Text("PDF Viewer")),
//       body: const PDFView(filePath: "http://ebooks.syncfusion.com/downloads/flutter-succinctly/flutter-succinctly.pdf"),
//     );
//   }
// }

import 'package:classwix_orbit/core/constants/colors.dart';
import 'package:dio/dio.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:pdfx/pdfx.dart';

class PdfViewerScreen extends StatefulWidget {
  final String pdfUrl;
  const PdfViewerScreen({super.key, required this.pdfUrl});

  @override
  State<PdfViewerScreen> createState() => _PdfViewerScreenState();
}

class _PdfViewerScreenState extends State<PdfViewerScreen> {
  PdfController? _pdfController;
  final Dio _dio = Dio();

  @override
  void initState() {
    super.initState();
    _loadPdf();
  }

  Future<void> _loadPdf() async {
    try {
      final response = await _dio.get<Uint8List>(
        widget.pdfUrl,
        options: Options(responseType: ResponseType.bytes),
      );

      final document = await PdfDocument.openData(response.data!);
      _pdfController = PdfController(
        document: Future.value(document),
      );
      setState(() {});
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to load PDF: ${e.toString()}')),
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text('PDF Viewer'),
        titleTextStyle: const TextStyle(color: AppColors.background),
        leading: IconButton(
            onPressed: () => Navigator.pop(context),
            icon: const Icon(
              Icons.arrow_back_ios_new_rounded,
              color: AppColors.background,
            )),
        // TODO: Don't add these buttons
        /*actions: [
          IconButton(
            icon: const Icon(Icons.zoom_in),
            onPressed: () => (),
              // (_pdfController?.entry?.setZoom(1.5))
          ),
          IconButton(
            icon: const Icon(Icons.zoom_out),
            onPressed: () => (),
              // (_pdfController?.entry?.setZoom(0.8))
          ),
        ],*/
      ),
      body: _pdfController != null
          ? PdfView(
              controller: _pdfController!,
              scrollDirection: Axis.vertical,
              pageSnapping: true,
            )
          : const Center(child: CircularProgressIndicator()),
    );
  }

  @override
  void dispose() {
    _pdfController?.dispose();
    super.dispose();
  }
}
