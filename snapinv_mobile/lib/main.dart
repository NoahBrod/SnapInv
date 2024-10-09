import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

import 'pages/dashboard.dart';

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
  int _selectedIndex = 0;

  final pages = [
    Dashboard(),
  ];

  static List<Widget> _widgetOptions = <Widget>[
    Dashboard(),
    Scaffold(// Camera
        ),
    Scaffold(
      // Inventory Page
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          // Navigator.push(context, )
        },
        backgroundColor: Color.fromRGBO(35, 214, 128, 1),
        elevation: 5,
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      body: ListView(
        children: [
          ListTile(
            title: Text('Item 1'),
          ),
        ],
      ),
    ),
  ];

  void _onTap(int index) {
    setState(() {
      _selectedIndex = index;
    });
  }

  @override
  Widget build(BuildContext context) {
    // TODO: implement build
    return Scaffold(
      appBar: AppBar(
        title: const Text(
          'SnapInv Demo',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color.fromRGBO(35, 214, 128, 1),
      ),
      body: Center(
        child: _widgetOptions.elementAt(_selectedIndex),
      ),
      bottomNavigationBar: BottomNavigationBar(
        type: BottomNavigationBarType.shifting,
        currentIndex: _selectedIndex,
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
