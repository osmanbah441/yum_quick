import 'package:domain_models/domain_models.dart';
import 'package:equatable/equatable.dart';

/// represent items a user want to buy
class Cart extends Equatable {
  const Cart({
    required this.id,
    required this.userId,
    required this.items,
    required this.deliveryCost,
    required this.quantity,
    required this.subtotal,
    required this.total,
  });
  final String id, userId;
  final List<CartItem> items;

  /// total product in the cart.
  final int quantity;
  final double deliveryCost, subtotal, total;

  @override
  List<Object?> get props => [
        id,
        userId,
        items,
        deliveryCost,
        quantity,
        subtotal,
        total,
      ];
}

/// represents a single item within a larger order.
class CartItem extends Equatable {
  CartItem({
    this.id,
    required this.product,
    required this.quantity,
    required this.totalPrice,
  });

  final String? id;
  final Product product;

  /// total product item.
  final int quantity;
  final double totalPrice;

  @override
  List<Object?> get props => [
        id,
        product,
        quantity,
        totalPrice,
      ];
}
