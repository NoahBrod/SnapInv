import 'package:flutter/material.dart';
import '../entities/inventoryitem.dart';

class ItemDetailsPage extends StatefulWidget {
  final InventoryItem item;
  const ItemDetailsPage({required this.item});

  @override
  State<ItemDetailsPage> createState() => _ItemDetailsPageState(item: item);
}

class _ItemDetailsPageState extends State<ItemDetailsPage> {
  bool editing = false;

  final InventoryItem item;

  _ItemDetailsPageState({required this.item});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          item.name,
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color.fromRGBO(35, 214, 128, 1),
        iconTheme: IconThemeData(color: Colors.white),
        actions: [
          TextButton(
            onPressed: () {},
            child: Text('Edit'),
          ),
        ],
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.file(
              item.image!,
              width: 300,
              height: 300,
              fit: BoxFit.cover,
            ),
            Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Container(
                  width: double.infinity,
                  padding: const EdgeInsets.all(3.0),
                  child: Text(
                    'Name:',
                    style: TextStyle(fontSize: 24, fontWeight: FontWeight.bold),
                  ),
                ),
                Container(
                  width: MediaQuery.of(context).size.width / 2,
                  padding: const EdgeInsets.all(3.0),
                  decoration: BoxDecoration(
                      borderRadius: BorderRadius.all(Radius.circular(5)),
                      color: Colors.grey),
                  child: Text(
                    item.name,
                    style: TextStyle(
                      fontSize: 18,
                    ),
                  ),
                )
              ],
            ),
            SizedBox(height: 20),
            Text(
              'Description: ${item.description}',
              style: TextStyle(fontSize: 18),
            ),
            SizedBox(height: 20),
            Text(
              'Price: \$${item.price}',
              style: TextStyle(fontSize: 18),
            ),
          ],
        ),
      ),
    );
  }
}
