import 'package:flutter/material.dart';

class Inventory extends StatefulWidget {
  const Inventory();

  @override
  State<Inventory> createState() => _InventoryState();
}

class _InventoryState extends State<Inventory>
    with AutomaticKeepAliveClientMixin {
  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
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
    );
  }

  @override
  bool get wantKeepAlive => true;
}
