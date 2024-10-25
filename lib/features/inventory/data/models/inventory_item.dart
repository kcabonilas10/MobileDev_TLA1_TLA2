// lib/features/inventory/data/models/inventory_item.dart

class InventoryItem {
  final String id;
  final String name;
  final int quantity;
  final double price;
  final String description;

  const InventoryItem({
    required this.id,
    required this.name,
    required this.quantity,
    required this.price,
    required this.description,
  });

  Map<String, dynamic> toMap() {
    return {
      'id': id,
      'name': name,
      'quantity': quantity,
      'price': price,
      'description': description,
    };
  }

  factory InventoryItem.fromMap(Map<String, dynamic> map) {
    return InventoryItem(
      id: map['id'] as String,
      name: map['name'] as String,
      quantity: map['quantity'] as int,
      price: (map['price'] as num).toDouble(),
      description: map['description'] as String,
    );
  }

  InventoryItem copyWith({
    String? id,
    String? name,
    int? quantity,
    double? price,
    String? description,
  }) {
    return InventoryItem(
      id: id ?? this.id,
      name: name ?? this.name,
      quantity: quantity ?? this.quantity,
      price: price ?? this.price,
      description: description ?? this.description,
    );
  }
}