part of 'order_list_bloc.dart';

final class OrderListState extends Equatable {
  const OrderListState({
    this.itemList,
    this.nextPage,
    this.filter,
    this.error,
    this.refreshError,
  });

  final List<Order>? itemList;
  final int? nextPage;
  final OrderListFilter? filter;
  final dynamic error;
  final dynamic refreshError;

  const OrderListState.noItemsFound(OrderListFilter? filter)
      : this(
          itemList: const [],
          nextPage: 1,
          filter: filter,
          error: null,
        );

  const OrderListState.success({
    required int? nextPage,
    required List<Order> itemList,
    required OrderListFilter? filter,
    required bool isRefresh,
  }) : this(
          nextPage: nextPage,
          itemList: itemList,
          filter: filter,
        );

  OrderListState.loadingNewTag(OrderStatus? status)
      : this(
          filter: status != null ? OrderListFilterByStatus(status) : null,
        );

  OrderListState copyWithNewError(
    dynamic error,
  ) =>
      OrderListState(
        itemList: itemList,
        nextPage: nextPage,
        error: error,
        filter: filter,
        refreshError: null,
      );

  OrderListState copyWithNewRefreshError(
    dynamic refreshError,
  ) =>
      OrderListState(
        itemList: itemList,
        nextPage: nextPage,
        error: error,
        filter: filter,
        refreshError: refreshError,
      );

  OrderListState copyWithUpdatedOrder(
    Order updatedOrder,
  ) {
    return OrderListState(
      itemList: itemList?.map((Order) {
        if (Order.id == updatedOrder.id) {
          return updatedOrder;
        } else {
          return Order;
        }
      }).toList(),
      nextPage: nextPage,
      error: error,
      filter: filter,
      refreshError: null,
    );
  }

  @override
  List<Object?> get props => [
        itemList,
        nextPage,
        filter,
        error,
        refreshError,
      ];
}

abstract base class OrderListFilter extends Equatable {
  const OrderListFilter();

  @override
  List<Object?> get props => [];
}

final class OrderListFilterByStatus extends OrderListFilter {
  const OrderListFilterByStatus(this.status);

  final OrderStatus status;

  @override
  List<Object?> get props => [status];
}

// add more filter which extends [OrderListFilter]