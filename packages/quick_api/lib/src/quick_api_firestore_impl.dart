import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:quick_api/quick_api.dart';
import 'package:quick_api/src/quick_api_firestore_query_builder.dart';

import 'firebase_options.dart';

final class QuickApiFireStoreImpl implements QuickApi {
  QuickApiFireStoreImpl();

  Future<void> initializeApi({required bool kDebugMode}) async {
    // const host = '192.168.1.10';
    const host = 'localhost';
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    if (kDebugMode) {
      await FirebaseAuth.instance.useAuthEmulator(host, 9099);
      FirebaseFirestore.instance.useFirestoreEmulator(host, 8080);
      // await FirebaseStorage.instance.useEmulator(storageHost);
    }
  }

  final _queryBuilder = QuickApiFirestoreQueryBuilder();

  // pagination
  DocumentSnapshot? _productLastDocument;

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
  Future<ProductListPageRM> getProductListPageRM({
    required int page,
    ProductCategoryRM? category,
    String searchTerm = '',
    String? favoritedByUsername,
  }) async {
    final query = _queryBuilder.getProductListQuery(
      category: category?.name,
      searchTerm: searchTerm,
      pageSize: 10,
      lastDocument: _productLastDocument,
    );

    final fetchPage = await query.get();
    _productLastDocument = fetchPage.docs.last;

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
