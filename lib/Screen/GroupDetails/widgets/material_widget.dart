import 'dart:io';

import 'package:classwix_orbit/core/constants/copies.dart';
import 'package:classwix_orbit/core/constants/styles.dart';
import 'package:classwix_orbit/core/utils/widgets/custom_snack_bar.dart';
import 'package:classwix_orbit/provider/sample_provider.dart';
import 'package:classwix_orbit/widgets/file_picker.dart';
import 'package:classwix_orbit/widgets/material_card.dart';
import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MaterialWidget extends ConsumerStatefulWidget {
  final List<dynamic> materialList;
  final dynamic groupDetails;
  const MaterialWidget(this.groupDetails, {super.key, required this.materialList});

  @override
  _MaterialWidgetState createState() => _MaterialWidgetState();
}

class _MaterialWidgetState extends ConsumerState<MaterialWidget> {
  File? selectedPhoto;
  File? selectedAudio;
  File? selectedPdf;
  bool isUploading = false;
  Future<File?> pickFile(String type) async {
    FilePickerResult? result = await FilePicker.platform.pickFiles(
      type: type == "photo"
          ? FileType.image
          : type == "audio"
              ? FileType.audio
              : FileType.custom,
      allowedExtensions: type == "pdf" ? ['pdf'] : null,
    );

    if (result != null) {
      setState(() {
        if (type == "photo") selectedPhoto = File(result.files.single.path!);
        if (type == "audio") selectedAudio = File(result.files.single.path!);
        if (type == "pdf") selectedPdf = File(result.files.single.path!);
      });
    }
    return type == "photo"
        ? selectedPhoto
        : type == "audio"
            ? selectedAudio
            : selectedPdf;
  }

  Future<void> uploadFiles(BuildContext context) async {
    if (isUploading) return; // Prevent multiple uploads

    setState(() {
      isUploading = true; // Start uploading, show loader
    });

    final authToken = ref.read(sampleProvider);

    var request = http.MultipartRequest(
        "POST", Uri.parse("https://test.classwix.com/uploads"));
    request.headers['Authorization'] = "Bearer $authToken";
    request.fields['course_id'] = widget.groupDetails!['course_id'].toString();
    request.fields['group_id'] = widget.groupDetails!['id'].toString();

    if (selectedPhoto != null) {
      request.files
          .add(await http.MultipartFile.fromPath("photo", selectedPhoto!.path));
    }
    if (selectedAudio != null) {
      request.files
          .add(await http.MultipartFile.fromPath("audio", selectedAudio!.path));
    }
    if (selectedPdf != null) {
      request.files
          .add(await http.MultipartFile.fromPath("pdf", selectedPdf!.path));
    }

    var response = await request.send();

    setState(() {
      isUploading = false; // Stop uploading, hide loader
    });

    if (response.statusCode == 200) {
      CustomSnackBar.showSnackBar(
        context,
        "Files uploaded successfully!",
        SnackBarType.success,
      );
    } else {
      CustomSnackBar.showSnackBar(
        context,
        "Failed to upload files.",
        SnackBarType.failure,
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    return widget.materialList.isEmpty
        ? const Center(
            child: Text("No materials available",
                style: TextStyle(color: Colors.grey, fontSize: 16)))
        : SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.end,
              children: [
                Padding(
                  padding: const EdgeInsets.only(top: 10.0, bottom: 5),
                  child: Container(
                    width: MediaQuery.of(context).size.width * 0.5,
                    height: 37,
                    decoration: const BoxDecoration(
                        borderRadius: BorderRadius.all(Radius.circular(5)),
                        gradient: AppStyles.startClassGradient),
                    child: TextButton(
                      style: TextButton.styleFrom(
                        foregroundColor: Colors.white,
                        overlayColor: Colors.white.withOpacity(0.2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(5),
                        ),
                      ),
                      onPressed: () {
                        showDialog(
                          context: context,
                          builder: (BuildContext dialogContext) {
                            return StatefulBuilder(
                              // ✅ Use StatefulBuilder to update UI inside Dialog
                              builder: (context, setState) {
                                return AlertDialog(
                                  title: const Text("Upload Files"),
                                  content: Column(
                                    mainAxisSize: MainAxisSize.min,
                                    children: [
                                      Filepicker(
                                        label: selectedPhoto != null
                                            ? "Photo Selected"
                                            : "Select Photo",
                                        file: selectedPhoto,
                                        onTap: () async {
                                          final file = await pickFile("photo");
                                          if (file != null) {
                                            setState(() {
                                              selectedPhoto =
                                                  file; 
                                            });
                                          }
                                        },
                                      ),
                                      Filepicker(
                                        label: selectedAudio != null
                                            ? "Audio Selected"
                                            : "Select Audio",
                                        file: selectedAudio,
                                        onTap: () async {
                                          final file = await pickFile("audio");
                                          if (file != null) {
                                            setState(() {
                                              selectedAudio = file;
                                            });
                                          }
                                        },
                                      ),
                                      Filepicker(
                                        label: selectedPdf != null
                                            ? "PDF Selected"
                                            : "Select PDF",
                                        file: selectedPdf,
                                        onTap: () async {
                                          final file = await pickFile("pdf");
                                          if (file != null) {
                                            setState(() {
                                              selectedPdf = file;
                                            });
                                          }
                                        },
                                      ),
                                    ],
                                  ),
                                  actions: [
                                    TextButton(
                                      onPressed: () {
                                        selectedPhoto = null;
                                        selectedAudio = null;
                                        selectedPdf = null;
                                        Navigator.pop(dialogContext);
                                      },
                                      child: const Text("Cancel"),
                                    ),
                                    ElevatedButton(
                                      onPressed: isUploading
                                          ? null // Disable button while uploading
                                          : () async {
                                              await uploadFiles(dialogContext);
                                              Navigator.pop(dialogContext);
                                            },
                                      child: isUploading
                                          ? const SizedBox(
                                              width: 20,
                                              height: 20,
                                              child: CircularProgressIndicator(
                                                color: Colors.white,
                                                strokeWidth: 2,
                                              ),
                                            )
                                          : const Text("Submit"),
                                    ),
                                  ],
                                );
                              },
                            );
                          },
                        );
                      },
                      child: const Center(
                        child: Text(
                          AppCopies.upload,
                          style: TextStyle(
                            color: Colors.white,
                            fontWeight: FontWeight.bold,
                            fontSize: 13,
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
                ...widget.materialList.map((material) {
                  return MaterialCard(material: material);
                })
              ],
            ),
          );
  }
}
