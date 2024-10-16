import 'dart:io';

class InventoryItem {
  final File? image;
  final String name;
  final String description;
  final double price;

  InventoryItem({
    required this.image,
    required this.name,
    required this.description,
    required this.price,
  });
}
