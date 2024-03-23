import 'product_rm.dart';

/// represent items a user want to buy
class CartRM {
  const CartRM({
    required this.id,
    required this.userId,
    required this.cartItems,
    this.deliveryCost,
    this.quantity,
    this.subtotal,
    this.total,
  });
  final String id, userId;
  final List<CartItemRM> cartItems;
  final double? deliveryCost;
  final double? subtotal;
  final int? quantity;
  final double? total;
}

/// represents a single item within a larger order.
class CartItemRM {
  const CartItemRM({
    this.id,
    required this.product,
    required this.quantity,
    this.totalPrice,
  });

  final String? id;
  final ProductRM product;
  final double? totalPrice;
  final int quantity;
}
