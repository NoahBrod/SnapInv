import 'dart:ffi';
import 'dart:io';

import 'package:snapinv_mobile/entities/descriptor.dart';

class InventoryItem {
  File? image;
  Long? id;
  String name;
  String description;
  int quantity;
  List<Descriptor> descriptors;
  // double? acqPrice;
  // double? salePrice;
  // bool selected;
  // String code;

  InventoryItem({
    required this.image,
    required this.name,
    required this.description,
    required this.quantity,
    required this.acqPrice,
    required this.salePrice,
    required this.selected,
    required this.code,
  });
}
