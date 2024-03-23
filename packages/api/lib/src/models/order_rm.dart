import 'package:api/api.dart';

class OrderListPageRM {
  const OrderListPageRM({
    required this.isLastPage,
    required this.orderList,
  });

  final bool isLastPage;
  final List<OrderRM> orderList;
}

/// represents a confirmed purchase placed by a user.
class OrderRM {
  const OrderRM({
    required this.id,
    required this.userId,
    required this.deliveryDate,
    required this.totalPrice,
    required this.quantity,
    required this.status,
    required this.items,
  });

  final String id;
  final String userId;
  final DateTime deliveryDate;
  final double totalPrice;
  final String status;
  final List<CartItemRM> items;
  final int quantity;
}
