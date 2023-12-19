import 'product_rm.dart';

/// represent items a user want to buy
class CartRM {
  const CartRM({
    required this.id,
    required this.userId,
    required this.items,
    required this.deliveryCost,
  });
  final String id, userId;
  final List<CartItemRM> items;
  final double deliveryCost;

  double get subtotal =>
      items.fold(0.0, (prev, item) => prev + item.totalPrice);

  int get quantity => items.fold(0, (prev, item) => prev + item.quantity);

  double get total => subtotal + deliveryCost;
}

/// represents a single item within a larger order.
class CartItemRM {
  CartItemRM({
    this.id,
    required this.product,
    int quantity = 0,
  }) : _quantity = quantity;

  final String? id;
  final ProductRM product;

  double get totalPrice => product.price * quantity;

  int _quantity;

  int get quantity => _quantity;

  void setQuantity(int newQuantity) {
    _quantity = newQuantity;
  }
}
