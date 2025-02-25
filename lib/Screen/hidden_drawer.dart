import 'package:classwix_orbit/Screen/Group.dart';
import 'package:classwix_orbit/Screen/Payroll%20Details.dart';
import 'package:classwix_orbit/Screen/class%20Schedules.dart';
import 'package:classwix_orbit/Screen/profile_page.dart';
import 'package:classwix_orbit/core/constants/colors.dart';
import 'package:flutter/material.dart';
import 'package:hidden_drawer_menu/hidden_drawer_menu.dart';

import 'home.dart';

class HiddenDrawer extends StatefulWidget {
  const HiddenDrawer({super.key});

  @override
  State<HiddenDrawer> createState() => _HiddenDrawerState();
}

class _HiddenDrawerState extends State<HiddenDrawer> {
  List<ScreenHiddenDrawer> _pages = [];

  @override
  void initState() {
    super.initState();
    _pages = [
      ScreenHiddenDrawer(
          ItemHiddenMenu(
            name: 'Home',
            baseStyle: const TextStyle(
              fontWeight: FontWeight.bold,
              fontSize: 18,
              color: Colors.white,
            ),
            selectedStyle: const TextStyle(),
            colorLineSelected: Colors.deepPurple,
          ),
          const HomePage()),
      ScreenHiddenDrawer(
        ItemHiddenMenu(
          name: 'Class Schedules',
          baseStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.white,
          ),
          selectedStyle: const TextStyle(),
          colorLineSelected: Colors.deepPurple,
        ),
        const TimetableScreen(),
      ),
      ScreenHiddenDrawer(
        ItemHiddenMenu(
          name: 'Groups',
          baseStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.white,
          ),
          selectedStyle: const TextStyle(),
          colorLineSelected: Colors.deepPurple,
        ),
        const GroupsScreen(),
      ),
      ScreenHiddenDrawer(
        ItemHiddenMenu(
          name: 'Payroll Details',
          baseStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: Colors.white,
          ),
          selectedStyle: const TextStyle(),
          colorLineSelected: Colors.deepPurple,
        ),
        const PaymentsScreen(),
      ),
      ScreenHiddenDrawer(
        ItemHiddenMenu(
          name: 'Profile',
          baseStyle: const TextStyle(
            fontWeight: FontWeight.bold,
            fontSize: 18,
            color: AppColors.white,
          ),
          selectedStyle: const TextStyle(),
          colorLineSelected: AppColors.red,
        ),
        const ProfileScreen(),
      ),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return WillPopScope(
      onWillPop: () async {
        return false;
      },
      child: HiddenDrawerMenu(
        backgroundColorAppBar: AppColors.appbar,
        backgroundColorMenu: Colors.blueAccent,
        isTitleCentered: true,
        backgroundColorContent: Colors.white,

        tittleAppBar: Padding(
          padding: const EdgeInsets.only(right: 50.0),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Image.asset(

                "assets/logo/appbar_logo.jpg", // Your App Logo
                height: 40, // Adjust as needed
              ),
              // const Text(
              //   'ClassWix',
              //   style: TextStyle(
              //       letterSpacing: 1,
              //       color: AppColors.white,
              //       fontWeight: FontWeight.bold,
              //       fontSize: 20),
              // ),
            ],
          ),
        ),
        
        screens: _pages,
        initPositionSelected: 0,
        slidePercent: 40,
        elevationAppBar: 0,
      ),
    );
  }
}
