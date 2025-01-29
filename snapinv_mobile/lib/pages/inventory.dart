import 'dart:convert';
import 'dart:io';

import 'package:collection/collection.dart';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:shared_preferences/shared_preferences.dart';
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

  bool validateEqualIds(List<InventoryItem> retrieved) {
    bool valid = false;
    int i = 0;

    for (var item in retrieved) {
      if (item == items[i]) {
        valid = true;
      } else {
        return false;
      }
    }

    return false;
  }

  Future<void> getInventory() async {
    List<InventoryItem> localItems = await getInventoryList();
    bool areEqual = const ListEquality().equals(localItems, items);
    // print('Are list1 and list2 equal? $areEqual');
    if (!areEqual) {
      print('SETTING ITEMS TO LOCAL ITEMS');
      setState(() {
        items = localItems;
      });
    }
    selectable = false;
    // final url = Uri.parse('http://10.0.2.2:8080/api/v1/item/items');
    final url = Uri.parse('https://snapinv.com/api/v1/item/items');

    try {
      final response = await http.get(url);
      if (response.statusCode == 200) {
        print('Retrieved Inventory');
      } else {
        print('Error: ${response.statusCode}');
      }

      List<dynamic> jsonList = jsonDecode(response.body);
      List<InventoryItem> itemList =
          jsonList.map((json) => InventoryItem.fromJson(json)).toList();

      Map<int?, InventoryItem> itemMap = {for (var item in items) item.id : item};

      // for (var newItem in itemList) {
      //   if (itemMap.containsKey(newItem.id)) {
      //     itemMap[newItem.id] = newItem;
      //   } else {
      //     items.add(newItem);
      //   }
      // }
 
      // items.removeWhere((item) => !itemList.any((newItem) => newItem.id == item.id));
      int i = 0;
      for (var item in items) {
        print('[${item.id}, ${item.name}] : [${itemList[i].id}, ${itemList[i].name}]');
        i++;
      }

      // process local items to database items
      if (items.length != itemList.length) {
        if (items.length < itemList.length) {
          for (int i = 0; i < itemList.length; i++) {
            bool match = false;
            for (int j = 0; j < items.length; j++) {
              if (items[j] != itemList[i]) {
                if (items[j].id == itemList[i].id) {
                  setState(() {
                    items[j] = itemList[i];
                  });
                  match = true;
                  break;
                }
              } else {
                match = true;
                break;
              }
            }
            if (!match) {
              setState(() {
                items.add(itemList[i]);
              });
            }
          }
        } else if (items.length > itemList.length) {
          for (int i = 0; i < items.length; i++) {
            bool match = false;
            for (int j = 0; j < itemList.length; j++) {
              if (items[i] != itemList[j]) {
                if (items[i].id == itemList[j].id) {
                  setState(() {
                    items[i] = itemList[j];
                  });
                  match = true;
                  break;
                }
              } else {
                match = true;
                break;
              }
            }
            if (!match) {
              print(items[i].name);
              setState(() {
                items.remove(items[i]);
              });
            }
          }
        }
      } else {
        for (int i = 0; i < items.length; i++) {
          for (int j = 0; j < itemList.length; j++) {
            if (items[i] != itemList[j]) {
              if (items[i].id == itemList[j].id) {
                setState(() {
                  items[i] = itemList[j];
                });
                break;
              }
            }
          }
        }
      }
    } catch (e) {
      print('An error occurred: $e');
    }

    saveList(items);
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
    // final url = Uri.parse('http://10.0.2.2:8080/api/v1/item/delete/selected');
    final url = Uri.parse('https://snapinv.com/api/v1/item/delete/selected');
    final headers = {'Content-Type': 'application/json'};
    final body = jsonEncode(selectedIDs);
    selectedIDs = [];

    print(body);

    try {
      final response = await http.delete(url, headers: headers, body: body);
      if (response.statusCode == 200) {
        print(response.body);
        if (context.mounted) {
          setState(() {
            selectable = false;
          });
          sleep(Duration(seconds: 2));
          getInventory();
        }
        sleep(Duration(seconds: 2));
        getInventory();
      } else {
        print('Error: ${response.statusCode}');
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
                                    selectable = false;
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
                              "Price: ${item.price!.toStringAsFixed(2)}",
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
            ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
