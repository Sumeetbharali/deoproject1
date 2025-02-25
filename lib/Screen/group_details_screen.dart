import 'dart:convert';

import 'package:classwix_orbit/controller/auth_controller.dart';
import 'package:classwix_orbit/core/constants/colors.dart';
import 'package:classwix_orbit/core/constants/copies.dart';
import 'package:classwix_orbit/core/constants/styles.dart';
import 'package:classwix_orbit/core/utils/widgets/custom_snack_bar.dart';
import 'package:classwix_orbit/widgets/file_picker.dart';
import 'package:classwix_orbit/widgets/group_information.dart';
import 'package:classwix_orbit/widgets/material_card.dart';
import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:shared_preferences/shared_preferences.dart';
import 'package:url_launcher/url_launcher.dart';

import 'package:file_picker/file_picker.dart';
import 'dart:io';
import 'dart:math';
import 'package:intl/intl.dart';
import '../widgets/live_information.dart';

class GroupDetailsScreen extends StatefulWidget {
  final int groupId;

  const GroupDetailsScreen({super.key, required this.groupId});

  @override
  _GroupDetailsScreenState createState() => _GroupDetailsScreenState();
}

class _GroupDetailsScreenState extends State<GroupDetailsScreen> {
  Map<String, dynamic>? groupDetails;

  List<dynamic> videoList = [];
  List<dynamic> materialsList = [];
  File? selectedPhoto;
  File? selectedAudio;
  File? selectedPdf;
  String classCode = "#########";
  String? startTime;
  bool classStarted = false;
  bool isUploading = false;
  TextEditingController linkController = TextEditingController();
  TextEditingController timeController = TextEditingController();

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

  bool isLoading = true;
  bool hasError = false;

  @override
  void initState() {
    super.initState();
    fetchData();
  }

  Future<bool> checkInternetConnection() async {
    try {
      final result = await InternetAddress.lookup('google.com');
      return result.isNotEmpty && result[0].rawAddress.isNotEmpty;
    } on SocketException catch (_) {
      return false;
    }
  }

  Future<void> fetchData() async {
    setState(() {
      isLoading = true;
      hasError = false;
    });

    bool isConnected = await checkInternetConnection();

    if (!isConnected) {
      setState(() {
        hasError = true;
        isLoading = false;
      });
      return;
    }

    await Future.wait([
      fetchGroupDetails(),
      fetchVideos(),
      fetchMaterials(),
    ]);

    setState(() {
      isLoading = false;
    });
  }

  Future<void> fetchGroupDetails() async {
    final prefs = await SharedPreferences.getInstance();
    final String? tokenCred = prefs.getString('token');
    final String url =
        "https://api.classwix.com/api/admin/groups/${widget.groupId}";
    String token = "Bearer ${tokenCred.toString()}";

    try {
      final response =
          await http.get(Uri.parse(url), headers: {"Authorization": token});

      if (response.statusCode == 200) {
        final Map<String, dynamic> responseData = json.decode(response.body);
        if (!mounted) return;

        setState(() {
          groupDetails = responseData["details"] ?? {};
        });
      } else {
        throw Exception("Failed to load group details");
      }
    } catch (e) {
      setState(() {
        hasError = true;
      });
    }
  }

  Future<void> fetchVideos() async {
    final prefs = await SharedPreferences.getInstance();
    final String? tokenCred = prefs.getString('token');
    final String url =
        "https://api.classwix.com/api/courses/${widget.groupId}/videos";
    String token = "Bearer ${tokenCred.toString()}";

    try {
      final response =
          await http.get(Uri.parse(url), headers: {"Authorization": token});
      if (response.statusCode == 200) {
        final List<dynamic> videos = json.decode(response.body);
        setState(() {
          videoList = videos;
        });
      }
    } catch (e) {
      debugPrint("Error fetching videos: $e");
    }
  }

  Future<void> fetchMaterials() async {
    final prefs = await SharedPreferences.getInstance();
    final String? tokenCred = prefs.getString('token');
    final String url =
        "https://api.classwix.com/api/materials/${widget.groupId}";
    String token = "Bearer ${tokenCred.toString()}";

    try {
      final response =
          await http.get(Uri.parse(url), headers: {"Authorization": token});

      if (response.statusCode == 200) {
        final Map<String, dynamic> data = jsonDecode(response.body);
        setState(() {
          materialsList = data["materials"] ?? [];
        });
      } else {
        debugPrint(
            "Failed to fetch materials. Status Code: ${response.statusCode}");
      }
    } catch (e) {
      debugPrint("Error fetching materials: $e");
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        leading: IconButton(
          onPressed: () {
            Navigator.pop(context);
          },
          icon: const Icon(Icons.arrow_back_ios_new_rounded,
              color: AppColors.purple),
        ),
        title: const Text(
          "Group Details",
          style: TextStyle(
            color: AppColors.purple,
            fontWeight: FontWeight.bold,
            fontSize: 18,
          ),
        ),
      ),
      body: RefreshIndicator(
        onRefresh: fetchData,
        child: isLoading
            ? const Center(child: CircularProgressIndicator())
            : hasError
                ? Center(
                    child: Column(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        const Text(
                          "No internet connection. Please try again.",
                          style: TextStyle(color: Colors.red, fontSize: 16),
                        ),
                        const SizedBox(height: 10),
                        ElevatedButton(
                          onPressed: fetchData, // Retry on button press
                          child: const Text("Retry"),
                        ),
                      ],
                    ),
                  )
                : ListView(
                    padding: const EdgeInsets.all(16.0),
                    children: [
                      _classCode(),
                      const SizedBox(height: 15),
                      GroupInformation(groupDetails: groupDetails!),
                      const SizedBox(height: 20),
                      LiveInformation(
                        linkController: linkController,
                        timeController: timeController,
                        groupId: widget.groupId,
                      ),
                      const SizedBox(height: 20),
                      SizedBox(
                        height: 400,
                        child: _buildTabView(),
                      ),
                    ],
                  ),
      ),
    );
  }

  void _startClass() {
    const chars = "abcdefghijklmnopqrstuvwxyz0123456789@#";
    final random = Random();
    String generatedCode =
        List.generate(8, (index) => chars[random.nextInt(chars.length)]).join();

    String formattedTime = DateFormat('hh:mm a').format(DateTime.now());

    setState(() {
      classCode = generatedCode;
      startTime = formattedTime;
      classStarted = true;
    });

    showDialog(
      context: context,
      builder: (context) {
        return AlertDialog(
          title: const Text("Class Started"),
          content: Text(
              "Class has started at $formattedTime\nClass Code: $generatedCode"),
          actions: [
            TextButton(
              onPressed: () => Navigator.pop(context),
              child: const Text("OK"),
            ),
          ],
        );
      },
    );
  }

  Widget _classCode() {
    return Column(
      mainAxisAlignment: MainAxisAlignment.end,
      crossAxisAlignment: CrossAxisAlignment.end,
      children: [
        Row(
          crossAxisAlignment: CrossAxisAlignment.end,
          mainAxisAlignment: MainAxisAlignment.end,
          children: [
            const Text("Class Code: ",
                style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold)),
            const SizedBox(height: 10),
            Container(
              margin: const EdgeInsets.only(left: 2),
              padding: const EdgeInsets.all(4),
              decoration: BoxDecoration(
                border:
                    Border.all(style: BorderStyle.solid, color: Colors.grey),
              ),
              child: Text(
                classCode,
                style: const TextStyle(
                  color: Colors.blueGrey,
                ),
                softWrap: true,
              ),
            ),
          ],
        ),
        if (classStarted) ...[
          Row(
            crossAxisAlignment: CrossAxisAlignment.end,
            mainAxisAlignment: MainAxisAlignment.end,
            children: [
              Padding(
                padding: const EdgeInsets.only(top: 10.0),
                child: Container(
                  width: MediaQuery.of(context).size.width * 0.3,
                  height: 37,
                  decoration: const BoxDecoration(
                    borderRadius: BorderRadius.all(Radius.circular(5)),
                    gradient: LinearGradient(
                      colors: [Colors.blue, Colors.green],
                    ),
                  ),
                  child: TextButton(
                    style: TextButton.styleFrom(
                      foregroundColor: Colors.white,
                      overlayColor: Colors.white.withOpacity(0.2),
                      shape: RoundedRectangleBorder(
                        borderRadius: BorderRadius.circular(5),
                      ),
                    ),
                    // onPressed: () => _joinClass(),
                    // onPressed: () =>launch("https://meet.google.com/acm-zvtb-yby"),
                    onPressed: () => launch(linkController.text),

                    child: const Center(
                      child: Text(
                        "Join Class", // Button label
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
            ],
          ),

          //
        ] else ...[
          Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: Container(
              width: MediaQuery.of(context).size.width * 0.3,
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
                onPressed: _startClass,
                child: const Center(
                  child: Text(
                    "Start Class",
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
        ],
      ],
    );
  }

  /// Tab View for "Recorded Videos" & "Materials"
  Widget _buildTabView() {
    return DefaultTabController(
      length: 2,
      child: Column(
        children: [
          TabBar(
            labelColor: AppColors.grad_blue,
            unselectedLabelColor: AppColors.grey,
            indicatorColor: AppColors.grad_blue,
            tabs: const [
              Tab(text: "Recorded"),
              Tab(text: "Materials"),
            ],
          ),
          Expanded(
            child: TabBarView(
              children: [
                _buildVideoList(),
                _buildMaterialsList(),
              ],
            ),
          ),
        ],
      ),
    );
  }

  /// Display recorded videos list
  Widget _buildVideoList() {
    return videoList.isEmpty
        ? const Center(
            child: Text("No videos available",
                style: TextStyle(color: Colors.grey)))
        : ListView.builder(
            padding: const EdgeInsets.all(10),
            itemCount: videoList.length,
            itemBuilder: (context, index) {
              final video = videoList[index];
              return _buildVideoTile(video);
            },
          );
  }

  Widget _buildVideoTile(dynamic video) {
    logger.i(video["video_path"]);

    return Card(
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.circular(10),
        side:
            const BorderSide(style: BorderStyle.solid, color: AppColors.purple),
      ),
      color: AppColors.white,
      margin: const EdgeInsets.symmetric(vertical: 8),
      child: ListTile(
        title: Text(
          video["title"] ?? "Untitled",
          style: const TextStyle(
            fontSize: 18,
            fontWeight: FontWeight.bold,
            color: AppColors.purple,
          ),
        ),
        minVerticalPadding: 15,
        trailing: IconButton(
          icon: const Icon(Icons.open_in_new, color: Colors.blue),
          onPressed: () => launch((video["video_path"])),
        ),
      ),
    );
  }

  Future<void> uploadFiles(BuildContext context) async {
    if (isUploading) return; // Prevent multiple uploads

    setState(() {
      isUploading = true; // Start uploading, show loader
    });

    final prefs = await SharedPreferences.getInstance();
    String? token = prefs.getString('token');

    var request = http.MultipartRequest(
        "POST", Uri.parse("https://test.classwix.com/uploads"));
    request.headers['Authorization'] = "Bearer $token";
    request.fields['course_id'] = groupDetails!['course_id'].toString();
    request.fields['group_id'] = groupDetails!['id'].toString();

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

  /// Display materials list
  Widget _buildMaterialsList() {
    return materialsList.isEmpty
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
                                                  file; // ✅ Update UI
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
                                              selectedAudio =
                                                  file; 
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
                ...materialsList.map((material) {
                  return MaterialCard(material: material);
                })
              ],
            ),
          );
  }

  Widget buildFilePicker(String label, File? file, VoidCallback onTap) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(label, style: const TextStyle(fontWeight: FontWeight.bold)),
        GestureDetector(
          onTap: onTap,
          child: Container(
            padding: const EdgeInsets.all(10),
            margin: const EdgeInsets.symmetric(vertical: 5),
            decoration: BoxDecoration(
                border: Border.all(color: Colors.blue),
                borderRadius: BorderRadius.circular(5)),
            child: Text(
                file != null ? file.path.split('/').last : "Select File",
                style: const TextStyle(color: Colors.blue)),
          ),
        ),
      ],
    );
  }
}
