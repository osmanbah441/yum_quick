import 'package:domain_models/domain_models.dart';
import 'package:quick_api/quick_api.dart';

extension CartRMtoDomain on CartRM {
  Cart get toDomain => Cart(
        id: id,
        userId: userId,
        cartItems: cartItems.map((item) => item.toDomain).toList(),
        deliveryCost: deliveryCost ?? 0.0,
        total: total ?? 0.0,
        subtotal: subtotal ?? 0.0,
        quantity: quantity ?? 0,
      );
}

extension CartItemRMtoDomain on CartItemRM {
  CartItem get toDomain => CartItem(
        id: id,
        product: product.toDomain,
        quantity: quantity,
        totalPrice: totalPrice ?? 0.0,
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
