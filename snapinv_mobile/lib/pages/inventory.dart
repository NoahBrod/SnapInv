import 'package:flutter/material.dart';
import 'additem.dart';
import 'itemdetails.dart';
import '../entities/inventoryitem.dart';

class InventoryPage extends StatefulWidget {
  const InventoryPage();

  @override
  State<InventoryPage> createState() => _InventoryPageState();
}

class _InventoryPageState extends State<InventoryPage>
    with AutomaticKeepAliveClientMixin {
  List<InventoryItem> items = [
    InventoryItem(
        name: 'Item 1',
        description: 'This is Item 1 description.',
        price: 9.99),
    InventoryItem(
        name: 'Item 2',
        description: 'This is Item 2 description.',
        price: 19.99),
    InventoryItem(
        name: 'Item 3',
        description: 'This is Item 3 description.',
        price: 29.99),
  ];

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      // Inventory Page
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
        child: Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
      body: Scaffold(
        body: Container(
          color: Color.fromRGBO(235, 235, 235, 1),
          child: ListView.separated(
            itemCount: items.length,
            itemBuilder: (context, index) {
              final item = items[index];
              return Card(
                margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                // decoration: BoxDecoration(
                //   color: Colors.white,
                //   borderRadius: BorderRadius.circular(15),
                //   boxShadow: [
                //     BoxShadow(
                //       color: Colors.black,
                //       blurRadius: 5,
                //       offset: Offset(2, 2),
                //     ),
                //   ],
                // ),
                color: Colors.white,
                elevation: 5,
                child: ListTile(
                  title: Text(item.name),
                  subtitle: Text(item.description),
                  onTap: () {
                    Navigator.push(
                      context,
                      MaterialPageRoute(
                          builder: (context) => ItemDetailsPage(item: item)),
                    );
                  },
                ),
              );
            },
            separatorBuilder: (context, index) {
              return Divider(
                color: Colors.transparent,
                height: 10,
              );
            },
            padding: EdgeInsets.all(5),
          ),
        ),
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
