import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:snapinv_mobile/entities/inventoryitem.dart';
import 'package:snapinv_mobile/pages/additem.dart';
import 'package:snapinv_mobile/pages/inventory.dart';
import 'package:snapinv_mobile/pages/itemdetails.dart';

import 'package:http/http.dart' as http;

class CameraPage extends StatefulWidget {
  const CameraPage({super.key});

  @override
  State<CameraPage> createState() => _CameraPageState();
}

class _CameraPageState extends State<CameraPage>
    with AutomaticKeepAliveClientMixin {
  String? scannedResult;
  bool waitNext = false;

Future<void> updateItem(InventoryItem updated) async {
    final url =
        Uri.http('192.168.1.140:8080', '/api/v1/item/update/${updated.id.toString()}', {
      'code': updated.code,
      'description': updated.description,
      'quantity': updated.quantity.toString(),
      'price': updated.price.toString(),
    });
    // final url =
    //     Uri.http('10.0.2.2:8080', '/api/v1/item/update/${updated.id.toString()}', {
    //   'code': updated.code,
    //   'description': updated.description,
    //   'quantity': updated.quantity.toString(),
    //   'price': updated.price.toString(),
    // });
    // final url =
    //     Uri.https('snapinv.com', '/api/v1/item/update/${updated.id.toString()}', {
    //   'code': updated.code,
    //   'description': updated.description,
    //   'quantity': updated.quantity.toString(),
    //   'price': updated.price.toString(),
    // });

    try {
      final response = await http.post(url);
      if (response.statusCode == 200) {
        print(response.body);
      } else {
        print('Error: ${response.statusCode}');
      }
    } catch (e) {
      print('An error occurred: $e');
    }
  }

  void incrementByCode(String code) {
    List<InventoryItem> inventoryItems = InventoryPage.pageKey.currentState!.items;
    for (InventoryItem item in inventoryItems) {
      if (item.code == code) {
        item.quantity += 1;
        updateItem(item);
        break;
      }
    }
  }

  void _onBarcodeDetected(BarcodeCapture barcode) {
    // Handle the first detected barcode to prevent rapid multiple reads
    if (barcode.barcodes.isNotEmpty) {
      if (!waitNext) {
        final String code = barcode.barcodes.first.rawValue ?? "Unknown";
        setState(() {
          scannedResult = code;
        });

        bool contained = InventoryPage.pageKey.currentState!.searchList(code);
        if (contained) {
          showDialog(
              context: context,
              builder: (context) {
                Future.delayed(Duration(seconds: 1), () {
                  Navigator.of(context).pop();
                });
                incrementByCode(code);
                return AlertDialog(title: Text('Added 1 to $code.'));
              });
        } else {
          showDialog(
              context: context,
              builder: (BuildContext context) {
                return AlertDialog(
                  shape: RoundedRectangleBorder(
                    borderRadius: BorderRadius.circular(10),
                  ),
                  title: Text('Not Found'),
                  content: Text(
                    '$code could not be found, would you like to add it?',
                    style: TextStyle(fontSize: 16),
                  ),
                  actions: [
                    TextButton(
                      onPressed: () {
                        print(code);
                        Navigator.of(context).pop();
                        Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AddItemPage(
                                    scanCode: code,
                                  )),
                        );
                      },
                      child: Container(
                        padding: EdgeInsets.only(
                          left: 13,
                          right: 13,
                          top: 8,
                          bottom: 8,
                        ),
                        decoration: BoxDecoration(
                          color: Color.fromRGBO(35, 214, 128, 1),
                          borderRadius: BorderRadius.circular(5),
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

        // Show a snack bar or take further action
        // ScaffoldMessenger.of(context).showSnackBar(
        //   SnackBar(
        //       content: Container(
        //     height: 100,
        //     child: Text(
        //       'Adding 1 to $code quantity.',
        //       style: TextStyle(fontSize: 20),
        //     ),
        //   )),
        // );
        waitNext = true;
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return Scaffold(
      // Dashboard
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      extendBodyBehindAppBar: true,
      backgroundColor: Colors.black,
      body: Stack(
        children: [
          MobileScanner(
            onDetect: _onBarcodeDetected,
            fit: BoxFit.cover,
          ),
          if (scannedResult != null)
            Align(
              alignment: Alignment.bottomCenter,
              child: Container(
                padding: EdgeInsets.all(16),
                // color: Colors.black54,
                child: waitNext
                    ? ElevatedButton(
                        onPressed: () {
                          setState(() {
                            waitNext = false;
                          });
                        },
                        child: Text('Next'),
                      )
                    : null,
              ),
            ),
        ],
      ),
    );
  }

  @override
  bool get wantKeepAlive => true;
}
