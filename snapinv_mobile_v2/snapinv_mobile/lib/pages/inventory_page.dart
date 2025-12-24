import 'package:flutter/material.dart';
import 'package:snapinv_mobile/entities/inventory_item.dart';
import 'package:snapinv_mobile/pages/subpages/add_page.dart';

class InventoryPage extends StatefulWidget {
  const InventoryPage({super.key});

  // static final GlobalKey<_InventoryPageState> pageKey =
  //     GlobalKey<_InventoryPageState>();

  @override
  State<StatefulWidget> createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage> {
  List<InventoryItem> items = [];

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newItem = await Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => AddItemPage()),
          );

          if (newItem != null) {
            setState(() {
              items.add(newItem);
            });
          }
        },
        backgroundColor: Color.fromRGBO(35, 214, 128, 1),
        elevation: 5,
        tooltip: 'Add Item',
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
}
