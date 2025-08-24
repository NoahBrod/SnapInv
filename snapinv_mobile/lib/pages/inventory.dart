import 'dart:convert';
import 'dart:io';

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
import 'package:snapinv_mobile/constants/api_config.dart';
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
  List<int> selectedIDs = [];
  bool selectable = false;
  bool isLoading = false;

  @override
  void initState() {
    super.initState();
    getInventory();
  }

  void _toggleCheckbox(int index, bool? value) {
    setState(() {
      if (selectedIDs.contains(items[index].id)) {
        selectedIDs.remove(items[index].id);
      } else {
        selectedIDs.add(items[index].id!);
      }
      print(selectedIDs);
    });
  }

  void _toggleSelectable(int index) {
    setState(() {
      selectedIDs.add(items[index].id!);
      selectable = true;
    });
  }

  void addItem(InventoryItem newItem) {
    setState(() {
      items.add(newItem);
    });
  }

  bool searchList(String code) {
    for (InventoryItem item in items) {
      if (item.code == code) {
        return true;
      }
    }
    return false;
  }

  Future<void> getInventory() async {
    List<InventoryItem> localItems = await getInventoryList();

    final url = Uri.parse('${ApiConfig.baseUrl}/api/v1/item/items');

    setState(() => isLoading = true);

    try {
      final response = await http.get(url);
      if (response.statusCode != 200) {
        throw Exception('Error: ${response.statusCode}');
      }

      List<dynamic> jsonList = jsonDecode(response.body);
      List<InventoryItem> dbItems =
          jsonList.map((json) => InventoryItem.fromJson(json)).toList();

      setState(() {
        items = dbItems; // Simply replace the entire list
      });

      saveList(items);
    } catch (e) {
      print('An error occurred: $e');
      setState(() {
        items = localItems;
      });
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Using offline data - check your connection'),
          backgroundColor: Colors.orange,
        ),
      );
    }
    setState(() => isLoading = false);
  }

  // save list to local storage
  Future<void> saveList(List<InventoryItem> saveList) async {
    final prefs = await SharedPreferences.getInstance();
    String jsonString =
        jsonEncode(saveList.map((item) => item.toJson()).toList());
    await prefs.setString('itemList', jsonString);
  }

  // retrieve list from local storage
  Future<List<InventoryItem>> getInventoryList() async {
    final prefs = await SharedPreferences.getInstance();
    String? jsonString = prefs.getString('itemList');
    if (jsonString == null) {
      return [];
    }
    List<dynamic> jsonList = jsonDecode(jsonString);
    return jsonList
        .map((json) => InventoryItem.fromJson(json as Map<String, dynamic>))
        .toList();
  }

  Future<void> deleteItems(BuildContext context) async {
    final url = Uri.parse('${ApiConfig.baseUrl}/api/v1/item/delete/selected');
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode(selectedIDs);

    setState(() {
      items.removeWhere((item) => selectedIDs.contains(item.id));
      selectable = false;
    });

    selectedIDs.clear();

    try {
      final response = await http.delete(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        print('SUCCESS: Items deleted');
        await saveList(items);
      } else {
        print('Error: ${response.statusCode}');
        // If API fails, refresh from server to get correct state
        await getInventory();
      }
    } catch (e) {
      print('An error occurred: $e');
      // If API fails, refresh from server to get correct state
      await getInventory();
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
                    if (selectedIDs.isNotEmpty) {
                      showDialog(
                          context: context,
                          builder: (BuildContext context) {
                            return AlertDialog(
                              title: Text("Confirm Action"),
                              content: Text(
                                'These items will be deleted.',
                                style: TextStyle(fontSize: 16),
                              ),
                              actions: [
                                TextButton(
                                  onPressed: () {
                                    deleteItems(context);
                                    Navigator.of(context).pop();
                                  },
                                  child: Container(
                                    padding: EdgeInsets.only(
                                      left: 13,
                                      right: 13,
                                      top: 8,
                                      bottom: 8,
                                    ),
                                    decoration: BoxDecoration(
                                      color: Colors.redAccent[400],
                                      borderRadius: BorderRadius.circular(10),
                                    ),
                                    child: Text(
                                      'Yes',
                                      style: TextStyle(
                                        color: Colors.white,
                                        fontSize: 18,
                                      ),
                                    ),
                                  ),
                                ),
                                TextButton(
                                  onPressed: () {
                                    Navigator.of(context).pop();
                                  },
                                  child: Text(
                                    'No',
                                    style: TextStyle(
                                      color: Colors.black,
                                      fontSize: 18,
                                    ),
                                  ),
                                ),
                              ],
                            );
                          });
                    }
                  },
                  icon: Icon(Icons.delete),
                  color: Colors.white,
                ),
                IconButton(
                    onPressed: () {
                      setState(() {
                        selectable = false;
                        selectedIDs.clear();
                      });
                    },
                    icon: Icon(
                      Icons.close,
                      color: Colors.white,
                    )),
              ]
            : [],
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () async {
          final newItem = await Navigator.push(
            context,
            MaterialPageRoute(
                builder: (context) => AddItemPage(
                      scanCode: '',
                    )),
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
      body: isLoading
          ? Center(child: CircularProgressIndicator())
          : items.isEmpty
              ? Center(child: Text('No items available. Add some items!'))
              : Container(
                  color: AppColors.invBackground,
                  child: ListView.separated(
                    itemCount: items.length,
                    itemBuilder: (context, index) {
                      final item = items[index];
                      return Card(
                        margin:
                            EdgeInsets.symmetric(horizontal: 8, vertical: 4),
                        color: Colors.white,
                        elevation: 5,
                        child: ListTile(
                          onLongPress: () => _toggleSelectable(index),
                          leading: (selectable)
                              ? Row(
                                  mainAxisSize: MainAxisSize.min,
                                  children: [
                                    Checkbox(
                                      value: selectedIDs.contains(item.id),
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
                                          : Image.memory(
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
                                      : Image.memory(
                                          item.image!,
                                          fit: BoxFit.cover,
                                        ),
                                ),
                          title: Text(item.name),
                          subtitle: Text(item.code != null
                              ? item.code!.length <= 15
                                  ? item.code!
                                  : "${item.code!.substring(0, 15)}..."
                              : ""),
                          trailing: Column(
                            children: [
                              Text(
                                "Price: \$${item.price?.toStringAsFixed(2) ?? '0.00'}",
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
                        height: 5,
                      );
                    },
                    padding: EdgeInsets.all(5),
                  ),
                  // if ()
                ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
