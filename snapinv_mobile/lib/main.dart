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
  final PageController controller = PageController(initialPage: 2);
  int selectedIndex = 2;

  final pageNames = ["Dashboard", "", "Inventory"];

  final pages = [DashboardPage(), CameraPage(), InventoryPage()];

  void _onTap(int index) {
    controller.jumpToPage(index);
    setState(() {
      selectedIndex = index;
    });

    if (index == 2) {
      print(InventoryPage().key);
      InventoryPage.pageKey.currentState?.getInventory();
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
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
            label: 'Inventory',
            backgroundColor: Color.fromRGBO(35, 214, 128, 1),
          ),
        ],
      ),
    );
  }
}
