import 'package:equatable/equatable.dart';

final class Product extends Equatable {
  const Product({
    this.id,
    required this.name,
    required this.category,
    required this.price,
    required this.imageUrl,
    required this.isFavorite,
    required this.description,
  });

  final String? id;
  final String name;
  final String category;
  final double price;
  final String imageUrl;
  final bool isFavorite;
  final String description;

  factory Product.fromFirestore(Map<String, dynamic> map, String id) {
    return Product(
        id: id,
        name: map['name'] as String,
        category: map['category'] as String,
        price: map['price'] as double,
        imageUrl: map['imageUrl'] as String,
        isFavorite: map['isFavorite'] as bool,
        description: map['description'] as String);
  }

  Map<String, dynamic> toJson() {
    return {
      'name': name,
      'category': category,
      'price': price,
      'imageUrl': imageUrl,
      'isFavorite': isFavorite,
      'description': description,
    };
  }

  @override
  List<Object?> get props =>
      [id, name, category, price, imageUrl, isFavorite, description];
}
