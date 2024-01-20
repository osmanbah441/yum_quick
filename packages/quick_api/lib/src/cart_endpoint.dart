import 'package:quick_api/quick_api.dart';
import 'package:quick_api/src/utils/custom_http_client.dart';

final class CartEndpoint {
  const CartEndpoint(this._client);
  final CustomHttpClient _client;

  Future<void> removeCartItem(String cartId, String cartItemId) {
    // TODO: implement removeCartItem
    throw UnimplementedError();
  }

  Future<void> updateCartItemQuantity(
      String cartId, String cartItemId, int newQuantity) {
    // TODO: implement updateCartItemQuantity
    throw UnimplementedError();
  }

  Future<void> addCartItem(String cartId, ProductRM product) {
    // TODO: implement addCartItem
    throw UnimplementedError();
  }

  Future<void> clearCart(String cartId) {
    // TODO: implement clearCart
    throw UnimplementedError();
  }

  Future<CartRM> getUserCartById(String cartId, String userId) {
    // TODO: implement getUserCartById
    throw UnimplementedError();
  }
}
