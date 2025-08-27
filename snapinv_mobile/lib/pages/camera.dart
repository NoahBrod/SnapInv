import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';
import 'package:snapinv_mobile/constants/api_config.dart';
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
    with AutomaticKeepAliveClientMixin, WidgetsBindingObserver {
  String? scannedResult;
  bool waitNext = false;
  MobileScannerController controller = MobileScannerController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addObserver(this);
  }

  @override
  void dispose() {
    controller.dispose();
    WidgetsBinding.instance.removeObserver(this);
    super.dispose();
  }

  @override
  void didChangeAppLifecycleState(AppLifecycleState state) {
    if (state == AppLifecycleState.resumed) {
      controller.start(); // Restart camera when app resumes
    } else if (state == AppLifecycleState.paused) {
      controller.stop(); // Stop camera when app is paused
    }
  }

  Future<void> updateItem(InventoryItem updated) async {
    final url =
        Uri.parse('${ApiConfig.baseUrl}/api/v1/item/update/${updated.id}');

    final body = {
      'code': updated.code,
      'description': updated.description,
      'quantity': updated.quantity.toString(),
      'price': updated.price.toString(),
    };

    try {
      final response = await http.post(
        url,
        headers: {'Content-Type': 'application/json'},
        body: jsonEncode(body),
      );
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
    List<InventoryItem> inventoryItems =
        InventoryPage.pageKey.currentState!.items;
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
    if (barcode.barcodes.isNotEmpty && !waitNext) {
      try {
        final String code = barcode.barcodes.first.rawValue ?? "Unknown";
        setState(() {
          scannedResult = code;
          waitNext = true;
        });

        bool contained = InventoryPage.pageKey.currentState!.searchList(code);
        if (contained) {
          incrementByCode(code);
          ScaffoldMessenger.of(context).showSnackBar(
            SnackBar(
              content: Text('Added 1 to $code'),
              duration: Duration(seconds: 2),
            ),
          );
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
                      onPressed: () async {
                        print(code);
                        Navigator.of(context).pop();
                        await Navigator.push(
                          context,
                          MaterialPageRoute(
                              builder: (context) => AddItemPage(
                                    scanCode: code,
                                  )),
                        );
                        setState(() => waitNext = false);
                      },
                      child: Container(
                        padding: EdgeInsets.only(
                          left: 13,
                          right: 13,
                          top: 8,
                          bottom: 8,
                        ),
                        decoration: BoxDecoration(
                          color: AppColors.primary,
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
                        setState(() => waitNext = false);
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
      } catch (e) {
        print('Error processing barcode: $e');
        setState(() => waitNext = false);
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
            controller: controller,
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
