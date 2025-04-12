import 'dart:io';

import 'package:barcode_scan2/barcode_scan2.dart';
// import 'package:camera/camera.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:image_picker/image_picker.dart';
import 'package:snapinv_mobile/pages/inventory.dart';

import 'package:http/http.dart' as http;

class AddItemPage extends StatefulWidget {
  final String? scanCode;
  const AddItemPage({super.key, this.scanCode});

  @override
  State<AddItemPage> createState() => _AddItemPageState();
}

class _AddItemPageState extends State<AddItemPage> {
  final TextEditingController _nameController = TextEditingController(text: '');
  final TextEditingController _codeController = TextEditingController();
  final TextEditingController _descriptionController = TextEditingController();
  final TextEditingController _priceController = TextEditingController();
  final TextEditingController _quantityController = TextEditingController(text: '1');

  final List<TextEditingController> _controllers = [];

  File? _imageFile;

  final ImagePicker _picker = ImagePicker();

  int _number = 1;

  @override
  void initState() {
    super.initState();
    print(widget.scanCode);
    _codeController.text = widget.scanCode!;

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

    _controllers.add(_nameController);
    _controllers.add(_codeController);
    _controllers.add(_descriptionController);
    _controllers.add(_priceController);
    _controllers.add(_quantityController);
  }

  @override
  void dispose() {
    for (final controller in _controllers) {
      controller.dispose();
    }
    super.dispose();
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
          await _picker.pickImage(source: ImageSource.camera, imageQuality: 10);

      if (pickedFile != null) {
        setState(() {
          _imageFile = File(pickedFile.path);
          print('IMAGE ADDED.');
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

  Future<void> addItem() async {
    var request = http.MultipartRequest(
        'POST',
        Uri.parse('http://192.168.1.140:8080/api/v1/item/additem'));
        // Uri.parse('http://10.0.2.2:8080/api/v1/item/additem');
        // Uri.parse(
        //   'https://snapinv.com/api/v1/item/additem',
        // ));

    if (_imageFile != null) {
      request.files.add(await http.MultipartFile.fromPath(
        'image',
        _imageFile!.path,
      ));
    }

    request.fields['name'] = _nameController.text;
    if (_codeController.text.isNotEmpty) {
      print('ADDING CODE: ${_codeController.text}');
      request.fields['code'] = _codeController.text;
      print('REQUESTED CODE: ${request.fields['code']}');
    }
    if (_descriptionController.text.isNotEmpty) {
      request.fields['description'] = _descriptionController.text;
    }
    request.fields['quantity'] = _number.toString();
    if (_priceController.text.isNotEmpty) {
      request.fields['price'] = _priceController.text;
    }

    try {
      final response = await request.send();
      if (response.statusCode == 200) {
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

  Future<void> scanBarcode() async {
    try {
      var result = await BarcodeScanner.scan(); // Start barcode scanning
      setState(() {
        _codeController.text = result.rawContent.isNotEmpty
            ? result.rawContent
            : "Failed to scan barcode";
      });
    } catch (e) {
      setState(() {
        _codeController.text = "Error: $e";
      });
    }

    print("Scanned: $_codeController.text");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text(
          'Add New Item',
          style: TextStyle(color: Colors.white),
        ),
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
                      height: 200,
                      fit: BoxFit.cover,
                    )
                  : Container(
                      height: 200,
                      color: Colors.grey,
                    ),
              SizedBox(height: 10),
              Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  ElevatedButton(
                    onPressed: _pickImageFromCamera,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromRGBO(35, 214, 128, 1),
                      minimumSize: Size(150, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(10), // Adjust the radius here
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.photo_camera,
                          color: Colors.white,
                        ),
                        SizedBox(width: 10),
                        Text(
                          'Image',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                  SizedBox(width: 30),
                  ElevatedButton(
                    onPressed: scanBarcode,
                    style: ElevatedButton.styleFrom(
                      backgroundColor: Color.fromRGBO(35, 214, 128, 1),
                      minimumSize: Size(150, 50),
                      shape: RoundedRectangleBorder(
                        borderRadius:
                            BorderRadius.circular(10), // Adjust the radius here
                      ),
                    ),
                    child: Row(
                      children: [
                        Icon(
                          Icons.qr_code_scanner,
                          color: Colors.white,
                        ),
                        SizedBox(width: 10),
                        Text(
                          'Scan',
                          style: TextStyle(color: Colors.white, fontSize: 16),
                        ),
                      ],
                    ),
                  ),
                ],
              ),
              TextField(
                controller: _nameController,
                decoration: InputDecoration(
                  labelText: 'Item Name',
                ),
              ),
              TextField(
                controller: _codeController,
                decoration: InputDecoration(
                  labelText: 'Code',
                  suffixIcon: IconButton(
                    onPressed: scanBarcode,
                    padding: EdgeInsets.only(top: 15),
                    icon: Icon(
                      Icons.qr_code_scanner,
                      size: 20,
                      color: Color.fromRGBO(35, 214, 128, 1),
                    ),
                  ),
                ),
              ),
              SizedBox(height: 10),
              TextField(
                minLines: 1,
                maxLines: 5,
                keyboardType: TextInputType.multiline,
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

                  if (name.isNotEmpty) {
                    Navigator.pop(context);
                    addItem();
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
                style: ElevatedButton.styleFrom(
                  backgroundColor: Color.fromRGBO(35, 214, 128, 1),
                  minimumSize: Size(125, 50),
                  shape: RoundedRectangleBorder(
                    borderRadius:
                        BorderRadius.circular(15), // Adjust the radius here
                  ),
                ),
                child: Text(
                  'Add Item',
                  style: TextStyle(
                    color: Colors.white,
                    fontSize: 16,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
