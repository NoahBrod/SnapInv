import 'dart:io';

class InventoryItem {
  File? image;
  String name;
  String description;
  double price;
  bool selected;
  String code;

  InventoryItem({
    required this.image,
    required this.name,
    required this.description,
    required this.price,
    required this.selected,
    required this.code,
  });
}
