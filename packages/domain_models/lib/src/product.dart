enum Category { shawarma, pizza, burger, yogurt }

class Product {
  Product({
    required this.id,
    required this.name,
    required this.price,
    this.description,
    this.imageUrl = 'https://via.placeholder.com/150',
    this.category,
    this.averageRating = 0.0,
    this.numberOfRatings = 0,
    this.inventory = 0,
    this.isFavorite = false,
    this.isInCart = false,
  });
  final String id;
  final String name;
  final String? description;
  final String imageUrl;
  final double price;
  final Category? category;
  final double averageRating;
  final int numberOfRatings;
  final int inventory;
  final bool isFavorite;
  final bool isInCart;
}
