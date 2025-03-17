import 'dart:io';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:file_picker/file_picker.dart';
import 'package:path_provider/path_provider.dart';
import 'package:http/http.dart' as http;
import '../../../core/constants/copies.dart';
import '../../../core/constants/styles.dart';
import '../../../core/utils/widgets/custom_snack_bar.dart';
import '../../../provider/sample_provider.dart';
import '../../../widgets/file_picker.dart';
import 'material_card.dart';

class MaterialWidget extends ConsumerStatefulWidget {
  final List<dynamic> materialList;

  final dynamic groupDetails;
  const MaterialWidget(
      {super.key, required this.groupDetails, required this.materialList});

  @override
  _MaterialWidgetState createState() => _MaterialWidgetState();
}

class _MaterialWidgetState extends ConsumerState<MaterialWidget> {
  File? selectedPhoto;
  File? selectedAudio;
  File? selectedPdf;
  bool isUploading = false;

  Future<File?> pickFile(String type) async {
    try {
      FilePickerResult? result = await FilePicker.platform.pickFiles(
        type: type == "photo"
            ? FileType.image
            : type == "audio"
                ? FileType.audio
                : FileType.custom,
        allowedExtensions: type == "pdf" ? ['pdf'] : null,
      );

      if (result == null || result.files.isEmpty) {
        logger.e("No file selected!");
        return null;
      }

      PlatformFile file = result.files.first;
      return file.path != null
          ? File(file.path!)
          : await _convertUriToFile(file);
    } catch (e) {
      CustomSnackBar.showSnackBar(
          context, "Error picking file: $e", SnackBarType.failure);
      return null;
    }
  }

  Future<File?> _convertUriToFile(PlatformFile file) async {
    try {
      final bytes = await File(file.path!).readAsBytes();
      final tempDir = await getTemporaryDirectory();
      final tempFile = File('${tempDir.path}/${file.name}');
      await tempFile.writeAsBytes(bytes);
      return tempFile;
    } catch (e) {
      logger.e("Error converting URI: $e");
      return null;
    }
  }

  Future<void> uploadFiles(
      BuildContext context, Function setDialogState) async {
    if (isUploading) return; // Prevent multiple uploads

    if (selectedPhoto == null && selectedAudio == null && selectedPdf == null) {
      CustomSnackBar.showSnackBar(
          context,
          "Please select at least one file before uploading.",
          SnackBarType.failure);
      return;
    }

    setDialogState(() {
      isUploading = true;
    });

    final authToken = ref.read(sampleProvider);
    if (authToken == null || authToken.isEmpty) {
      setDialogState(() => isUploading = false);
      return;
    }

    try {
      var request = http.MultipartRequest(
          "POST", Uri.parse("https://test.classwix.com/uploads"));
      request.headers['Authorization'] = "Bearer $authToken";
      request.fields['course_id'] =
          widget.groupDetails!['course_id'].toString();
      request.fields['group_id'] = widget.groupDetails!['id'].toString();

      if (selectedPhoto != null && await selectedPhoto!.exists()) {
        request.files.add(
            await http.MultipartFile.fromPath("photo", selectedPhoto!.path));
      }
      if (selectedAudio != null && await selectedAudio!.exists()) {
        request.files.add(
            await http.MultipartFile.fromPath("audio", selectedAudio!.path));
      }
      if (selectedPdf != null && await selectedPdf!.exists()) {
        request.files
            .add(await http.MultipartFile.fromPath("pdf", selectedPdf!.path));
      }

      var response = await request.send();
      var responseBody = await response.stream.bytesToString();
      logger.d("Response: $responseBody");

      if (response.statusCode == 200 || response.statusCode == 201) {
        CustomSnackBar.showSnackBar(
            context, "Files uploaded successfully!", SnackBarType.success);
        setDialogState(() {
          selectedPhoto = null;
          selectedAudio = null;
          selectedPdf = null;
        });
      } else {
        CustomSnackBar.showSnackBar(
            context,
            "Failed to upload files. Error ${response.statusCode}",
            SnackBarType.failure);
      }
    } catch (e) {
      CustomSnackBar.showSnackBar(
          context, "Upload failed! Please try again.", SnackBarType.failure);
    } finally {
      setDialogState(() => isUploading = false);
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
                              builder: (context, setDialogState) {
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
                                            setDialogState(() {
                                              selectedPhoto = file;
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
                                            setDialogState(() {
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
                                            setDialogState(() {
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
                                        setDialogState(() {
                                          selectedPhoto = null;
                                          selectedAudio = null;
                                          selectedPdf = null;
                                        });
                                        Navigator.pop(dialogContext);
                                      },
                                      child: const Text("Cancel"),
                                    ),
                                    ElevatedButton(
                                      onPressed: isUploading
                                          ? null
                                          : () async {
                                              await uploadFiles(dialogContext,
                                                  setDialogState);
                                              if (!isUploading) {
                                                Navigator.pop(dialogContext);
                                              }
                                            },
                                      child: isUploading
                                          ? const CircularProgressIndicator(
                                              color: Colors.white,
                                              strokeWidth: 2)
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
                }),
              ],
            ),
          );
  }
}
