import 'modifier.dart';

class Product {
  final String id;
  final String name;
  final double price;
  final String description;
  final String? imageUrl;
  final String categoryId;
  final ModifierGroups? modifiers;

  Product({
    required this.id,
    required this.name,
    required this.price,
    required this.description,
    this.imageUrl,
    required this.categoryId,
    this.modifiers,
  });

  factory Product.fromJson(Map<String, dynamic> json) {
    return Product(
      id: json['id'] as String,
      name: json['name'] as String,
      price: (json['price'] as num).toDouble(),
      description: json['description'] as String? ?? '',
      imageUrl: json['imageUrl'] as String?,
      categoryId: json['categoryId'] as String,
      modifiers: ModifierGroups.fromJson(json['modifiers'] as Map<String, dynamic>?),
    );
  }

  Map<String, dynamic> toJson() {
    return {
      'id': id,
      'name': name,
      'price': price,
      'description': description,
      'imageUrl': imageUrl,
      'categoryId': categoryId,
    };
  }
}

class ProductCategory {
  final String id;
  final String name;
  final String? icon;

  ProductCategory({
    required this.id,
    required this.name,
    this.icon,
  });

  factory ProductCategory.fromJson(Map<String, dynamic> json) {
    return ProductCategory(
      id: json['id'] as String,
      name: json['name'] as String,
      icon: json['icon'] as String?,
    );
  }
}
