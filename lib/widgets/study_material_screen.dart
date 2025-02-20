// // import 'package:cached_network_image/cached_network_image.dart';
// import 'package:flutter/material.dart';
// // import 'package:flutter_bloc/flutter_bloc.dart';
// // import 'package:gyanavi_academy/bloc/study_materials/study_materials_bloc.dart';
// // import 'package:gyanavi_academy/core/constants/design_core.dart';
// // import 'package:gyanavi_academy/models/study_materials/study_materials_model.dart';
// // import 'package:gyanavi_academy/repository/study_materials/study_material_service.dart';
// // import 'package:gyanavi_academy/widgets/audio_player_bottom_sheet.dart';
// // import 'package:gyanavi_academy/widgets/pdf_viewer_screen.dart';
// import 'package:url_launcher/url_launcher.dart';

// class StudyMaterialsScreen extends StatefulWidget {
//   const StudyMaterialsScreen({super.key});

//   @override
//   State<StudyMaterialsScreen> createState() => _StudyMaterialsScreenState();
// }

// class _StudyMaterialsScreenState extends State<StudyMaterialsScreen> {
//   late StudyMaterialsBloc _studyMaterialsBloc;

//   @override
//   void initState() {
//     super.initState();
//     _studyMaterialsBloc = StudyMaterialsBloc(
//       service: StudyMaterialService(),
//     )..add(FetchStudyMaterials());
//   }

//   @override
//   void dispose() {
//     _studyMaterialsBloc.close();
//     super.dispose();
//   }

//   Future<void> _refreshMaterials() async {
//     _studyMaterialsBloc.add(FetchStudyMaterials());
//   }

//   @override
//   Widget build(BuildContext context) {
//     return Scaffold(
//       appBar:  RoundedAppBar(
//         title: 'Study Material',
//         automaticallyImplyLeading: true,
//       ),
//       body: BlocBuilder<StudyMaterialsBloc, StudyMaterialsState>(
//         bloc: _studyMaterialsBloc,
//         builder: (context, state) {
//           return RefreshIndicator(
//             onRefresh: _refreshMaterials,
//             child: _buildBody(state),
//           );
//         },
//       ),
//     );
//   }

//   Widget _buildBody(StudyMaterialsState state) {
//     if (state is StudyMaterialsLoading) {
//       return ListView(
//         physics: const AlwaysScrollableScrollPhysics(),
//         children: const [
//           SizedBox(
//             height: 300,
//             child: Center(child: CircularProgressIndicator()),
//           )
//         ],
//       );
//     } else if (state is StudyMaterialsError) {
//       return ListView(
//         physics: const AlwaysScrollableScrollPhysics(),
//         children: [
//           SizedBox(
//             height: MediaQuery.of(context).size.height * 0.8,
//             child: Center(child: Text('Error: ${state.message}')),
//           )
//         ],
//       );
//     } else if (state is StudyMaterialsLoaded) {
//       final materials = state.materials;
//       if (materials.isEmpty) {
//         return ListView(
//           physics: const AlwaysScrollableScrollPhysics(),
//           children: const [
//              SizedBox(
//               height: 300,
//               child: Center(
//                 child: Text('No study materials available'),
//               ),
//             ),
//           ],
//         );
//       }

//       return ListView.separated(
//         padding: const EdgeInsets.all(16),
//         itemCount: materials.length,
//         separatorBuilder: (context, index) => const SizedBox(height: 12),
//         itemBuilder: (context, index) {
//           final material = materials[index];
//           return _buildMaterialCard(material);
//         },
//       );
//     }

//     return const SizedBox.shrink();
//   }

//   Widget _buildMaterialCard(StudyMaterial material) {
//     return Card(
//       elevation: 4,
//       shape: RoundedRectangleBorder(borderRadius: BorderRadius.circular(12)),
//       child: Padding(
//         padding: const EdgeInsets.all(16),
//         child: Column(
//           crossAxisAlignment: CrossAxisAlignment.start,
//           children: [
//             Row(
//               children: [
//                 _buildFileTypeIcons(material),
//                 const Spacer(),
//                 Text(
//                   material.formattedDate,
//                   style: Theme.of(context).textTheme.bodySmall?.copyWith(
//                         color: Colors.grey.shade600,
//                       ),
//                 ),
//               ],
//             ),
//             const SizedBox(height: 12),
//             Text(
//               material.title,
//               style: Theme.of(context).textTheme.titleMedium?.copyWith(
//                     fontWeight: FontWeight.w600,
//                   ),
//             ),
//             const SizedBox(height: 8),
//             if (material.groupId != 0)
//               Text(
//                 'Group ${material.groupId}',
//                 style: Theme.of(context).textTheme.bodySmall?.copyWith(
//                       color: Colors.blue.shade700,
//                       fontWeight: FontWeight.w500,
//                     ),
//               ),
//           ],
//         ),
//       ),
//     );
//   }

//   Widget _buildFileTypeIcons(StudyMaterial material) {
//     final icons = <Widget>[];

//     if (material.pdfUrl != null) {
//       icons.add(
//         InkWell(
//           onTap: () => _openPdf(material.pdfUrl!),
//           child: const Icon(Icons.picture_as_pdf, color: Colors.red, size: 38),
//         ),
//       );
//     }

//     if (material.photoUrl != null) {
//       icons.add(
//         InkWell(
//           onTap: () => _showImagePreview(material.photoUrl!),
//           child: const Icon(Icons.image, color: Colors.green, size: 38),
//         ),
//       );
//     }

//     if (material.audioUrl != null) {
//       icons.add(
//         InkWell(
//           onTap: () => _showAudioPlayer(material.audioUrl!),
//           child: const Icon(Icons.audiotrack, color: Colors.blue, size: 38),
//         ),
//       );
//     }

//     return Row(
//       children: icons
//           .map((icon) => Padding(
//                 padding: const EdgeInsets.only(right: 8),
//                 child: icon,
//               ))
//           .toList(),
//     );
//   }

//   void _openPdf(String pdfUrl) {
//     Navigator.push(
//       context,
//       MaterialPageRoute(
//         builder: (context) => PdfViewerScreen(pdfUrl: pdfUrl),
//       ),
//     );
//   }

//   void _showAudioPlayer(String audioUrl) {
//     showModalBottomSheet(
//       context: context,
//       builder: (context) => AudioPlayerBottomSheet(audioUrl: audioUrl),
//     );
//   }

//   Future<void> _launchUrl(String url) async {
//     if (!await launchUrl(Uri.parse(url),
//         mode: LaunchMode.externalApplication)) {
//       ScaffoldMessenger.of(context).showSnackBar(
//         SnackBar(content: Text('Could not launch $url')),
//       );
//     }
//   }

//   void _showImagePreview(String imageUrl) {
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
// }


