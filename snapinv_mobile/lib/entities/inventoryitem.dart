import 'dart:ffi';
import 'dart:io';

// import 'package:snapinv_mobile/entities/descriptor.dart';

class InventoryItem {
  int? id;
  File? image;
  String name;
  String? code;
  String? description;
  int quantity;
  double? price;
  bool selected = false;

  InventoryItem({
    required this.id,
    required this.image,
    required this.name,
    required this.description,
    required this.quantity,
    required this.price,
    required this.code,
  });

  factory InventoryItem.fromJson(Map<String, dynamic> json) {
    return InventoryItem(
      id: json['id'] as int,
      image: null,
      name: json['name'] as String,
      code: json['code'] != null ? json['code'] as String : null,
      description:
          json['description'] != null ? json['description'] as String : null,
      quantity: json['quantity'] as int,
      price: (json['price'] as num).toDouble(),
    );
  }

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InventoryItem &&
          runtimeType == other.runtimeType &&
          image == other.image &&
          name == other.name &&
          description == other.description &&
          quantity == other.quantity &&
          price == other.price &&
          code == other.code;
  @override
  int get hashCode =>
      image.hashCode ^
      name.hashCode ^
      description.hashCode ^
      quantity.hashCode ^
      price.hashCode ^
      code.hashCode;
}
