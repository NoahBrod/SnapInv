import 'dart:io';

class InventoryItem {
  File? image;
  String name;
  String description;
  int quantity;
  double? acqPrice;
  double? salePrice;
  bool selected;
  String code;

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
