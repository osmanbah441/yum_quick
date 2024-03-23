import 'dart:async';

import 'package:domain_models/domain_models.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:repositories/repositories.dart';

part 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit({
    required CartRepository cartRepository,
    required OrderRepository orderRepository,
    required UserRepository userRepository,
  })  : _cartRepository = cartRepository,
        _orderRepository = orderRepository,
        super(CartStateInprogress()) {
    _authChangesSubscription = userRepository.getUserStream().listen((user) {
      _authenticatedUserId = user?.id;
      _authenticatedUserCartId = user?.cartId;

      _fetchCartItems();
    });
  }
  final CartRepository _cartRepository;
  final OrderRepository _orderRepository;

  late final StreamSubscription _authChangesSubscription;
  String? _authenticatedUserId, _authenticatedUserCartId;

  void incrementCartItemQty(CartItem item) {
    _updateItemQuantity(item.id!, item.quantity + 1);
  }

  void decrementCartItemQty(CartItem item) {
    _updateItemQuantity(item.id!, item.quantity - 1);
  }

  void _updateItemQuantity(String cartItemId, int newQuantity) async {
    try {
      if (!_isUserAuthenticatedAndOwnsCart) {
        throw const UserAuthenticationRequiredException();
      }

      await _cartRepository.updateCartItemQuantity(
          _authenticatedUserCartId!, cartItemId, newQuantity);
      _fetchCartItems();
    } catch (e) {
      // TODO handle errors
    }
  }

  void _fetchCartItems() async {
    try {
      if (!_isUserAuthenticatedAndOwnsCart) {
        throw const UserAuthenticationRequiredException();
      }

      final cart = await _cartRepository.getCartById(
        _authenticatedUserCartId!,
        _authenticatedUserId!,
      );
      emit(CartStateSuccess(cart: cart));
    } on Exception catch (_) {
      rethrow; // TODO:
    }
  }

  void refetch() {
    emit(CartStateInprogress());
    _fetchCartItems();
  }

  void removeCartItem(String productId) async {
    try {
      // await _cartRepository.remove(productId); // TODO:
      _fetchCartItems();
    } on Exception catch (_) {
      // TODO handle errors
    }
  }

  void placeOrder(Cart cart) async {
    try {
      if (!_isUserAuthenticatedAndOwnsCart) {
        throw const UserAuthenticationRequiredException();
      }
      await _orderRepository.placeOrderByUser(_authenticatedUserId!, cart);
    } catch (e) {}
  }

  bool get _isUserAuthenticatedAndOwnsCart =>
      _authenticatedUserCartId != null && _authenticatedUserId != null;

  @override
  Future<void> close() {
    _authChangesSubscription.cancel();
    return super.close();
  }
}
