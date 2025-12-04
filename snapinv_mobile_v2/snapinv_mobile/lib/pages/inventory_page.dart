import 'package:flutter/material.dart';
import 'package:snapinv_mobile/widgets/bottom_nav.dart';

class InventoryPage extends StatefulWidget {
  static final GlobalKey<_InventoryPageState> pageKey =
      GlobalKey<_InventoryPageState>();

  @override
  State<StatefulWidget> createState() => _InventoryPageState();
  
}

class _InventoryPageState extends State<InventoryPage> {

  @override
  Widget build(BuildContext context) {
    return Center(child: Text('Invetory Page (Index 1)'));
  }
  
  
}