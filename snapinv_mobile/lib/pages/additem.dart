import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:snapinv_mobile/pages/inventory.dart';
import '../entities/inventoryitem.dart';

import 'package:http/http.dart' as http;

class AddItemPage extends StatefulWidget {
  const AddItemPage({super.key});

  @override
  State<AddItemPage> createState() => _AddItemPageState();
}

class _AddItemPageState extends State<AddItemPage> {
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController();
  File? _imageFile;

  final ImagePicker _picker = ImagePicker();

  int _number = 0;

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
  }

  void _increment() {
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

  Future<void> _pickImageFromCamera() async {
    try {
      final XFile? pickedFile =
          await _picker.pickImage(source: ImageSource.camera);

      if (pickedFile != null) {
        setState(() {
          _imageFile = File(pickedFile.path);
          print('IMAGE ADDED.');
          // Save image to the InventoryItem object
          // _item = InventoryItem(name: 'Example Item', image: _imageFile);
        });
      } else {
        print('No image selected.');
      }
    } catch (e) {
      print('Error picking image: $e');
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Failed to pick image: $e')),
      );
    }
  }

  Future<void> addItem(
      String name, String description, int quantity, double? price) async {
    final url = Uri.http('192.168.4.33:8080', '/api/v1/item/additem', {
      'name': name,
      if (description != "") 'description': description,
      'quantity': quantity.toString(),
      if (price != null) 'price': price.toString()
    });

    try {
      final response = await http.post(url);
      if (response.statusCode == 200) {
        setState(() {
          print(response.body);
        });
        InventoryPage.pageKey.currentState?.getInventory();
      } else {
        setState(() {
          print('Error: ${response.statusCode}');
        });
      }
    } catch (e) {
      print('An error occurred: $e');
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Item', style: TextStyle(color: Colors.white),),
        backgroundColor: Color.fromRGBO(35, 214, 128, 1),
        foregroundColor: Colors.white,
      ),
      body: Padding(
        padding: const EdgeInsets.all(16.0),
        child: SingleChildScrollView(
          child: Column(
            children: [
              _imageFile != null
                  ? Image.file(
                      _imageFile!,
                      width: 300,
                      height: 300,
                      fit: BoxFit.cover,
                    )
                  : Container(
                      width: 300,
                      height: 300,
                      color: Colors.grey,
                    ),
              SizedBox(height: 10),
              ElevatedButton(
                onPressed: _pickImageFromCamera,
                child: Text('Please take an image'),
              ),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(labelText: 'Item Name'),
              ),
              SizedBox(height: 10),
              TextField(
                controller: _descriptionController,
                decoration: InputDecoration(labelText: 'Item Description'),
              ),
              SizedBox(height: 10),
              SizedBox(height: 20),
              Row(
                children: [
                  Column(
                    children: [
                      Text('Quantity'),
                      Row(
                        children: [
                          ConstrainedBox(
                            constraints: BoxConstraints(minWidth: 60),
                            child: IntrinsicWidth(
                              child: TextField(
                                textAlign: TextAlign.center,
                                controller: _quantityController,
                                keyboardType: TextInputType.number,
                                inputFormatters: <TextInputFormatter>[
                                  FilteringTextInputFormatter.digitsOnly,
                                ],
                                decoration: InputDecoration(
                                  border: OutlineInputBorder(),
                                  contentPadding:
                                      EdgeInsets.symmetric(horizontal: 10),
                                  hintText: '0',
                                ),
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
                            maxWidth: MediaQuery.of(context).size.width / 2),
                        child: TextField(
                          controller: _priceController,
                          decoration: InputDecoration(
                              labelText: 'Item Price',
                              floatingLabelAlignment:
                                  FloatingLabelAlignment.center),
                          keyboardType: TextInputType.number,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
              SizedBox(height: 20),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  final String name = _nameController.text;
                  final String description = _descriptionController.text;
                  final double? price = _priceController.text.isNotEmpty
                      ? double.tryParse(double.tryParse(_priceController.text)!
                          .toStringAsFixed(2))
                      : double.tryParse(_priceController.text);
                  final int quantity = _number;

                  if (name.isNotEmpty) {
                    final newItem = InventoryItem(
                      id: null,
                      image: _imageFile,
                      name: name,
                      description: description,
                      quantity: quantity,
                      price: price,
                      code: '',
                    );

                    Navigator.pop(context);
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(SnackBar(
                      content: Text('Please fill out all fields correctly.'),
                      padding: EdgeInsets.all(20),
                      margin: EdgeInsets.only(bottom: 10, left: 10, right: 10),
                      behavior: SnackBarBehavior.floating,
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(20), // Apply border radius
                      ),
                    ));
                  }

                  addItem(name, description, quantity, price);
                },
                child: Text('Add Item'),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
