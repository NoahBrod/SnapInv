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
  int _selectedIndex = 0;

  static const TextStyle optionStyle = TextStyle(
    fontSize: 20,
    fontWeight: FontWeight.bold,
  );
  static List<Widget> _widgetOptions = <Widget>[
    Scaffold(
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
              padding: EdgeInsets.all(20),
              child: SizedBox(
                height: 80.0,
                child: ListView(
                  scrollDirection: Axis.horizontal,
                  children: List.generate(10, (int index) {
                    return Card(
                      color: Colors.blue[index * 100],
                      child: SizedBox(
                        width: 50.0,
                        height: 50.0,
                        child: Text("$index"),
                      ),
                    );
                  }),
                ),
              ),
            ),
            Row(
              children: <Widget>[
                // ListView(
                //   children: <Widget>[
                //     // SizedBox(
                //     //   height: 50,
                //     //   width: 50,
                //     //   child: Card(
                //     //     child: Text('data'),
                //     //   ),
                //     // ),
                //   ],
                // ),
              ],
            ),
          ],
        ),
      ),
    ),
    Scaffold(
      body: Row(
        children: [
          SizedBox(
              // width: ,
              ),
          Expanded(
            flex: 5,
            child: Container(
              color: Colors.blue,
            ),
          ),
          Expanded(
            flex: 5,
            child: Container(
              color: Colors.red,
            ),
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
        title: const Text('SnapInv Demo'),
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
        ],
      ),
    );
  }
}
