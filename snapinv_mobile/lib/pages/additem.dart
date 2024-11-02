import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import '../entities/inventoryitem.dart';

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

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Add New Item'),
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
                          IconButton(
                            icon: Icon(Icons.remove),
                            onPressed: _decrement,
                          ),
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
                  final double? price = double.tryParse(_priceController.text);
                  final int quantity = _number;

                  if (name.isNotEmpty) {
                    final newItem = InventoryItem(
                      image: _imageFile,
                      name: name,
                      description: description,
                      quantity: quantity,
                      price: price,
                      selected: false,
                      code: '',
                    );

                    Navigator.pop(context, newItem);
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
