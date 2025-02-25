// Scaffold(
//       body: RefreshIndicator(
//         onRefresh: () async {
//           await fetchGroups(); // Ensure refresh actually calls fetchGroups
//         },
//         child: isLoading
//             ? const Center(child: CircularProgressIndicator())
//             : ListView(
//                 padding: const EdgeInsets.all(16.0),
//                 children: [
//                   if (hasError) // Display error state but keep RefreshIndicator usable
//                     Center(
//                       child: Column(
//                         mainAxisAlignment: MainAxisAlignment.center,
//                         children: [
//                           const Text(
//                             "Failed to load data",
//                             style: TextStyle(color: Colors.red, fontSize: 16),
//                           ),
//                           const SizedBox(height: 10),
//                           ElevatedButton(
//                             onPressed: fetchGroups, // Retry manually
//                             child: const Text("Retry"),
//                           ),
//                         ],
//                       ),
//                     )
//                   else if (classGroups
//                       .isEmpty) // Show message when no groups exist
//                     const Center(
//                       child: Text(
//                         "No groups assigned yet",
//                         style: TextStyle(fontSize: 16),
//                       ),
//                     )
//                   else
//                     Column(
//                       crossAxisAlignment: CrossAxisAlignment.start,
//                       children: [
//                         // Row(
//                         //   mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                         //   children: [
//                         //     const Text(
//                         //       "Today's Schedule",
//                         //       style: TextStyle(
//                         //           fontSize: 18, fontWeight: FontWeight.bold),
//                         //     ),
//                         //     TextButton(
//                         //         onPressed: () {}, child: const Text("View All"))
//                         //   ],
//                         // ),
//                         // Container(
//                         //   height: 120,
//                         //   decoration: BoxDecoration(
//                         //     color: Colors.white,
//                         //     borderRadius: BorderRadius.circular(12),
//                         //     boxShadow: const [
//                         //       BoxShadow(
//                         //         color: Colors.black12,
//                         //         blurRadius: 4,
//                         //         spreadRadius: 2,
//                         //       ),
//                         //     ],
//                         //   ),
//                         //   child: ListTile(
//                         //     leading: ClipRRect(
//                         //       borderRadius: BorderRadius.circular(8),
//                         //       child: CachedNetworkImage(
//                         //         imageUrl:
//                         //             "https://img.freepik.com/free-vector/learning-concept-illustration_114360-6186.jpg",
//                         //         fit: BoxFit.cover,
//                         //         width: 60,
//                         //         height: 60,
//                         //         placeholder: (context, url) =>
//                         //             const CircularProgressIndicator(),
//                         //         errorWidget: (context, url, error) =>
//                         //             const Icon(Icons.error,
//                         //                 size: 40, color: Colors.red),
//                         //       ),
//                         //     ),
//                         //     title: const Text(
//                         //       "Mathematics",
//                         //       style: TextStyle(
//                         //           fontSize: 16, fontWeight: FontWeight.bold),
//                         //     ),
//                         //     subtitle: Column(
//                         //       crossAxisAlignment: CrossAxisAlignment.start,
//                         //       children: [
//                         //         const Text("Dr. Sarah Johnson"),
//                         //         const SizedBox(height: 4),
//                         //         LinearProgressIndicator(
//                         //           value: 0.5,
//                         //           backgroundColor: Colors.grey.shade300,
//                         //           color: Colors.blue,
//                         //         ),
//                         //       ],
//                         //     ),
//                         //     trailing: ElevatedButton(
//                         //       onPressed: () {},
//                         //       child: const Text("Join Class"),
//                         //     ),
//                         //   ),
//                         // ),
//                         CarouselSlider(
//                           options: CarouselOptions(
//                             height: 140,
//                             autoPlay: true,
//                             enlargeCenterPage: true,
//                             viewportFraction: 1.0,
//                           ),
//                           items: imageUrls.map((imageUrl) {
//                             return Container(
//                               margin: const EdgeInsets.symmetric(horizontal: 8),
//                               decoration: BoxDecoration(
//                                 color: Colors.white,
//                                 borderRadius: BorderRadius.circular(12),
//                                 boxShadow: const [
//                                   // BoxShadow(
//                                   //   color: Colors.black12,
//                                   //   blurRadius: 4,
//                                   //   spreadRadius: 2,
//                                   // ),
//                                 ],
//                               ),
//                               child: ClipRRect(
//                                 borderRadius: BorderRadius.circular(12),
//                                 child: CachedNetworkImage(
//                                   imageUrl: imageUrl,
//                                   fit: BoxFit.cover,
//                                   width: double.infinity,
//                                   height: 120,
//                                   placeholder: (context, url) => const Center(
//                                     child: CircularProgressIndicator(),
//                                   ),
//                                   errorWidget: (context, url, error) =>
//                                       const Icon(
//                                     Icons.error,
//                                     size: 40,
//                                     color: Colors.red,
//                                   ),
//                                 ),
//                               ),
//                             );
//                           }).toList(),
//                         ),
//                         const SizedBox(height: 35),
//                         Card(
//                           shape: RoundedRectangleBorder(
//                             borderRadius: BorderRadius.circular(12),
//                           ),
//                           color: Colors.orange,
//                           child: Padding(
//                             padding: const EdgeInsets.all(12.0),
//                             child: Row(
//                               mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                               children: [
//                                 const Column(
//                                   crossAxisAlignment: CrossAxisAlignment.start,
//                                   children: [
//                                     Text(
//                                       "Plan Expiring Soon!",
//                                       style: TextStyle(
//                                         color: Colors.white,
//                                         fontSize: 17,
//                                         fontWeight: FontWeight.bold,
//                                       ),
//                                     ),
//                                     SizedBox(height: 8),
//                                     Text(
//                                       "Plan: not working",
//                                       style: TextStyle(color: Colors.white),
//                                     ),
//                                     SizedBox(height: 8),

//                                     Text(
//                                       "Expires on: Mar 16, 2025",
//                                       style: TextStyle(color: Colors.white),
//                                     ),
//                                   ],
//                                 ),
//                                 OutlinedButton(
//                                   onPressed: () {
//                                     // Add your action here
//                                   },
//                                   style: OutlinedButton.styleFrom(
//                                     backgroundColor: AppColors.white,
//                                     side: const BorderSide(color: AppColors.white),
//                                     shape: RoundedRectangleBorder(
//                                       borderRadius: BorderRadius.circular(8),
//                                     ),
//                                   ),
//                                   child:  Text(
//                                     "Renew Plan",
//                                     style: TextStyle(color: AppColors.grad_blue,fontWeight: FontWeight.bold),
//                                   ),
//                                 ),
//                               ],
//                             ),
//                           ),
//                         ),
//                         // Container(
//                         //   padding: const EdgeInsets.all(25),
//                         //   decoration: BoxDecoration(
//                         //     color: Colors.white,
//                         //     borderRadius: BorderRadius.circular(20),
//                         //     // gradient: AppStyles.startClassGradient,.
//                         //     // gradient: const LinearGradient(
//                         //     //   begin: Alignment.bottomLeft,
//                         //     //   end: Alignment.topRight,
//                         //     //   stops: [0.4, 0.8],
//                         //     //   colors: [
//                         //     //     // Color.fromARGB(255, 0, 0, 139),
//                         //     //     // Color.fromARGB(255, 65, 105, 225),
//                         //     //     Color(0XFF2563eb),
//                         //     //     Color(0XFF9333ea),
//                         //     //   ],
//                         //     // ),
//                         //     boxShadow: const [
//                         //       BoxShadow(
//                         //           color: Colors.black12,
//                         //           blurRadius: 4,
//                         //           spreadRadius: 2),
//                         //     ],
//                         //   ),
//                         //   child: Column(
//                         //     mainAxisAlignment: MainAxisAlignment.start,
//                         //     crossAxisAlignment: CrossAxisAlignment.start,
//                         //     children: [
//                         //       const Text(
//                         //         "name",
//                         //         style: TextStyle(
//                         //             fontWeight: FontWeight.bold,
//                         //             fontSize: 20,
//                         //             color: AppColors.white),
//                         //       ),
//                         //       Row(
//                         //         mainAxisAlignment:
//                         //             MainAxisAlignment.spaceBetween,
//                         //         children: [
//                         //           Text("Course: ",
//                         //               style: TextStyle(
//                         //                   fontSize: 14,
//                         //                   color: AppColors.white
//                         //                       .withOpacity(0.8))),
//                         //           OutlinedButton(
//                         //               style: TextButton.styleFrom(
//                         //                 side: const BorderSide(
//                         //                     color: AppColors.white),
//                         //                 backgroundColor: AppColors.white,
//                         //                 shape: RoundedRectangleBorder(
//                         //                   borderRadius:
//                         //                       BorderRadius.circular(20.0),
//                         //                 ),
//                         //               ),
//                         //               onPressed: () {},
//                         //               child: Text(
//                         //                 'View Details',
//                         //                 style: TextStyle(
//                         //                     color: AppColors.grad_blue,
//                         //                     fontWeight: FontWeight.bold,
//                         //                     fontSize: 15),
//                         //               ))
//                         //         ],
//                         //       )
//                         //     ],
//                         //   ),
//                         // ),
//                         // Quick Access Icons
//                         // Row(
//                         //   mainAxisAlignment: MainAxisAlignment.spaceAround,
//                         //   children: [
//                         //     _buildQuickAccessIcon(
//                         //         Icons.assignment, "Assignments"),
//                         //     _buildQuickAccessIcon(Icons.book, "Materials"),
//                         //     _buildQuickAccessIcon(Icons.chat, "Discussion"),
//                         //     _buildQuickAccessIcon(
//                         //         Icons.calendar_today, "Calendar"),
//                         //   ],
//                         // ),
//                         const SizedBox(height: 20),
//                         // My Class Groups Section
//                         Row(
//                           mainAxisAlignment: MainAxisAlignment.spaceBetween,
//                           children: [
//                             const Text(
//                               "My Class Groups",
//                               style: TextStyle(
//                                   fontSize: 18, fontWeight: FontWeight.bold),
//                             ),
//                             TextButton(
//                                 onPressed: () {}, child: const Text("See All"))
//                           ],
//                         ),
//                         ListView.builder(
//                           shrinkWrap: true,
//                           physics: const NeverScrollableScrollPhysics(),
//                           itemCount: classGroups.length,
//                           itemBuilder: (context, index) {
//                             return _buildClassGroupCard(classGroups[index]);
//                           },
//                         ),
//                       ],
//                     ),
//                 ],
//               ),
//       ),
//     );



  // Widget _buildQuickAccessIcon(IconData icon, String label) {
  //   return Column(
  //     children: [
  //       CircleAvatar(
  //         radius: 24,
  //         backgroundColor: Colors.blue.shade100,
  //         child: Icon(icon, color: Colors.blue, size: 28),
  //       ),
  //       const SizedBox(height: 8),
  //       Text(label, style: const TextStyle(fontSize: 14)),
  //     ],
  //   );
  // }