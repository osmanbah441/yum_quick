import 'package:quick_api/quick_api.dart';
import 'package:quick_api/src/utils/custom_http_client.dart';

final class ProductEndpoint {
  const ProductEndpoint(this._client);
  final CustomHttpClient _client;

  Future<ProductRM> favoriteProduct(String productId) {
    // TODO: implement favoriteProduct
    throw UnimplementedError();
  }

  Future<ProductRM> unfavoriteProduct(String productId) {
    // TODO: implement unfavoriteQuote
    throw UnimplementedError();
  }

  Future<ProductRM> getProductDetails(String productId) async {
    // TODO: remove the ?
    final url = Uri.parse("${_client.baseUrl}/products/?$productId");
    final response = await _client.get(url);
    if (response.statusCode != 200) throw Exception();
    final jsonData = _client.decodeJson(response.body);
    final productData = jsonData["product"];
    final product = _fromJson(productData);
    return product;
  }

  Future<ProductListPageRM> getProductListPageRM({
    required int page,
    String? category,
    String searchTerm = '',
    bool userFavoritesOnly = false,
  }) async {
    final isFilteringByCategory =
        category != null && searchTerm.isEmpty && !userFavoritesOnly;
    final isFilteringBySearch =
        searchTerm.isNotEmpty && category == null && !userFavoritesOnly;
    final isFilteringByFavorites =
        userFavoritesOnly && searchTerm.isEmpty && category == null;

    final url =
        Uri.parse("${_client.baseUrl}/products").replace(queryParameters: {
      if (isFilteringByCategory) "category": category,
      if (isFilteringBySearch) "search": searchTerm,
      if (isFilteringByFavorites) "favorites": userFavoritesOnly,
    });

    final response = await _client.get(url);

    if (response.statusCode != 200) throw Exception('something when wrong');
    final jsonData = _client.decodeJson(response.body);
    final productData = jsonData['products'] as List<dynamic>;
    final productList =
        productData.map((product) => _fromJson(product)).toList();

    return ProductListPageRM(isLastPage: true, productList: productList);
  }

  Future<ProductRM> _updateProduct(String productId) {
    throw UnimplementedError();
  }

  ProductRM _fromJson(Map<String, dynamic> json) => ProductRM(
      id: json['id'],
      name: json['name'],
      price: json['price'],
      imageUrl: json['imageUrl'],
      category: json['category'],
      averageRating: json['averageRating'],
      inventory: json['inventory'],
      isFavorite: json['isFavorite']);
}
