import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';

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
  int _selectedIndex = 2;

  static const TextStyle optionStyle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
  );
  static List<Widget> _widgetOptions = <Widget>[
    Scaffold(
      // Dashboard
      body: Center(
        child: Column(
          children: <Widget>[
            Padding(
              padding: EdgeInsets.all(20),
              child: SizedBox(
                height: 250,
                child: Card(
                  elevation: 5,
                  child: Column(
                    children: <Widget>[
                      const ListTile(
                        leading: Icon(Icons.album),
                        title: Text('The Enchanted Nightingale'),
                        subtitle: Text(
                            'Music by Julie Gable. Lyrics by Sidney Stein.'),
                      ),
                    ],
                  ),
                ),
              ),
            ),
            Padding(
              padding: EdgeInsets.only(left: 20, right: 20),
              child: SizedBox(
                height: 100.0,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: [
                    Card(
                      elevation: 5,
                      child: SizedBox(
                        width: 100,
                        child: Center(
                          child: Column(
                            mainAxisAlignment: MainAxisAlignment.center,
                            children: [
                              Icon(
                                Icons.account_circle,
                                size: 40,
                              ),
                              Text('Profile 1'),
                              Row(
                                mainAxisAlignment: MainAxisAlignment.center,
                                children: [
                                  Column(
                                    children: [
                                      Icon(
                                        Icons.fiber_manual_record,
                                        size: 10,
                                        color: Colors.green,
                                      ),
                                    ],
                                  ),
                                  Column(
                                    children: [
                                      Text(
                                        'Profile 1',
                                        style: TextStyle(color: Colors.green),
                                      )
                                    ],
                                  ),
                                ],
                              ),
                            ],
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ),
            ),
          ],
        ),
      ),
    ),
    Scaffold(// Camera
        ),
    Scaffold(
      // Inventory Page
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(context, route)
        },
        backgroundColor: Color.fromRGBO(35, 214, 128, 1),
        elevation: 5,
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
