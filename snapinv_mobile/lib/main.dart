import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'pages/dashboard.dart';
import 'pages/camera.dart';
import 'pages/inventory.dart';

void main() {
  runApp(const MainApp());
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        textTheme: GoogleFonts.dmSansTextTheme(),
        // scaffoldBackgroundColor: const Color.fromRGBO(35, 214, 128, 1),
      ),
      home: BottomNav(),
    );
  }
}

class BottomNav extends StatefulWidget {
  const BottomNav({super.key});

  @override
  State<BottomNav> createState() => _BottomNavState();
}

class _BottomNavState extends State<BottomNav> {
  final PageController controller = PageController();
  int selectedIndex = 0;


  final pages = [
    Dashboard(),
    Camera(),
    Inventory()
  ];

  void _onTap(int index) {
    controller.jumpToPage(index);
    setState(() {
      selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'SnapInv Demo',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color.fromRGBO(35, 214, 128, 1),
      ),
      body: PageView(
        controller: controller,
        children: pages,
        onPageChanged: (index) {
          setState(() {
            selectedIndex = index;
          });
        },
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.shifting,
        currentIndex: selectedIndex,
        selectedFontSize: 15,
        onTap: _onTap,
        items: const <BottomNavigationBarItem>[
          BottomNavigationBarItem(
            icon: Icon(Icons.dashboard_outlined),
            activeIcon: Icon(Icons.dashboard),
            label: 'Dash',
            backgroundColor: Color.fromRGBO(35, 214, 128, 1),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.camera_outlined),
            activeIcon: Icon(Icons.camera),
            label: 'Camera',
            backgroundColor: Color.fromRGBO(35, 214, 128, 1),
          ),
          BottomNavigationBarItem(
            icon: Icon(Icons.shelves),
            // activeIcon: Icon(Icons.),
            label: 'Inventory',
            backgroundColor: Color.fromRGBO(35, 214, 128, 1),
          ),
        ],
      ),
    );
  }
}
