import 'package:flutter/material.dart';
import 'package:mobile_scanner/mobile_scanner.dart';

class ScannerPage extends StatefulWidget {
  const ScannerPage({super.key});

  @override
  State<ScannerPage> createState() => _ScannerPageState();
}

class _ScannerPageState extends State<ScannerPage> {
  bool hasScanned = false;

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: AppBar(
        title: Text('Scan Barcode'),
        backgroundColor: Color.fromRGBO(35, 214, 128, 1),
        foregroundColor: Colors.white,
      ),
      body: MobileScanner(
        onDetect: (BarcodeCapture capture) {
          if (!hasScanned && capture.barcodes.isNotEmpty) {
            hasScanned = true;
            final barcode = capture.barcodes.first;
            Navigator.pop(context, barcode.rawValue ?? '');
          }
        },
      ),
    );
  }
}