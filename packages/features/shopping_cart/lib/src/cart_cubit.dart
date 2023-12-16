import 'package:cart_repository/cart_repository.dart';
import 'package:domain_models/domain_models.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:order_repository/order_repository.dart';

part 'cart_state.dart';

class CartCubit extends Cubit<CartState> {
  CartCubit(
      {required CartRepository cartRepository,
      required OrderRepository orderRepository})
      : _cartRepository = cartRepository,
        _orderRepository = orderRepository,
        super(CartStateInprogress()) {
    _fetchCartItems();
  }
  final CartRepository _cartRepository;
  final OrderRepository _orderRepository;

  void incrementProductQty(CartItem item) =>
      _updateItemQuantity(item.id, item.quantity + 1);

  void decrementProductQty(CartItem item) =>
      _updateItemQuantity(item.id, item.quantity - 1);

  void _updateItemQuantity(String productId, int newQuantity) async {
    try {
      await _cartRepository.updateItemQuantity(productId, newQuantity);
      _fetchCartItems();
    } catch (e) {
      // TODO handle errors
    }
  }

  void _fetchCartItems() {
    try {
      final cart = _cartRepository.getCart();
      emit(CartStateSuccess(cart: cart));
    } on Exception catch (e) {
      // TODO handle errors
    }
  }

  void refetch() {
    emit(CartStateInprogress());
    _fetchCartItems();
  }

  void removeCartItem(String productId) async {
    try {
      await _cartRepository.remove(productId);
      _fetchCartItems();
    } on Exception catch (_) {
      // TODO handle errors
    }
  }

  void placeOrder(Cart cart) async {
    try {
      await _orderRepository.placeOrder(cart);
    } catch (e) {}
  }
}
