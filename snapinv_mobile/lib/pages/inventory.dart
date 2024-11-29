import 'dart:convert';

import 'package:flutter/material.dart';
import 'additem.dart';
import 'itemdetails.dart';
import '../entities/inventoryitem.dart';

import 'package:http/http.dart' as http;

class InventoryPage extends StatefulWidget {
  static final GlobalKey<InventoryPageState> pageKey =
      GlobalKey<InventoryPageState>();

  InventoryPage() : super(key: pageKey);

  @override
  State<InventoryPage> createState() => InventoryPageState();
}

class InventoryPageState extends State<InventoryPage>
    with AutomaticKeepAliveClientMixin {
  List<InventoryItem> items = [];
  bool selectable = false;

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    getInventory();
  }

  void _toggleCheckbox(int index, bool? value) {
    setState(() {
      items[index].selected = value ?? false;
    });
  }

  void _toggleSelectable() {
    setState(() {
      selectable = true;
    });
  }

  void addItem(InventoryItem newItem) {
    setState(() {
      items.add(newItem); // Add new item to the list
    });
  }

  Future<void> getInventory() async {
    final url = Uri.parse('http://192.168.4.33:8080/api/v1/item/items');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        // print(response.body);
      } else {
        print('Error: ${response.statusCode}');
      }

      List<dynamic> jsonList = jsonDecode(response.body);
      List<InventoryItem> itemList =
          jsonList.map((json) => InventoryItem.fromJson(json)).toList();

      if (itemList.isNotEmpty) {
        for (var item in itemList) {
          if (!items.contains(item)) {
            addItem(item);
          }
        }
      } else {
        setState(() {
          items = [];
        });
      }
    } catch (e) {
      print('An error occurred: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      // Inventory Page
      appBar: AppBar(
        title: Text(
          'Inventory',
          style: TextStyle(color: Colors.white),
        ),
        backgroundColor: Color.fromRGBO(35, 214, 128, 1),
        actions: (selectable)
            ? [
                IconButton(
                    onPressed: () {
                      setState(() {
                        selectable = false;
                      });
                    },
                    icon: Icon(
                      Icons.close,
                      color: Colors.white,
                    ))
              ]
            : [],
      ),
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
      body: items.isEmpty
          ? Center(
              child: Text(
                'No items available. Add some items!',
                style: TextStyle(fontSize: 18, color: Colors.grey),
              ),
            )
          : Scaffold(
              body: Container(
                color: Color.fromRGBO(235, 235, 235, 1),
                child: ListView.separated(
                  itemCount: items.length,
                  itemBuilder: (context, index) {
                    final item = items[index];
                    return Card(
                      margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                      color: Colors.white,
                      elevation: 5,
                      child: ListTile(
                        onLongPress: _toggleSelectable,
                        leading: (selectable)
                            ? Row(
                                mainAxisSize: MainAxisSize.min,
                                children: [
                                  Checkbox(
                                    value: items[index].selected,
                                    onChanged: (value) =>
                                        _toggleCheckbox(index, value),
                                  ),
                                  ConstrainedBox(
                                    constraints: BoxConstraints(
                                      minWidth: 44,
                                      minHeight: 44,
                                      maxWidth: 44,
                                      maxHeight: 44,
                                    ),
                                    child: item.image == null
                                        ? Container(
                                            color: Colors.grey,
                                          )
                                        : Image.file(
                                            item.image!,
                                            fit: BoxFit.cover,
                                          ),
                                  ),
                                ],
                              )
                            : ConstrainedBox(
                                constraints: BoxConstraints(
                                  minWidth: 44,
                                  minHeight: 44,
                                  maxWidth: 44,
                                  maxHeight: 44,
                                ),
                                child: item.image == null
                                    ? Container(
                                        color: Colors.grey,
                                      )
                                    : Image.file(
                                        item.image!,
                                        fit: BoxFit.cover,
                                      ),
                              ),
                        title: Text(item.name),
                        subtitle: Text(item.description != null
                            ? "${item.description!.substring(0, 15)}..."
                            : ""),
                        trailing: Column(
                          children: [
                            Text(
                              "Price: ${item.price}",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                              ),
                            ),
                            SizedBox(height: 10),
                            Text(
                              "Qty: ${item.quantity}",
                              style: TextStyle(
                                color: Colors.black,
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        onTap: () {
                          Navigator.push(
                            context,
                            MaterialPageRoute(
                                builder: (context) =>
                                    ItemDetailsPage(item: item)),
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
                // if ()
              ),
            ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
