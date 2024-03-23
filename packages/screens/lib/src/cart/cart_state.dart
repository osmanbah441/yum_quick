part of 'cart_cubit.dart';

sealed class CartState {}

class CartStateInprogress extends CartState {}

class CartStateFailure extends CartState {}

class CartStateSuccess extends CartState {
  CartStateSuccess({required this.cart, this.cartUpdateError});

  final Cart cart;
  final dynamic cartUpdateError;
}
