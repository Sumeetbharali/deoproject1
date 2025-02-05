import 'package:flutter/material.dart';
import 'package:hidden_drawer_menu/hidden_drawer_menu.dart';


import '../home.dart';

class HiddenDrawer extends StatefulWidget {
  const HiddenDrawer({super.key});

  @override
  State<HiddenDrawer> createState() => _HiddenDrawerState();
}

class _HiddenDrawerState extends State<HiddenDrawer> {

  List<ScreenHiddenDrawer> _pages=[];

  @override
  void initState() {

    super.initState();
    _pages = [
      ScreenHiddenDrawer(ItemHiddenMenu(
        name: 'Home',
        baseStyle:TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18,
          color: Colors.white,
        ),
        selectedStyle: TextStyle(),
        colorLineSelected: Colors.deepPurple,
      ), HomePage()),
      /*ScreenHiddenDrawer(ItemHiddenMenu(
        name: 'Settings',
        baseStyle:TextStyle(
          fontWeight: FontWeight.bold,
          fontSize: 18,
          color: Colors.white,
        ),
        selectedStyle: TextStyle(),
        colorLineSelected: Colors.deepPurple,
      ), Settings())
*/
    ];
  }

  @override
  Widget build(BuildContext context) {
    return  HiddenDrawerMenu(
      backgroundColorMenu: Colors.blueAccent,
      screens:_pages,
      initPositionSelected: 0,
      slidePercent: 40,
    );
  }
}
