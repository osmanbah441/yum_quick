class ProductListPageRM {
  const ProductListPageRM({
    required this.isLastPage,
    required this.productList,
  });

  final bool isLastPage;
  final List<ProductRM> productList;
}

class ProductRM {
  const ProductRM({
    required this.id,
    required this.name,
    required this.price,
    this.description,
    required this.imageUrl,
    required this.category,
    required this.averageRating,
    required this.inventory,
    required this.isFavorite,
  });
  final String id;
  final String name;
  final String? description;
  final String imageUrl;
  final double price;
  final String? category;
  final double averageRating;
  final int inventory;
  final bool isFavorite;
}
