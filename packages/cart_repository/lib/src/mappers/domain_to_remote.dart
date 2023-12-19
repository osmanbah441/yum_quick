import 'package:domain_models/domain_models.dart';
import 'package:quick_api/quick_api.dart';

extension CartToRemote on Cart {
  CartRM get toRemote => CartRM(
        id: id,
        userId: userId,
        items: items.map((item) => item.toRemote).toList(),
        deliveryCost: deliveryCost,
      );
}

extension CartItemToRemote on CartItem {
  CartItemRM get toRemote => CartItemRM(
        id: id,
        product: product.toRemote,
        quantity: quantity,
      );
}

extension ProducttoRemote on Product {
  ProductRM get toRemote => ProductRM(
        id: id,
        name: name,
        price: price,
        averageRating: averageRating,
        category: category?.toRemote,
        description: description,
        imageUrl: imageUrl,
        inventory: inventory,
        isFavorite: isFavorite,
      );
}

extension ProductCategorytoRemote on ProductCategory {
  ProductCategoryRM get toRemote => switch (this) {
        ProductCategory.shawarma => ProductCategoryRM.shawarma,
        ProductCategory.pizza => ProductCategoryRM.pizza,
        ProductCategory.burger => ProductCategoryRM.burger,
        ProductCategory.yogurt => ProductCategoryRM.yogurt,
      };
}
