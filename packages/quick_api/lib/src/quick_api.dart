import 'package:quick_api/quick_api.dart';

final class QuickApiImpl implements QuickApi {
  @override
  Future<void> addCartItem(String cartId, ProductRM product) {
    // TODO: implement addCartItem
    throw UnimplementedError();
  }

  @override
  Future<void> clearCart(String cartId) {
    // TODO: implement clearCart
    throw UnimplementedError();
  }

  @override
  Future<ProductRM> favoriteProduct(String productId) {
    // TODO: implement favoriteProduct
    throw UnimplementedError();
  }

  @override
  Future<OrderListPageRM> getOrderListPageByUser(String userId,
      {required int page, OrderStatusRM? status}) {
    // TODO: implement getOrderListPageByUser
    throw UnimplementedError();
  }

  @override
  Future<ProductRM> getProductDetails(String productId) {
    // TODO: implement getProductDetails
    throw UnimplementedError();
  }

  @override
  Future<ProductListPageRM> getProductListPageRM(
      {required int page,
      ProductCategoryRM? category,
      String searchTerm = '',
      String? favoritedByUsername}) {
    // TODO: implement getProductListPageRM
    throw UnimplementedError();
  }

  @override
  Future<CartRM> getUserCartById(String cartId, String userId) {
    // TODO: implement getUserCartById
    throw UnimplementedError();
  }

  @override
  Future<OrderRM> getUserOrderById(String orderId, String userId) {
    // TODO: implement getUserOrderById
    throw UnimplementedError();
  }

  @override
  Stream<UserRM> getUserStream() {
    // TODO: implement getUserStream
    throw UnimplementedError();
  }

  @override
  Future<void> initializeApi({required bool kDebugMode}) {
    // TODO: implement initializeApi
    throw UnimplementedError();
  }

  @override
  Future<UserRM> login(String email, String password) {
    // TODO: implement login
    throw UnimplementedError();
  }

  @override
  Future<void> logout() {
    // TODO: implement logout
    throw UnimplementedError();
  }

  @override
  Future<void> placeOrderByUser(String userId, CartRM cart) {
    // TODO: implement placeOrderByUser
    throw UnimplementedError();
  }

  @override
  Future<UserRM> register(String username, String email, String password) {
    // TODO: implement register
    throw UnimplementedError();
  }

  @override
  Future<void> removeCartItem(String cartId, String cartItemId) {
    // TODO: implement removeCartItem
    throw UnimplementedError();
  }

  @override
  Future<ProductRM> unfavoriteQuote(String productId) {
    // TODO: implement unfavoriteQuote
    throw UnimplementedError();
  }

  @override
  Future<void> updateCartItemQuantity(
      String cartId, String cartItemId, int newQuantity) {
    // TODO: implement updateCartItemQuantity
    throw UnimplementedError();
  }
}
