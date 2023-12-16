import 'package:domain_models/domain_models.dart';

class ProductRepository {
  const ProductRepository();
  // Simulated list of products (replace this with your actual data source)
  static List<Product> _products = [
    Product(id: "1", name: "T-Shirt", price: 20.0),
    Product(id: "2", name: "Hat", price: 15.0),
    Product(id: "3", name: "T-Shirt", price: 20.0),
    Product(id: "4", name: "Hat", price: 15.0),
    Product(id: "5", name: "T-Shirt", price: 20.0),
    Product(id: "6", name: "Hat", price: 15.0),
    Product(id: "7", name: "T-Shirt", price: 20.0),
    Product(id: "8", name: "Hat", price: 15.0),
    Product(id: "9", name: "T-Shirt", price: 20.0),
    Product(id: "10", name: "Hat", price: 15.0),
  ];

  Future<ProductListPage> getProductListPage({
    required int page,
    Category? tag,
    required String searchTerm,
    String? favoritedByUsername,
  }) async {
    await Future.delayed(const Duration(seconds: 1));

    return ProductListPage(isLastPage: true, productList: _products);
  }

  Future<Product> getProductDetails(String productId) async {
    await Future.delayed(const Duration(seconds: 1));

    return _products.firstWhere((product) => product.id == productId);
  }

  favoriteProduct(String productId) {}

  unfavoriteQuote(String productId) {}
}
