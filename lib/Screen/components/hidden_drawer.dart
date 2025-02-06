import 'package:classwix_orbit/Screen/Group.dart';
import 'package:classwix_orbit/Screen/Payroll%20Details.dart';
import 'package:classwix_orbit/Screen/class%20Schedules.dart';
import 'package:flutter/material.dart';
import 'package:hidden_drawer_menu/hidden_drawer_menu.dart';

import '../home.dart';

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
          TimetableScreen()),
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
          GroupsScreen()),
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
          PaymentsScreen()),
    ];
  }

  @override
  Widget build(BuildContext context) {
    return HiddenDrawerMenu(
      backgroundColorMenu: Colors.blueAccent,
      screens: _pages,
      initPositionSelected: 0,
      slidePercent: 40,
    );
  }
}
