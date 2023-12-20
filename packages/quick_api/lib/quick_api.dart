import 'package:quick_api/quick_api.dart';
import 'package:quick_api/src/quick_api.dart';

export 'src/models/response/response.dart';

abstract interface class QuickApi {
  factory QuickApi() => QuickApiImpl();

  Future<void> initializeApi({required bool kDebugMode});

  Future<ProductListPageRM> getProductListPageRM({
    required int page,
    ProductCategoryRM? category,
    String searchTerm = '',
    String? favoritedByUsername,
  });

  Future<ProductRM> getProductDetails(String productId);

  Future<ProductRM> favoriteProduct(String productId);

  Future<ProductRM> unfavoriteQuote(String productId);

  Future<CartRM> getUserCartById(String cartId, String userId);

  Future<void> addCartItem(String cartId, ProductRM product);

  Future<void> updateCartItemQuantity(
    String cartId,
    String cartItemId,
    int newQuantity,
  );

  Future<void> removeCartItem(String cartId, String cartItemId);

  Future<void> clearCart(String cartId);

  Future<OrderListPageRM> getOrderListPageByUser(
    String userId, {
    required int page,
    OrderStatusRM? status,
  });

  Future<void> placeOrderByUser(String userId, CartRM cart);

  Future<OrderRM> getUserOrderById(String orderId, String userId);

  Future<UserRM> register(String username, String email, String password);

  Future<UserRM> login(String email, String password);

  Future<void> logout();

  Stream<UserRM> getUserStream();
}
