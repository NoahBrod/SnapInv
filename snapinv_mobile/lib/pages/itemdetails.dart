import 'package:flutter/material.dart';
import 'package:snapinv_mobile/pages/inventory.dart';
import '../entities/inventoryitem.dart';

import 'package:http/http.dart' as http;

bool editing = true; // true is not and false is

class ItemDetailsPage extends StatefulWidget {
  final InventoryItem item;
  const ItemDetailsPage({required this.item});

  @override
  State<ItemDetailsPage> createState() => _ItemDetailsPageState(item: item);
}

class _ItemDetailsPageState extends State<ItemDetailsPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();

  final FocusNode _codeNode = FocusNode();
  final FocusNode _descriptionNode = FocusNode();
  final FocusNode _quantityNode = FocusNode();
  final FocusNode _priceNode = FocusNode();

  late List<TextEditingController> _controllers;
  late List<FocusNode> _focusNodes;

  int _number = 0;

  // bool editing = false;

  final InventoryItem item;

  _ItemDetailsPageState({required this.item});

  @override
  void initState() {
    super.initState();
    _quantityController.addListener(() {
      final text = _quantityController.text;
      setState(() {
        if (text.isNotEmpty) {
          _number = int.tryParse(text)!;
        } else {
          _number = 0;
        }
      });
    });

    _nameController.text = item.name;
    _codeController.text = (item.code ?? '');
    _descriptionController.text = (item.description ?? '');
    _quantityController.text = item.quantity.toString();
    _priceController.text = item.price.toString();

    _controllers = [
      _nameController,
      _codeController,
      _descriptionController,
      _priceController,
      _quantityController
    ];

    _focusNodes = [
      _codeNode,
      _descriptionNode,
      _quantityNode,
      _priceNode
    ];
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
  }

  void _toggleEditing() {
    setState(() {
      if (editing) {
        editing = false;
      } else {
        editing = true;
      }
      print(editing);
    });
  }

  Future<void> deleteItem(int id, BuildContext context) async {
    final url = Uri.http('10.0.2.2:8080', '/api/v1/item/delete', {
      'id': id.toString(),
    });

    try {
      final response = await http.delete(url);
      if (response.statusCode == 200) {
        // print(response.body);
        if (context.mounted) {
          Navigator.pop(context);
          InventoryPage.pageKey.currentState?.getInventory();
        }
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      print('An error occurred: $e');
    }
  }

  @override
  Widget build(BuildContext mainContext) {
    return PopScope(
      // onPopInvokedWithResult: (didPop, result) {
      //   item.code = null;
      // },
      child: Scaffold(
        resizeToAvoidBottomInset: true,
        appBar: AppBar(
          title: Text(
            item.name,
            style: TextStyle(color: Colors.white),
          ),
          backgroundColor: Color.fromRGBO(35, 214, 128, 1),
          iconTheme: IconThemeData(color: Colors.white),
          actions: editing
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
                                      deleteItem(item.id!, mainContext);
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
        floatingActionButton: (item.code != '')
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
                      : Image.memory(
                          item.image!,
                          width: 300,
                          height: 200,
                          fit: BoxFit.scaleDown,
                        ),
                ),
                SizedBox(height: 20),
                TextField(
                  readOnly: editing,
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
                  controller: _codeController,
                ),
                SizedBox(height: 20),
                TextField(
                  maxLines: null,
                  readOnly: editing,
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
                  controller: _descriptionController,
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
                                      readOnly: editing,
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
                                      controller: _quantityController,
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
                                      MediaQuery.of(mainContext).size.width /
                                              2 +
                                          8.3636),
                              child: TextField(
                                readOnly: editing,
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
                                controller: _priceController,
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
