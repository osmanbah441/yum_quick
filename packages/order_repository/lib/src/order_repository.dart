import 'package:domain_models/domain_models.dart';
import 'package:quick_api/quick_api.dart';
import 'package:order_repository/src/mappers/mappers.dart';

final class OrderRepository {
  const OrderRepository({
    required QuickApi api,
  }) : _api = api;

  final QuickApi _api;

  Future<OrderListPage> getOrderListPageByUser(
    String userId, {
    required int page,
    OrderStatus? status,
  }) async {
    try {
      final fetchPage = await _api.order.getOrderListPageByUser(
        userId,
        page: page,
        status: status?.name,
      );

      final domainPage = fetchPage.toDomain;
      return OrderListPage(
        isLastPage: domainPage.isLastPage,
        orderList: domainPage.orderList,
      );
    } catch (e) {
      throw e;
    }
  }

  Future<Order> getUserOrderById(String orderId, String userId) async {
    try {
      final fetchOrder = await _api.order.getUserOrderById(orderId, userId);
      return fetchOrder.toDomain;
    } catch (e) {
      throw e;
    }
  }

  Future<void> placeOrderByUser(String userId, Cart cart) async {
    try {
      await _api.order.placeOrderByUser(userId, cart.toRemote);
    } catch (e) {
      throw e;
    }
  }
}
