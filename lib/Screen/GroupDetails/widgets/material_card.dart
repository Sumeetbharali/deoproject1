import 'package:classwix_orbit/core/utils/widgets/custom_snack_bar.dart';
import 'package:flutter/material.dart';
import 'package:flutter_slidable/flutter_slidable.dart';
import 'package:http/http.dart' as http;
import '../../../core/constants/colors.dart';
import '../../../widgets/material_viewer.dart';

class MaterialCard extends StatefulWidget {
  final dynamic material;

  const MaterialCard({super.key, required this.material});

  @override
  State<MaterialCard> createState() => _MaterialCardState();
}

class _MaterialCardState extends State<MaterialCard> {
  String getTime = "";
  String? getName;
  bool isDeleting = false;

  @override
  void initState() {
    super.initState();
    extractDetails(widget.material["pdf"], widget.material["created_at"]);
  }

  void extractDetails(String? url, String? createdDate) {
    String formattedDate = "Unknown Date";
    String? name = "";
    if (createdDate != null && createdDate.isNotEmpty) {
      try {
        DateTime parsedDate = DateTime.parse(createdDate);
        formattedDate =
            "${parsedDate.day.toString().padLeft(2, '0')}-${parsedDate.month.toString().padLeft(2, '0')}-${parsedDate.year}";
      } catch (e) {}
    }

    if (url != null && url.isNotEmpty && !url.contains("undefined")) {
      RegExp nameRegex = RegExp(r'([^\/]+)\.(pdf|mp3|wav|jpg|png)$');
      name = nameRegex.firstMatch(url)?.group(1) ?? "Unknown File";
    }

    setState(() {
      getTime = formattedDate;
      getName = name;
    });
  }

  Future<void> deleteMaterial() async {
    setState(() {
      isDeleting = true;
    });

    final String apiUrl =
        "https://test.classwix.com/uploads/${widget.material['id']}";

    try {
      final response = await http.delete(Uri.parse(apiUrl));

      if (response.statusCode == 200) {
        CustomSnackBar.showSnackBar(
            context, "Successfully Deleted", SnackBarType.success);
      } else {
        CustomSnackBar.showSnackBar(context,
            "Failed to delete. Please try again.", SnackBarType.failure);
      }
    } catch (e) {
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text("Error: ${e.toString()}")),
      );
    } finally {
      setState(() {
        isDeleting = false;
      });
    }
  }

  void showDeleteConfirmationDialog(BuildContext context) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          title: const Text(
            "Confirm Deletion",
            style: TextStyle(fontWeight: FontWeight.bold),
          ),
          content: isDeleting
              ? const Center(child: CircularProgressIndicator())
              : const Text("Are you sure want to delete this Material?"),
          actions: [
            TextButton(
              onPressed: isDeleting ? null : () => Navigator.of(context).pop(),
              child: const Text("Cancel"),
            ),
            TextButton(
              style: TextButton.styleFrom(
                backgroundColor: Colors.white,
                foregroundColor: Colors.red,
              ),
              onPressed: isDeleting
                  ? null
                  : () {
                      Navigator.of(context).pop();
                      deleteMaterial();
                    },
              child: const Text("Yes", style: TextStyle(color: Colors.red)),
            ),
          ],
        );
      },
    );
  }

  @override
  Widget build(BuildContext context) {
    return Card(
      shape: RoundedRectangleBorder(
        side: const BorderSide(width: 1, color: AppColors.purple),
        borderRadius: BorderRadius.circular(5),
      ),
      color: AppColors.white,
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 10),
      child: Slidable(
        key: ValueKey(widget.material),
        endActionPane: ActionPane(
          motion: const ScrollMotion(),
          children: [
            SlidableAction(
              onPressed: (context) => showDeleteConfirmationDialog(context),
              backgroundColor: AppColors.white,
              foregroundColor: Colors.red,
              icon: Icons.delete,
              label: 'Delete',
            ),
          ],
        ),
        child: Padding(
          padding: const EdgeInsets.all(10.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(
                    getName.toString(),
                    style: const TextStyle(
                        color: Colors.black,
                        fontWeight: FontWeight.bold,
                        fontSize: 10),
                  ),
                  Text(
                    getTime,
                    style: const TextStyle(color: Colors.black, fontSize: 10),
                  )
                ],
              ),
              MaterialViewer(title: "Photo", url: widget.material["photo"]),
              MaterialViewer(title: "Audio", url: widget.material["audio"]),
              MaterialViewer(title: "PDF", url: widget.material["pdf"]),
            ],
          ),
        ),
      ),
    );
  }
}
