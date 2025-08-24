import 'package:flutter/material.dart';
import 'package:google_fonts/google_fonts.dart';
import 'package:snapinv_mobile/app_state.dart';
import 'package:provider/provider.dart';
import 'package:snapinv_mobile/widgets/main/bottom_nav.dart';
// import 'pages/dashboard.dart';
// import 'pages/camera.dart';
// import 'pages/inventory.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
      create: (context) => AppState(),
      child: const MainApp()
    ),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      theme: ThemeData(
        // useMaterial3: false,
        textTheme: GoogleFonts.dmSansTextTheme(),
        // scaffoldBackgroundColor: const Color.fromRGBO(35, 214, 128, 1),
      ),
      home: BottomNav(),
    );
  }
}