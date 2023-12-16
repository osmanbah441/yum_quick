import 'package:cart_repository/cart_repository.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:order_list/order_list.dart';
import 'package:order_repository/order_repository.dart';
import 'package:product_details/product_details.dart';
import 'package:product_list/product_list.dart';
import 'package:product_repository/product_repository.dart';
import 'package:shopping_cart/shopping_cart.dart';
import 'package:user_repository/user_repository.dart';

final class AppRouter {
  static const _productRepository = ProductRepository();
  static const _userRepository = UserRepository();
  static final _cartRepository = CartRepository();
  static final _orderRepository = OrderRepository();

  static final router = GoRouter(
    initialLocation: _PathConstants.productListPath,
    routes: [_bottomNavigationRoute, _productDetailsRoute],
  );

  static final _bottomNavigationRoute = ShellRoute(
      routes: [
        _productListRoute,
        _shoppingCartRoute,
        _orderListRoute,
      ],
      builder: (context, state, child) => SafeArea(
            child: Scaffold(
              bottomNavigationBar: NavigationBar(
                labelBehavior:
                    NavigationDestinationLabelBehavior.onlyShowSelected,
                selectedIndex:
                    (state.fullPath == _PathConstants.shoppingCartPath)
                        ? 1
                        : (state.fullPath == _PathConstants.ordersListPath)
                            ? 2
                            : 0,
                onDestinationSelected: (index) => (index == 1)
                    ? context.go(_PathConstants.shoppingCartPath)
                    : (index == 2)
                        ? context.go(_PathConstants.ordersListPath)
                        : context.go(_PathConstants.productListPath),
                destinations: const [
                  NavigationDestination(icon: Icon(Icons.home), label: 'home'),
                  NavigationDestination(
                      icon: Icon(Icons.shopping_cart), label: 'cart'),
                  NavigationDestination(
                      icon: Icon(Icons.book), label: 'orders'),
                ],
              ),
              body: child,
            ),
          ));

  static final _productListRoute = GoRoute(
    path: _PathConstants.productListPath,
    builder: (context, state) => ProductListScreen(
      userRepository: _userRepository,
      productRepository: _productRepository,
      onAuthenticationError: (context) {},
      onProductSelected: (id) =>
          context.go(_PathConstants.productDetailsPath(productId: id)),
    ),
  );

  static final _productDetailsRoute = GoRoute(
      path: _PathConstants.productDetailsPath(),
      builder: (context, state) => ProductDetailsScreen(
            cartRepository: _cartRepository,
            productId:
                state.pathParameters[_PathConstants.productIdPathParamter]!,
            onAuthenticationError: () {},
            onBackButtonTap: () {
              context.go(_PathConstants.productListPath);
            },
            productRepository: _productRepository,
          ));

  static final _shoppingCartRoute = GoRoute(
      path: _PathConstants.shoppingCartPath,
      builder: (context, __) => CartScreen(
            orderRepository: _orderRepository,
            cartRepository: _cartRepository,
            userId: '1',
            onAuthenticationError: () {},
          ));

  static final _orderListRoute = GoRoute(
      path: _PathConstants.ordersListPath,
      builder: (_, __) => OrderListScreen(
            orderRepository: _orderRepository,
            onAuthenticationError: () {},
            userId: '',
          ));
}

abstract final class _PathConstants {
  const _PathConstants._();

  static const productIdPathParamter = 'productId';

  static String get rootPath => '/';

  static String get productListPath => '${rootPath}products';

  static String productDetailsPath({String? productId}) =>
      '$productListPath/${productId ?? ":$productIdPathParamter"}';

  static String get shoppingCartPath => '${rootPath}shoppings-cart';

  static String get ordersListPath => '${rootPath}orders';
}
