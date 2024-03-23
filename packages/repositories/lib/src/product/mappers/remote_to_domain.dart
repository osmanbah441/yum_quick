import 'package:api/api.dart';
import 'package:domain_models/domain_models.dart';

extension ProductListPageRMtoDomain on ProductListPageRM {
  ProductListPage get toDomain => ProductListPage(
        isLastPage: isLastPage,
        productList: productList.map((product) => product.toDomain).toList(),
      );
}

extension ProductRMtoDomain on ProductRM {
  Product get toDomain => Product(
        id: id,
        name: name,
        price: price,
        averageRating: averageRating,
        category: ProductCategory.getCategory(category),
        description: description,
        imageUrl: imageUrl,
        inventory: inventory,
        isFavorite: isFavorite,
      );
}
