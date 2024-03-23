import 'package:api/api.dart';
import 'package:domain_models/domain_models.dart';

extension CartToRemote on Cart {
  CartRM get toRemote => CartRM(
        id: id,
        userId: userId,
        cartItems: cartItems.map((item) => item.toRemote).toList(),
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
        category: category?.name,
        description: description,
        imageUrl: imageUrl,
        inventory: inventory,
        isFavorite: isFavorite,
      );
}
