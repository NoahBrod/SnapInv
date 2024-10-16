import 'package:flutter/material.dart';
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
                // Validate the input and create a new InventoryItem
                final String name = _nameController.text;
                final String description = _descriptionController.text;
                final double? price = double.tryParse(_priceController.text);

                if (name.isNotEmpty && description.isNotEmpty && price != null) {
                  final newItem = InventoryItem(
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
                      borderRadius: BorderRadius.circular(20),  // Apply border radius
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
