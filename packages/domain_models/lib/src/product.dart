enum ProductCategory {
  shawarma,
  pizza,
  burger,
  yogurt;

  static ProductCategory? getCategory(String? category) {
    switch (category) {
      case 'burger':
        return ProductCategory.burger;
      case 'shawarma':
        return ProductCategory.shawarma;
      case 'pizza':
        return ProductCategory.pizza;
      case 'yogurt':
        return ProductCategory.yogurt;
      case null:
        return null;
      default:
        throw ArgumentError("invalid enum value");
    }
  }
}

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
