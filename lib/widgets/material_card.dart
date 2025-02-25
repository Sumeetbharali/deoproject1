import 'package:flutter/material.dart';
import '../core/constants/colors.dart';
import 'material_viewer.dart';

class MaterialCard extends StatefulWidget {
  final dynamic material;
  const MaterialCard({super.key, this.material});

  @override
  State<MaterialCard> createState() => _MaterialCardState();
}

class _MaterialCardState extends State<MaterialCard> {
  String getTime = "";
  String getName = "";
  @override
  void initState() {
    extractDetails(widget.material["pdf"]);
    super.initState();
  }

  void extractDetails(String? url) {
    if (url == null || url.isEmpty || url.contains("undefined")) {
      return;
    }

    // Extract date-time part
    RegExp timeRegex = RegExp(r'\/([A-Za-z]{3} \w{3} \d{1,2} \d{4}) ');
    String? time = timeRegex.firstMatch(url)?.group(1);

    // Extract file name
    RegExp nameRegex = RegExp(r'\/([^\/]+)\.(pdf|mp3|wav|jpg|png)$');
    String? name = nameRegex.firstMatch(url)?.group(1);


    setState(() {
      getTime = time ?? "Unknown Date";
      getName = name ?? "Unknown File";
    });
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
          side: const BorderSide(width: 1, color: AppColors.purple),
          borderRadius: BorderRadius.circular(5)),
      color: AppColors.white,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      child: Padding(
        padding: const EdgeInsets.all(10.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  getName,
                  style: const TextStyle(
                      color: Colors.black, fontWeight: FontWeight.bold,fontSize: 10),
                ),
                Text(
                  getTime,
                  style: const TextStyle(color: Colors.black,fontSize: 10),
                )
              ],
            ),
            MaterialViewer(title: "Photo", url: widget.material["photo"]),
            MaterialViewer(title: "Audio", url: widget.material["audio"]),
            MaterialViewer(title: "PDF", url: widget.material["pdf"]),
          ],
        ),
      ),
    );
  }
}
