import 'package:domain_models/domain_models.dart';
import 'package:equatable/equatable.dart';

class OrderListPage extends Equatable {
  const OrderListPage({
    required this.isLastPage,
    required this.orderList,
  });

  final bool isLastPage;
  final List<Order> orderList;

  @override
  List<Object?> get props => [
        isLastPage,
        orderList,
      ];
}
