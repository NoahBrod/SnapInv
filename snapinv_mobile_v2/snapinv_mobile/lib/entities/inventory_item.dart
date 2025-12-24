class InventoryItem {
  int? id;
  String name;
  String? code;
  String? description;
  int quantity;
  double? price;

  InventoryItem({
    required this.id,
    required this.name,
    required this.description,
    required this.quantity,
    required this.price,
    required this.code,
  });

  @override
  bool operator ==(Object other) =>
      identical(this, other) ||
      other is InventoryItem &&
          runtimeType == other.runtimeType &&
          name == other.name &&
          description == other.description &&
          quantity == other.quantity &&
          price == other.price &&
          code == other.code;
}