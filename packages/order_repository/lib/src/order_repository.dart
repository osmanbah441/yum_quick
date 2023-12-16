import 'package:domain_models/domain_models.dart';

final class OrderRepository {
  Future<void> placeOrder(Cart cart) async {}

  Future<List<Order>> getOrders() async => _genOrders;
}

List<Order> get _genOrders {
  final items = [
    for (var i = 0; i < 5; i++)
      CartItem(
        quantity: i,
        id: ' $i',
        product: Product(
          id: 'id $i',
          name: 'name $i',
          price: 10 * i.toDouble(),
        ),
      ),
  ];

  final cart = Cart(
    id: 'id',
    userId: 'userId',
    cartItems: items,
    deliveryCost: 10.00,
  );

  return [
    for (var i = 0; i < 5; i++)
      Order(
          id: 'id $i',
          status: (i == 0)
              ? OrderStatus.cancelled
              : (i == 1)
                  ? OrderStatus.pending
                  : (i == 2)
                      ? OrderStatus.ongoing
                      : OrderStatus.completed,
          userId: 'userId $i',
          deliveryDate: DateTime(2023, i, (i + 1) * 2),
          totalPrice: cart.total,
          quantity: cart.quantity,
          items: cart.cartItems)
  ];
}
