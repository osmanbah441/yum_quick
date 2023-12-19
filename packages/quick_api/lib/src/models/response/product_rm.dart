class ProductListPageRM {
  const ProductListPageRM({
    required this.isLastPage,
    required this.productList,
  });

  final bool isLastPage;
  final List<ProductRM> productList;
}

enum ProductCategoryRM { shawarma, pizza, burger, yogurt }

class ProductRM {
  ProductRM({
    required this.id,
    required this.name,
    required this.price,
    this.description,
    required this.imageUrl,
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
  final ProductCategoryRM? category;
  final double averageRating;
  final int inventory;
  final bool isFavorite;

  // TODO: remove this is just for testing
  ProductRM copywith({bool? isFavorite}) => ProductRM(
        id: id,
        name: name,
        price: price,
        imageUrl: imageUrl,
        category: category,
        isFavorite: isFavorite ?? this.isFavorite,
        description: description,
        averageRating: averageRating,
        inventory: inventory,
      );
}
