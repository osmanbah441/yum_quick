import 'package:quick_api/quick_api.dart';

class OrderListPageRM {
  const OrderListPageRM({
    required this.isLastPage,
    required this.orderList,
  });

  final bool isLastPage;
  final List<OrderRM> orderList;
}

enum OrderStatusRM {
  pending,
  ongoing,
  completed,
  cancelled;
}

/// represents a confirmed purchase placed by a user.
class OrderRM {
  const OrderRM({
    required this.id,
    required this.userId,
    required this.deliveryDate,
    required this.totalPrice,
    required this.quantity,
    this.status = OrderStatusRM.pending,
    required this.items,
  });

  final String id;
  final String userId;
  final DateTime deliveryDate;
  final double totalPrice;
  final OrderStatusRM status;
  final List<CartItemRM> items;
  final int quantity;

  String get formattedDate {
    final day = deliveryDate.day.toString().padLeft(2, '0');
    final month = _shortMonthNames[deliveryDate.month];
    final year = deliveryDate.year;
    return "$day-$month-$year";
  }
}

const Map<int, String> _shortMonthNames = {
  1: 'Jan',
  2: 'Feb',
  3: 'Mar',
  4: 'Apr',
  5: 'May',
  6: 'Jun',
  7: 'Jul',
  8: 'Aug',
  9: 'Sep',
  10: 'Oct',
  11: 'Nov',
  12: 'Dec',
};
