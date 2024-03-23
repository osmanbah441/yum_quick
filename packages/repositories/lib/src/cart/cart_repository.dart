import 'package:api/api.dart';
import 'package:domain_models/domain_models.dart';
import 'package:repositories/src/cart/mappers/mappers.dart';

class CartRepository {
  const CartRepository({required Api api}) : _api = api;

  final Api _api;

  Future<Cart> getCartById(String cartId, String userId) async {
    try {
      final fetchCart = await _api.cart.getUserCartById(cartId, userId);
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
      await _api.cart.addCartItem(cartId, product.toRemote);
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
      await _api.cart.updateCartItemQuantity(cartId, cartItemId, newQuantity);
    } catch (e) {
      throw e;
    }
  }

  Future<void> removeCartItem(String cartId, String cartItemId) async {
    try {
      await _api.cart.removeCartItem(cartId, cartItemId);
    } catch (e) {
      throw e;
    }
  }

  Future<void> clearCart(String cartId) async {
    try {
      await _api.cart.clearCart(cartId);
    } catch (e) {
      throw e;
    }
  }
}
