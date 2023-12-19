import 'package:cart_repository/src/mappers/mappers.dart';
import 'package:domain_models/domain_models.dart';
import 'package:quick_api/quick_api.dart';

class CartRepository {
  const CartRepository({required QuickApi api}) : _api = api;

  final QuickApi _api;

  Future<Cart> getCartById(String cartId, String userId) async {
    try {
      final fetchCart = await _api.getUserCartById(cartId, userId);
      return fetchCart.toDomain;
    } catch (e) {
      throw e;
    }
  }

  Future<void> addCartItem(
    String cartId,
    Product product,
  ) async {
    try {
      await _api.addCartItem(cartId, product.toRemote);
    } catch (e) {
      throw e;
    }
  }

  Future<void> updateCartItemQuantity(
    String cartId,
    String cartItemId,
    int newQuantity,
  ) async {
    try {
      await _api.updateCartItemQuantity(cartId, cartItemId, newQuantity);
    } catch (e) {
      throw e;
    }
  }

  Future<void> removeCartItem(String cartId, String cartItemId) async {
    try {
      await _api.removeCartItem(cartId, cartItemId);
    } catch (e) {
      throw e;
    }
  }

  Future<void> clearCart(String cartId) async {
    try {
      await _api.clearCart(cartId);
    } catch (e) {
      throw e;
    }
  }
}
