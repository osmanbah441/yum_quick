enum ProductCategory { shawarma, pizza, burger, yogurt }

class Product {
  Product({
    required this.id,
    required this.name,
    required this.price,
    this.description,
    this.imageUrl = 'https://via.placeholder.com/150',
    required this.category,
    this.averageRating = 0.0,
    this.inventory = 0,
    this.isFavorite = false,
  });
  final String id;
  final String name;
  final String? description;
  final String imageUrl;
  final double price;
  final ProductCategory? category;
  final double averageRating;
  final int inventory;
  final bool isFavorite;
}
