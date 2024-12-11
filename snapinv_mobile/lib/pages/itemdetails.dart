import 'package:barcode_scan2/barcode_scan2.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:snapinv_mobile/pages/inventory.dart';
import '../entities/inventoryitem.dart';

import 'package:http/http.dart' as http;

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

  bool editing = true; // true is not and false is

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
    _priceController.text = item.price!.toStringAsFixed(2);

    _controllers = [
      _nameController,
      _codeController,
      _descriptionController,
      _priceController,
      _quantityController
    ];

    _focusNodes = [_codeNode, _descriptionNode, _quantityNode, _priceNode];

    for (var focusNode in _focusNodes) {
      focusNode.addListener(_handleFocusChange);
    }
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
        InventoryItem compare = InventoryItem(
          id: item.id,
          image: item.image,
          name: item.name,
          description: _descriptionController.text == ''
              ? null
              : _descriptionController.text,
          quantity: int.parse(_quantityController.text),
          price: double.parse(_priceController.text),
          code: _codeController.text == '' ? null : _codeController.text,
        );

        if (compare != item) {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  title: Text("Confirm Action"),
                  content: Text(
                    'Would you like to save your changes?',
                    style: TextStyle(fontSize: 16),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        setState(() {
                          editing = true;
                        });
                        updateItem(compare);
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
                        setState(() {
                          editing = true;
                        });
                        revertFields();
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
        } else {
          editing = true;
        }
      }
    });
  }

  void revertFields() {
    _codeController.text = (item.code ?? '');
    _descriptionController.text = (item.description ?? '');
    _quantityController.text = item.quantity.toString();
    _priceController.text = item.price.toString();
  }

  void _handleFocusChange() {
    setState(() {
      for (var focusNode in _focusNodes) {
        if (focusNode.hasFocus) {
          // Unfocus other fields when one is focused
          for (var otherFocusNode in _focusNodes) {
            if (otherFocusNode != focusNode) {
              otherFocusNode.unfocus();
            }
          }
          break;
        }
      }
    });
  }

  void _increment() {
    editing = false;

    final text = _quantityController.text;
    setState(() {
      if (text.isNotEmpty) {
        _number = int.tryParse(text)! + 1;
        _quantityController.text = _number.toString();
      } else {
        _number++;
        _quantityController.text = _number.toString();
      }
    });
  }

  void _decrement() {
    editing = false;

    final text = _quantityController.text;
    setState(() {
      if (text.isNotEmpty && _number > 0) {
        _number = int.tryParse(text)! - 1;
        _quantityController.text = _number.toString();
      } else {
        _quantityController.text = _number.toString();
      }
    });
  }

  Future<void> deleteItem(int id, BuildContext context) async {
    final url = Uri.parse('http://10.0.2.2:8080/api/v1/item/delete/$id');

    try {
      final response = await http.delete(url);
      if (response.statusCode == 200) {
        print(response.body);
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

  Future<void> updateItem(InventoryItem updated) async {
    final url =
        Uri.http('10.0.2.2:8080', '/api/v1/item/update/${item.id.toString()}', {
      'code': updated.code,
      'description': updated.description,
      'quantity': updated.quantity.toString(),
      'price': updated.price.toString(),
    });

    try {
      final response = await http.post(url);
      if (response.statusCode == 200) {
        print(response.body);
        item.code = updated.code;
        item.description = updated.description;
        item.quantity = updated.quantity;
        item.price = updated.price;
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      print('An error occurred: $e');
    }
  }

  Future<void> scanBarcode() async {
    try {
      var result = await BarcodeScanner.scan(); // Start barcode scanning
      setState(() {
        _codeController.text =
            result.rawContent.isNotEmpty ? result.rawContent : "";
      });
    } catch (e) {
      setState(() {
        _codeController.text = "Error: $e";
      });
    }

    print("Scanned: $_codeController.text");
  }

  Future<bool> _confirmExitPage(BuildContext context) async {
    final result = await showDialog(
        context: context,
        builder: (BuildContext context) {
          return AlertDialog(
            title: Text("Confirm Action"),
            content: Text(
              'Would you like to save your changes?',
              style: TextStyle(fontSize: 16),
            ),
            actions: [
              TextButton(
                onPressed: () => Navigator.of(context).pop(true),
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
                onPressed: () => Navigator.of(context).pop(false),
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
    return result ?? false;
  }

  @override
  Widget build(BuildContext mainContext) {
    return PopScope(
      canPop: false,
      onPopInvokedWithResult: (didPop, result) async {
        if (didPop) {
          return;
        }
        InventoryItem compare = InventoryItem(
          id: item.id,
          image: item.image,
          name: item.name,
          description: _descriptionController.text == ''
              ? null
              : _descriptionController.text,
          quantity: int.parse(_quantityController.text),
          price: double.parse(_priceController.text),
          code: _codeController.text == '' ? null : _codeController.text,
        );
        // print("ITEM: ${item.id}       COMPARE: ${compare.id}");
        // print("ITEM: ${item.image}       COMPARE: ${compare.image}");
        // print("ITEM: ${item.name}       COMPARE: ${compare.name}");
        // print("ITEM: ${item.code}       COMPARE: ${compare.code}");
        // print("ITEM: ${item.description}       COMPARE: ${compare.description}");
        // print("ITEM: ${item.quantity}       COMPARE: ${compare.quantity}");
        // print("ITEM: ${item.price}       COMPARE: ${compare.price}");
        // print(compare == item);
        if (compare != item) {
          final confirmed = await _confirmExitPage(mainContext);
          if (mainContext.mounted && confirmed) {
            await updateItem(compare);
            InventoryPage.pageKey.currentState?.getInventory();
            Navigator.of(mainContext).pop();
          } else {
            Navigator.of(mainContext).pop();
          }
        } else {
          InventoryPage.pageKey.currentState?.getInventory();
          Navigator.of(mainContext).pop();
        }
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
                      InventoryItem compare = InventoryItem(
                        id: item.id,
                        image: item.image,
                        name: item.name,
                        description: _descriptionController.text == ''
                            ? null
                            : _descriptionController.text,
                        quantity: int.parse(_quantityController.text),
                        price: double.parse(_priceController.text),
                        code: _codeController.text == ''
                            ? null
                            : _codeController.text,
                      );
                      if (compare != item) {
                        updateItem(compare);
                      }
                      setState(() {
                        editing = true;
                      });
                    },
                    icon: Icon(
                      Icons.check,
                      color: Colors.white,
                    ),
                  ),
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
        floatingActionButton: !editing
            ? null
            : (item.code != '')
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
                  // focusNode: _codeNode,
                  decoration: InputDecoration(
                    labelText: 'Code:',
                    labelStyle: TextStyle(
                      // fontSize: 20,f
                      color: Colors.black,
                    ),
                    suffixIcon: editing
                        ? null
                        : IconButton(
                            onPressed: scanBarcode,
                            padding: EdgeInsets.only(top: 15),
                            icon: Icon(
                              Icons.qr_code_scanner,
                              size: 20,
                              color: Color.fromRGBO(35, 214, 128, 1),
                            ),
                          ),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
                    focusedBorder: UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.black)),
                  ),
                  controller: _codeController,
                ),
                SizedBox(height: 20),
                TextField(
                  maxLines: null,
                  readOnly: editing,
                  focusNode: _descriptionNode,
                  decoration: InputDecoration(
                    labelText: 'Description:',
                    labelStyle: TextStyle(
                      fontSize: 20,
                      color: Colors.black,
                    ),
                    floatingLabelBehavior: FloatingLabelBehavior.always,
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
                                  onPressed: _decrement,
                                ),
                                ConstrainedBox(
                                  constraints: BoxConstraints(
                                    minWidth: 60,
                                  ),
                                  child: IntrinsicWidth(
                                    child: TextField(
                                      readOnly: editing,
                                      focusNode: _quantityNode,
                                      textAlign: TextAlign.center,
                                      decoration: InputDecoration(
                                        contentPadding: EdgeInsets.symmetric(
                                            horizontal: 10),
                                        floatingLabelBehavior:
                                            FloatingLabelBehavior.always,
                                        focusedBorder: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.black),
                                        ),
                                        border: OutlineInputBorder(
                                          borderSide:
                                              BorderSide(color: Colors.black),
                                        ),
                                      ),
                                      keyboardType: TextInputType.number,
                                      inputFormatters: <TextInputFormatter>[
                                        FilteringTextInputFormatter.digitsOnly,
                                      ],
                                      controller: _quantityController,
                                    ),
                                  ),
                                ),
                                IconButton(
                                  icon: Icon(Icons.add),
                                  onPressed: _increment,
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
                                focusNode: _priceNode,
                                decoration: InputDecoration(
                                  prefix: Text('\$'),
                                  labelText: 'Price:',
                                  labelStyle: TextStyle(
                                    fontSize: 20,
                                    color: Colors.black,
                                  ),
                                  floatingLabelBehavior:
                                      FloatingLabelBehavior.always,
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
                SizedBox(height: 50),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: editing
                      ? []
                      : [
                          ElevatedButton(
                            onPressed: () {
                              InventoryItem compare = InventoryItem(
                                id: item.id,
                                image: item.image,
                                name: item.name,
                                description: _descriptionController.text == ''
                                    ? null
                                    : _descriptionController.text,
                                quantity: int.parse(_quantityController.text),
                                price: double.parse(_priceController.text),
                                code: _codeController.text == ''
                                    ? null
                                    : _codeController.text,
                              );
                              if (compare != item) {
                                updateItem(compare);
                              }
                              setState(() {
                                editing = true;
                              });
                            },
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Color.fromRGBO(35, 214, 128, 1),
                              minimumSize: Size(100, 50),
                            ),
                            child: Text(
                              'Save',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
                          ),
                          SizedBox(width: 40),
                          ElevatedButton(
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
                                              borderRadius:
                                                  BorderRadius.circular(10),
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
                            style: ElevatedButton.styleFrom(
                              backgroundColor: Colors.redAccent[400],
                              minimumSize: Size(100, 50),
                            ),
                            child: Text(
                              'Delete',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 16,
                              ),
                            ),
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
