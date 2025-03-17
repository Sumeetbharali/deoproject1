import 'package:classwix_orbit/Screen/Profile/widgets/confirmation_dialog.dart';
import 'package:classwix_orbit/Screen/Profile/widgets/profile_details.dart';
import 'package:classwix_orbit/core/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../controller/auth_controller.dart';
import '../../provider/sample_provider.dart';
import 'widgets/custom_generalcard.dart';

class ProfileScreen extends ConsumerWidget {
  const ProfileScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final userData = ref.watch(authProvider);
    logger.i(userData?.user.toJson());
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
                color: AppColors.appbar.withOpacity(0.8),
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
                    userData?.user.name ?? "No Name",
                    style: TextStyle(
                      fontSize: screenWidth * 0.055,
                      fontWeight: FontWeight.bold,
                      color: AppColors.white,
                    ),
                  ),
                  Text(
                    userData?.user.email ?? "No Email",
                    style: TextStyle(
                        fontSize: screenWidth * 0.04, color: AppColors.white),
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
                    showConfirmationDialog(
                        context, ref, "Are you sure you want to logout?");

                    // ConfirmationDialog(
                    //     message: "Are You Sure to Logout", ref: ref);
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
                  ProfileDetails(
                      label: "Phone no",
                      value: userData?.user.phone ?? "No phone no",
                      screenWidth: screenWidth)
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
                  SizedBox(height: MediaQuery.of(context).size.height * 0.02),
                  Text(
                    "Support",
                    style: TextStyle(
                      fontSize: screenWidth * 0.045,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                  const CustomGeneralcard(
                    title: 'Terms & Conditions',
                    icon: Icons.chevron_right,
                  ),
                  const CustomGeneralcard(
                    title: 'About Us',
                    icon: Icons.chevron_right,
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
