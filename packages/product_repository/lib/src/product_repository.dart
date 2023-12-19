import 'package:domain_models/domain_models.dart';
import 'package:product_repository/src/mappers/mappers.dart';
import 'package:quick_api/quick_api.dart';

class ProductRepository {
  const ProductRepository({required QuickApi api}) : _api = api;

  final QuickApi _api;

  Future<ProductListPage> getProductListPage({
    required int page,
    ProductCategory? category,
    required String searchTerm,
    String? favoritedByUsername,
  }) async {
    try {
      final fetchPage = await _api.getProductListPageRM(
        page: page,
        category: category?.toRemote,
        searchTerm: searchTerm,
        favoritedByUsername: favoritedByUsername,
      );

      return fetchPage.toDomain;
    } catch (e) {
      throw 'failed to read products';
    }
  }

  Future<Product> getProductDetails(String productId) async {
    try {
      final fetchProduct = await _api.getProductDetails(productId);
      return fetchProduct.toDomain;
    } catch (e) {
      throw 'failed to get product';
    }
  }

  Future<Product> favoriteProduct(String productId) async {
    try {
      final product = await _api.favoriteProduct(productId);
      return product.toDomain;
    } catch (e) {
      throw e;
    }
  }

  Future<Product> unfavoriteQuote(String productId) async {
    try {
      final product = await _api.unfavoriteQuote(productId);
      return product.toDomain;
    } catch (e) {
      throw e;
    }
  }
}
