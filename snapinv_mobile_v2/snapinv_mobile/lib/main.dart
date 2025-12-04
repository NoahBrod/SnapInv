import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:snapinv_mobile/app_state.dart';
import 'package:snapinv_mobile/widgets/bottom_nav.dart';

void main() {
  runApp(
    ChangeNotifierProvider(
        create: (context) => AppState(), child: const MainApp()),
  );
}

class MainApp extends StatelessWidget {
  const MainApp({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      title: 'Flutter Demo',
      theme: ThemeData(
        colorScheme: ColorScheme.fromSeed(seedColor: Colors.deepPurple),
        useMaterial3: true,
      ),
      home: BottomNav(),
    );
  }
}
