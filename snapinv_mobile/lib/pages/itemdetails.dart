import 'package:flutter/material.dart';
import '../entities/inventoryitem.dart';

import 'package:http/http.dart' as http;

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

  void _toggleEditing() {
    setState(() {
      if (editing) {
        editing = false;
      } else {
        editing = true;
      }
    });
  }

  Future<void> deleteItem(int id) async {
    final url = Uri.http('192.168.4.33:8080', '/api/v1/item/delete', {
      'id': id.toString(),
    });

    try {
      final response = await http.delete(url);
      if (response.statusCode == 200) {
          print(response.body);
      } else {
          print('Error: ${response.statusCode}');
      }
    } catch (e) {
      print('An error occurred: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return PopScope(
      onPopInvokedWithResult: (didPop, result) {
        item.code = null;
      },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: Text(
            item.name,
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Color.fromRGBO(35, 214, 128, 1),
          iconTheme: IconThemeData(color: Colors.white),
          actions: !editing
              ? [
                  TextButton(
                    onPressed: _toggleEditing,
                    child: Text(
                      'Edit',
                      style: TextStyle(color: Colors.white, fontSize: 20),
                    ),
                  ),
                ]
              : [
                  IconButton(
                      onPressed: () {
                        showDialog(
                            context: context,
                            builder: (BuildContext context) {
                              return AlertDialog(
                                title: Text("Confirm Action"),
                                content: Text(
                                  'Are you sure you want to delete this item?',
                                  style: TextStyle(fontSize: 16),
                                ),
                                actions: [
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
                                  TextButton(
                                    onPressed: () {
                                      // send delete to server
                                      deleteItem(item.id!);
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
                                ],
                              );
                            });
                      },
                      icon: Icon(Icons.delete)),
                  IconButton(
                    onPressed: _toggleEditing,
                    icon: Icon(
                      Icons.close,
                      color: Colors.white,
                    ),
                  ),
                ],
        ),
        floatingActionButton: (item.code != null)
            ? null
            : FloatingActionButton(
                onPressed: () {
                  setState(() {
                    item.code = '123456789012';
                  });
                },
                backgroundColor: Color.fromRGBO(35, 214, 128, 1),
                elevation: 5,
                child: Icon(
                  Icons.qr_code_scanner,
                  color: Colors.white,
                ),
              ),
        body: Padding(
          padding: const EdgeInsets.all(16.0),
          child: SingleChildScrollView(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Center(
                  child: item.image == null
                      ? Container(
                          height: 200,
                          color: Colors.grey,
                        )
                      : Image.file(
                          item.image!,
                          width: 300,
                          height: 200,
                          fit: BoxFit.scaleDown,
                        ),
                ),
                SizedBox(height: 20),
                TextField(
                  readOnly: true,
                  focusNode: AlwaysDisabledFocusNode(),
                  decoration: InputDecoration(
                    labelText: 'Code:',
                    labelStyle: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                    ),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black)),
                  ),
                  controller: TextEditingController(text: item.code),
                ),
                SizedBox(height: 20),
                TextField(
                  maxLines: null,
                  readOnly: true,
                  focusNode: AlwaysDisabledFocusNode(),
                  decoration: InputDecoration(
                    labelText: 'Description:',
                    labelStyle: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                    ),
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black)),
                  ),
                  controller: TextEditingController(text: item.description),
                ),
                SizedBox(height: 20),
                Column(
                  children: [
                    Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        Column(
                          children: [
                            Text(
                              'Quantity',
                              style: TextStyle(fontSize: 15),
                            ),
                            Row(
                              children: [
                                IconButton(
                                  icon: Icon(Icons.remove),
                                  onPressed: () {},
                                ),
                                ConstrainedBox(
                                  constraints: BoxConstraints(
                                    minWidth: 60,
                                  ),
                                  child: IntrinsicWidth(
                                    child: TextField(
                                      readOnly: true,
                                      focusNode: AlwaysDisabledFocusNode(),
                                      textAlign: TextAlign.center,
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.symmetric(
                                            horizontal: 10),
                                        focusedBorder: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.black),
                                        ),
                                      ),
                                      controller: TextEditingController(
                                        text: item.quantity.toString(),
                                      ),
                                    ),
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(Icons.add),
                                  onPressed: () {},
                                ),
                              ],
                            ),
                          ],
                        ),
                        Column(
                          children: [
                            ConstrainedBox(
                              constraints: BoxConstraints(
                                  maxWidth:
                                      MediaQuery.of(context).size.width / 2 +
                                          8.3636),
                              child: TextField(
                                readOnly: true,
                                focusNode: AlwaysDisabledFocusNode(),
                                decoration: InputDecoration(
                                  labelText: 'Price:',
                                  labelStyle: TextStyle(
                                    fontSize: 20,
                                    color: Colors.black,
                                  ),
                                  focusedBorder: UnderlineInputBorder(
                                      borderSide:
                                          BorderSide(color: Colors.black)),
                                ),
                                controller: TextEditingController(
                                    text: item.price.toString()),
                              ),
                            ),
                          ],
                        ),
                      ],
                    ),
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}

class AlwaysDisabledFocusNode extends FocusNode {
  @override
  bool get hasFocus => true; // Always returns false

  @override
  void requestFocus([FocusNode? node]) {
    // Do nothing to block focus
  }
}
