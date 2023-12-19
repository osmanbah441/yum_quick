import 'package:domain_models/domain_models.dart';
import 'package:quick_api/quick_api.dart';

extension CartRMtoDomain on CartRM {
  Cart get toDomain => Cart(
        id: id,
        userId: userId,
        items: items.map((item) => item.toDomain).toList(),
        deliveryCost: deliveryCost,
        total: total,
        subtotal: subtotal,
        quantity: quantity,
      );
}

extension CartItemRMtoDomain on CartItemRM {
  CartItem get toDomain => CartItem(
        id: id,
        product: product.toDomain,
        quantity: quantity,
        totalPrice: totalPrice,
      );
}

extension ProductRMtoDomain on ProductRM {
  Product get toDomain => Product(
        id: id,
        name: name,
        price: price,
        averageRating: averageRating,
        category: category?.toDomain,
        description: description,
        imageUrl: imageUrl,
        inventory: inventory,
        isFavorite: isFavorite,
      );
}

extension ProductCategoryRMtoDomain on ProductCategoryRM {
  ProductCategory get toDomain => switch (this) {
        ProductCategoryRM.shawarma => ProductCategory.shawarma,
        ProductCategoryRM.pizza => ProductCategory.pizza,
        ProductCategoryRM.burger => ProductCategory.burger,
        ProductCategoryRM.yogurt => ProductCategory.yogurt,
      };
}
