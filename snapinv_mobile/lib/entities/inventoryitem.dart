import 'dart:ffi';
import 'dart:io';

// import 'package:snapinv_mobile/entities/descriptor.dart';

class InventoryItem {
  Long? id;
  File? image;
  String name;
  String code;
  String description;
  int quantity;
  double? price;
  bool selected;

  InventoryItem({
    required this.image,
    required this.name,
    required this.description,
    required this.quantity,
    required this.price,
    required this.selected,
    required this.code,
  });
}
