import 'package:cart_repository/cart_repository.dart';
import 'package:component_library/component_library.dart';
import 'package:domain_models/domain_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:order_repository/order_repository.dart';
import 'package:shopping_cart/src/cart_item_title.dart';

import 'cart_cubit.dart';

class CartScreen extends StatelessWidget {
  const CartScreen({
    required this.userId,
    required this.onAuthenticationError,
    required this.cartRepository,
    required this.orderRepository,
    super.key,
  });

  final String userId;
  final VoidCallback onAuthenticationError;
  final CartRepository cartRepository;
  final OrderRepository orderRepository;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<CartCubit>(
      create: (_) => CartCubit(
        cartRepository: cartRepository,
        orderRepository: orderRepository,
      ),
      child: CartView(
        onAuthenticationError: onAuthenticationError,
      ),
    );
  }
}

@visibleForTesting
class CartView extends StatelessWidget {
  const CartView({
    required this.onAuthenticationError,
    super.key,
  });

  final VoidCallback onAuthenticationError;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<CartCubit, CartState>(
      listener: (context, state) {
        final cartUpdateError =
            state is CartStateSuccess ? state.cartUpdateError : null;
        if (cartUpdateError != null) {
          final snackBar =
              cartUpdateError is UserAuthenticationRequiredException
                  ? const AuthenticationRequiredErrorSnackBar()
                  : const GenericErrorSnackBar();

          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(snackBar);

          if (cartUpdateError is UserAuthenticationRequiredException) {
            onAuthenticationError();
          }
        }
      },
      builder: (context, state) {
        return PopScope(
          canPop: false,
          onPopInvoked: (bool didPop) async {
            if (didPop) return;
          },
          child: Scaffold(
            appBar: AppBar(
              title: Text('Feast Assembly'),
              leading: Icon(Icons.food_bank_outlined),
            ),
            body: SafeArea(
                child: switch (state) {
              CartStateInprogress() =>
                const CenteredCircularProgressIndicator(),
              CartStateSuccess() => _Cart(state.cart),
              CartStateFailure() => ExceptionIndicator(
                  onTryAgain: () {
                    final cubit = context.read<CartCubit>();
                    cubit.refetch();
                  },
                ),
            }),
          ),
        );
      },
    );
  }
}

class _Cart extends StatelessWidget {
  const _Cart(this.cart);
  final Cart cart;

  @override
  Widget build(BuildContext context) {
    final cartCubit = context.read<CartCubit>();
    const textStyle = TextStyle(fontSize: 18, fontWeight: FontWeight.bold);
    return Padding(
      padding: const EdgeInsets.all(8.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Expanded(
            child: ListView.builder(
              itemCount: cart.cartItems.length,
              itemBuilder: (context, index) {
                final cartItems = cart.cartItems[index];
                return CartItemTile(
                  cartItem: cartItems,
                  onIncrement: () => cartCubit.incrementProductQty(cartItems),
                  onDecrement: () => cartCubit.decrementProductQty(cartItems),
                  onRemove: () => cartCubit.removeCartItem(cartItems.id),
                );
              },
            ),
          ),
          Text('subtotal: ${cart.subtotal}', style: textStyle),
          Text('delivery cost: ${cart.deliveryCost}', style: textStyle),
          Text('total: ${cart.total}', style: textStyle),
          ExpandedElevatedButton(
            label: 'buy now',
            onTap: () => cartCubit.placeOrder(cart),
          )
        ],
      ),
    );
  }
}