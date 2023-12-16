part of 'order_cubit.dart';

sealed class OrderListState {}

class OrderListInProgress extends OrderListState {}

class OrderListFailure extends OrderListState {}

class OrderListSuccess extends OrderListState {
  OrderListSuccess({required this.orders, this.error});

  final List<Order> orders;
  final dynamic error;
}
