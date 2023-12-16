import 'package:domain_models/domain_models.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:order_repository/order_repository.dart';

part 'order_state.dart';

class OrderListCubit extends Cubit<OrderListState> {
  OrderListCubit({required OrderRepository orderRepository})
      : _orderRepository = orderRepository,
        super(OrderListInProgress()) {
    _fetchOrderItems();
  }
  final OrderRepository _orderRepository;

  void _fetchOrderItems() async {
    try {
      final order = await _orderRepository.getOrders();
      emit(OrderListSuccess(orders: order));
    } on Exception catch (e) {
      // TODO handle errors
    }
  }

  void refetch() {
    emit(OrderListInProgress());
    _fetchOrderItems();
  }

  void placeOrder(Cart cart) async {
    try {
      await _orderRepository.placeOrder(cart);
    } catch (e) {}
  }
}
