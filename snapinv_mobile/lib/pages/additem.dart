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
                  : Text('data'),
              ElevatedButton(
                  onPressed: _pickImageFromCamera,
                  child: Text('Please take an image')),
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
              TextField(
                controller: _priceController,
                decoration: InputDecoration(labelText: 'Item Price'),
                keyboardType: TextInputType.number,
              ),
              SizedBox(height: 20),
              TextField(
                controller: _quantityController,
                decoration: InputDecoration(labelText: 'Item Quantity'),
                keyboardType: TextInputType.number,
                inputFormatters: [
                  FilteringTextInputFormatter.digitsOnly,
                ],
              ),
              SizedBox(height: 20),
              ElevatedButton(
                onPressed: () {
                  final String name = _nameController.text;
                  final String description = _descriptionController.text;
                  final double? price = double.tryParse(_priceController.text);
                  final int? quantity = int.tryParse(_quantityController.text);

                  if (name.isNotEmpty && price != null) {
                    final newItem = InventoryItem(
                      image: _imageFile,
                      name: name,
                      description: description,
                      quantity: (quantity  != null) ? quantity : null,
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
