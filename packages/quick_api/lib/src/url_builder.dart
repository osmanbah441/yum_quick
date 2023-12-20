import 'package:quick_api/quick_api.dart';

class UrlBuilder {
  static const String _baseUrl = 'https://your-api-base-url.com';

  static String buildProductListUrl({
    required int page,
    ProductCategoryRM? category,
    String searchTerm = '',
    bool onlyFavorites = false,
  }) {
    return Uri.parse('$_baseUrl/products').replace(
      queryParameters: {
        'page': page.toString(),
        if (category != null) 'category': category.name,
        if (searchTerm.isNotEmpty) 'search': searchTerm,
        if (onlyFavorites) 'favoritedBy': onlyFavorites,
      },
    ).toString();
  }
}
