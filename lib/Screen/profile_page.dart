// import 'package:classwix_orbit/routes/routes.dart';
// import 'package:flutter/material.dart';
// import 'package:flutter_riverpod/flutter_riverpod.dart';
// import 'package:classwix_orbit/provider/sample_provider.dart';

// class Logout extends ConsumerWidget {
//   const Logout({super.key});

//   @override
//   Widget build(BuildContext context, WidgetRef ref) {
//     return AlertDialog(
//       title: const Text("Confirm Logout"),
//       content: const Text("Are you sure you want to logout?"),
//       actions: [
//         TextButton(
//           onPressed: () {
//             Navigator.of(context).pop();
//           },
//           child: const Text("Cancel"),
//         ),
//         ElevatedButton(
//           onPressed: () {
//             Navigator.of(context).pop();
//             _logout(context, ref); // Perform logout action
//           },
//           style: ElevatedButton.styleFrom(backgroundColor: Colors.red),
//           child: const Text("Logout", style: TextStyle(color: Colors.white)),
//         ),
//       ],
//     );
//   }

//   void _logout(BuildContext context, WidgetRef ref) {
//     ref.read(sampleProvider.notifier).clearToken();
//     Navigator.pushNamedAndRemoveUntil(context, Routes.signin, (route) => false);
//   }
// }

//-----------------------[]-----------------------------------------------
import 'package:classwix_orbit/core/constants/colors.dart';
import 'package:classwix_orbit/routes/routes.dart';
import 'package:classwix_orbit/widgets/custom_generalcard.dart'
    show CustomGeneralcard;
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../provider/sample_provider.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    // Map<dynamic, dynamic> currentToken =
    //     ref.read(authServiceProvidere.notifier).getuserData();
    // logger.i(currentToken);
    // final currentToken = ref.read(authServiceProvidere.notifier).getuserData();
    // Map<dynamic, dynamic> dum = Hive.box('authBox').get('saveData');
    // logger.i(dum);
    // Map<dynamic, dynamic> currentToken = AuthServicee().getuserData();
    // logger.e(currentToken);
    // print(AuthServicee().getuserData());
    final double screenWidth = MediaQuery.of(context).size.width;
    return Scaffold(
      backgroundColor: Colors.white,
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Container(
              width: double.infinity,
              padding: EdgeInsets.symmetric(
                  vertical: MediaQuery.of(context).size.height * 0.05),
              decoration: BoxDecoration(
                color: AppColors.appbar,
                borderRadius: const BorderRadius.vertical(
                  bottom: Radius.circular(20),
                ),
              ),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Text(
                    'My Profile',
                    style: TextStyle(
                      fontSize: screenWidth * 0.06,
                      fontWeight: FontWeight.bold,
                      color: Colors.white,
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                  CircleAvatar(
                    radius: screenWidth * 0.13,
                    backgroundColor: Colors.white,
                    child: CircleAvatar(
                      radius: screenWidth * 0.125,
                      backgroundColor: Colors.transparent,
                      child: const Icon(
                        Icons.person,
                        size: 60,
                        color: AppColors.purple,
                      ),
                    ),
                  ),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.01),
                  Text(
                    // currentToken['username'].toString(),
                    "Hari Hara Sudhan",
                    style: TextStyle(
                      fontSize: screenWidth * 0.055,
                      fontWeight: FontWeight.bold,
                      color: AppColors.white,
                    ),
                  ),
                  Text(
                    // currentToken['email'].toString(),
                    "hariharasudhan@gamil.com",
                    style: TextStyle(
                      fontSize: screenWidth * 0.04,
                      color: AppColors.grey,
                    ),
                  ),
                ],
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.02),
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                ElevatedButton(
                  onPressed: () {
                    // _showConfirmationDialog(
                    //   context,
                    //   "You can't Edit",
                    // );
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.black,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.05,
                      vertical: MediaQuery.of(context).size.height * 0.015,
                    ),
                  ),
                  child: Text(
                    'Edit Profile',
                    style: TextStyle(
                        color: Colors.white, fontSize: screenWidth * 0.04),
                  ),
                ),
                SizedBox(width: screenWidth * 0.02),
                ElevatedButton(
                  onPressed: () {
                    _showConfirmationDialog(
                        context, "Are You Sure to Logout", ref);
                  },
                  style: ElevatedButton.styleFrom(
                    backgroundColor: Colors.red,
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(8),
                    ),
                    padding: EdgeInsets.symmetric(
                      horizontal: screenWidth * 0.05,
                      vertical: MediaQuery.of(context).size.height * 0.015,
                    ),
                  ),
                  child: Text(
                    'Logout',
                    style: TextStyle(
                        color: Colors.white, fontSize: screenWidth * 0.04),
                  ),
                ),
              ],
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.03),
            // User details section
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                children: [
                  _buildProfileDetail(
                    'Gender',
                    // currentToken['gender'].toString(),
                    "Male",
                    screenWidth,
                  ),
                  _buildProfileDetail(
                      'Age',
                      // currentToken['age'].toString(),
                      "19",
                      screenWidth),
                  _buildProfileDetail(
                      'Institution',
                      // currentToken['institution'].toString(),
                      "test",
                      screenWidth),
                ],
              ),
            ),
            SizedBox(height: MediaQuery.of(context).size.height * 0.03),
            Padding(
              padding: EdgeInsets.symmetric(horizontal: screenWidth * 0.05),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    "General",
                    style: TextStyle(
                      fontSize: screenWidth * 0.045,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const CustomGeneralcard(
                      title: 'Forget Password', icon: Icons.chevron_right),
                  const CustomGeneralcard(
                      title: 'Change Password', icon: Icons.chevron_right),
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                  Text(
                    "Support",
                    style: TextStyle(
                      fontSize: screenWidth * 0.045,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const CustomGeneralcard(
                    title: 'Privacy Policy',
                    icon: Icons.chevron_right,
                  ),
                  const CustomGeneralcard(
                    title: 'Terms & Conditions',
                    icon: Icons.chevron_right,
                  )
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  void _showConfirmationDialog(
      BuildContext context, String message, WidgetRef ref) {
    showDialog(
      context: context,
      builder: (BuildContext context) {
        return AlertDialog(
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(15),
          ),
          title: const Center(child: Text("Confirmation")),
          content: Text(
            message,
            style: const TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
          ),
          actions: [
            TextButton(
              onPressed: () {
                Navigator.of(context).pop();
              },
              child: const Text("Cancel", style: TextStyle(color: Colors.red)),
            ),
            ElevatedButton(
              onPressed: () {
                ref.read(sampleProvider.notifier).clearToken();
                Navigator.pushNamedAndRemoveUntil(
                    context, Routes.signin, (route) => false);
              },
              style: ElevatedButton.styleFrom(
                backgroundColor: Colors.green,
              ),
              child: const Text(
                "Yes",
                style: TextStyle(
                  color: AppColors.white,
                ),
              ),
            ),
          ],
        );
      },
    );
  }
}

Widget _buildProfileDetail(String label, String value, double screenWidth) {
  return Column(
    children: [
      Text(
        label,
        style: TextStyle(
          color: const Color(0xFF8E44AD),
          fontSize: screenWidth * 0.04,
          fontWeight: FontWeight.bold,
        ),
      ),
      const SizedBox(height: 8),
      Text(
        value,
        style: TextStyle(
          color: Colors.black,
          fontSize: screenWidth * 0.05,
        ),
      ),
    ],
  );
}

// Widget _buildMenuOption(
//     BuildContext context, String title, IconData icon, WidgetRef ref) {
//   final currentToken = ref.read(authServiceProvidere.notifier).getuserData();

//   return ListTile(
//     title: Text(title),
//     trailing: Icon(icon, color: Colors.purple),
//     onTap: () async {
//       if (title == 'Forget Password') {
//         print(currentToken['email']);
//         try {
//           await FirebaseAuth.instance
//               .sendPasswordResetEmail(email: currentToken['email']);
//           ScaffoldMessenger.of(context).showSnackBar(
//             const SnackBar(
//                 content: Text("Password reset email sent Successfully!!")),
//           );
//         } catch (e) {
//           CustomSnackBar.showSnackBar(
//             context,
//             "Error Sending Request : Check Internet",
//             SnackBarType.failure,
//           );
//         }
//       }
//     },
//   );
// }
