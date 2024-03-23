import 'package:api/api.dart';
import 'package:domain_models/domain_models.dart';
import 'package:repositories/src/product/mappers/remote_to_domain.dart';

class ProductRepository {
  const ProductRepository({required Api api}) : _api = api;

  final Api _api;

  Future<ProductListPage> getProductListPage({
    required int page,
    ProductCategory? category,
    required String searchTerm,
    bool userFavoritesOnly = false,
  }) async {
    try {
      final fetchPage = await _api.product.getProductListPageRM(
        page: page,
        category: category?.name,
        searchTerm: searchTerm,
        userFavoritesOnly: userFavoritesOnly,
      );

      return fetchPage.toDomain;
    } catch (e) {
      throw 'failed to read products';
    }
  }

  Future<Product> getProductDetails(String productId) async {
    try {
      final fetchProduct = await _api.product.getProductDetails(productId);
      return fetchProduct.toDomain;
    } catch (e) {
      throw 'failed to get product';
    }
  }

  Future<Product> favoriteProduct(String productId) async {
    try {
      final product = await _api.product.favoriteProduct(productId);
      return product.toDomain;
    } catch (e) {
      throw e;
    }
  }

  Future<Product> unfavoriteQuote(String productId) async {
    try {
      final product = await _api.product.unfavoriteProduct(productId);
      return product.toDomain;
    } catch (e) {
      throw e;
    }
  }
}
