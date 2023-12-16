import 'package:domain_models/domain_models.dart';
import 'package:equatable/equatable.dart';

/// represent items a user want to buy
class Cart extends Equatable {
  const Cart({
    required this.id,
    required this.userId,
    required this.cartItems,
    required this.deliveryCost,
  });
  final String id, userId;
  final List<CartItem> cartItems;
  final double deliveryCost;

  double get subtotal =>
      cartItems.fold(0.0, (prev, item) => prev + item.totalPrice);

  int get quantity => cartItems.fold(0, (prev, item) => prev + item.quantity);

  double get total => subtotal + deliveryCost;

  @override
  List<Object?> get props => [cartItems, subtotal, deliveryCost];
}

/// represents a single item within a larger order.
class CartItem {
  CartItem({
    required this.id,
    required this.product,
    int quantity = 0,
  }) : _quantity = quantity;

  final String id;
  final Product product;

  double get totalPrice => product.price * quantity;

  int _quantity;

  int get quantity => _quantity;

  void setQuantity(int newQuantity) {
    _quantity = newQuantity;
  }
}
