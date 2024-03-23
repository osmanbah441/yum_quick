import 'dart:async';

import 'package:domain_models/domain_models.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:repositories/repositories.dart';

part 'order_details_state.dart';

// Cubit to manage order details state
class OrderDetailsCubit extends Cubit<OrderDetailState> {
  OrderDetailsCubit({
    required this.orderId,
    required OrderRepository orderRepository,
    required UserRepository userRepository,
  })  : _orderRepository = orderRepository,
        super(OrderDetailsInProgress()) {
    _authChangesSubscription = userRepository.getUserStream().listen((user) {
      _authenticatedUserId = user?.id;

      _fetchOrder();
    });
  }

  final String orderId;
  final OrderRepository _orderRepository;

  late final StreamSubscription _authChangesSubscription;
  String? _authenticatedUserId;

  void _fetchOrder() async {
    try {
      final isUserAuthenticated = _authenticatedUserId != null;
      if (!isUserAuthenticated) {
        throw const UserAuthenticationRequiredException();
      }

      final order = await _orderRepository.getUserOrderById(
          orderId, _authenticatedUserId!);
      emit(OrderDetailsSuccess(order: order));
    } catch (e) {
      emit(OrderDetailsFailure());
    }
  }

  @override
  Future<void> close() {
    _authChangesSubscription.cancel();
    return super.close();
  }
}
