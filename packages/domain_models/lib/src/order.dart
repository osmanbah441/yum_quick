import 'package:domain_models/domain_models.dart';
import 'package:equatable/equatable.dart';

enum OrderStatus {
  pending,
  ongoing,
  completed,
  cancelled;
}

/// represents a confirmed purchase placed by a user.
class Order extends Equatable {
  const Order({
    required this.id,
    required this.userId,
    required this.deliveryDate,
    required this.totalPrice,
    required this.quantity,
    this.status = OrderStatus.pending,
    required this.items,
  });

  final String id;
  final String userId;
  final DateTime deliveryDate;
  final double totalPrice;
  final OrderStatus status;
  final List<CartItem> items;
  final int quantity;

  String get formattedDate {
    final day = deliveryDate.day.toString().padLeft(2, '0');
    final month = _shortMonthNames[deliveryDate.month];
    final year = deliveryDate.year;
    return "$day-$month-$year";
  }

  @override
  List<Object?> get props => [id, userId, deliveryDate, status];
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
