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
    this.formattedDate,
  });

  final String id;
  final String userId;
  final DateTime deliveryDate;
  final double totalPrice;
  final OrderStatus status;
  final List<CartItem> items;
  final int quantity;

  final String? formattedDate;

  @override
  List<Object?> get props => [id, userId, deliveryDate, status];
}
