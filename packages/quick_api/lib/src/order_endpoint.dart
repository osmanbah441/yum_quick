import 'package:quick_api/quick_api.dart';
import 'package:quick_api/src/utils/custom_http_client.dart';

final class OrderEndpoint {
  const OrderEndpoint(this._client);
  final CustomHttpClient _client;

  Future<void> placeOrderByUser(String userId, CartRM cart) {
    // TODO: implement placeOrderByUser
    throw UnimplementedError();
  }

  Future<OrderListPageRM> getOrderListPageByUser(String userId,
      {required int page, String? status}) {
    // TODO: implement getOrderListPageByUser
    throw UnimplementedError();
  }

  Future<OrderRM> getUserOrderById(String orderId, String userId) {
    // TODO: implement getUserOrderById
    throw UnimplementedError();
  }
}
