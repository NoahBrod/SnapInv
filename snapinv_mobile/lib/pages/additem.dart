import 'dart:io';

import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
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
  File? _imageFile;

  final ImagePicker _picker = ImagePicker();

  Future<void> _pickImageFromCamera() async {
    try {
      final XFile? pickedFile =
          await _picker.pickImage(source: ImageSource.camera);

      if (pickedFile != null) {
        setState(() {
          _imageFile = File(pickedFile.path); // Convert to File
          // Save image to the InventoryItem object
          // _item = InventoryItem(name: 'Example Item', image: _imageFile);
        });
      }
    } catch (e) {
      print('Error picking image: $e');
      // Optionally, show a dialog or snackbar to the user
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
        child: Column(
          children: [
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
            ElevatedButton(
              onPressed: () {
                final String name = _nameController.text;
                final String description = _descriptionController.text;
                final double? price = double.tryParse(_priceController.text);

                if (name.isNotEmpty &&
                    description.isNotEmpty &&
                    price != null) {
                  final newItem = InventoryItem(
                    image: _imageFile,
                    name: name,
                    description: description,
                    price: price,
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
    );
  }
}
