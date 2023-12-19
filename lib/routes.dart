import 'package:cart_repository/cart_repository.dart';
import 'package:flutter/material.dart';
import 'package:go_router/go_router.dart';
import 'package:order_details/order_details.dart';
import 'package:order_list/order_list.dart';
import 'package:order_repository/order_repository.dart';
import 'package:product_details/product_details.dart';
import 'package:product_list/product_list.dart';
import 'package:product_repository/product_repository.dart';
import 'package:quick_api/quick_api.dart';
import 'package:shopping_cart/shopping_cart.dart';
import 'package:user_repository/user_repository.dart';

final _api = QuickApi();

final class AppRouter {
  static final _productRepository = ProductRepository(api: _api);
  static final _userRepository = UserRepository(api: _api);
  static final _cartRepository = CartRepository(api: _api);
  static final _orderRepository = OrderRepository(api: _api);

  static final router = GoRouter(
    initialLocation: _PathConstants.productListPath,
    routes: [
      _bottomNavigationRoute,
      _productDetailsRoute,
      _orderDetailsRoute,
    ],
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
                  NavigationDestination(
                      icon: Icon(Icons.travel_explore), label: 'explore'),
                  NavigationDestination(
                      icon: Icon(Icons.shopping_cart), label: 'cart'),
                  NavigationDestination(
                      icon: Icon(Icons.manage_history_outlined),
                      label: 'history'),
                ],
              ),
              body: child,
            ),
          ));

  static final _productListRoute = GoRoute(
    path: _PathConstants.productListPath,
    builder: (context, _) => ProductListScreen(
      userRepository: _userRepository,
      productRepository: _productRepository,
      onAuthenticationError: (context) {},
      onProductSelected: (id) =>
          context.go(_PathConstants.productDetailsPath(id)),
    ),
  );

  static final _productDetailsRoute = GoRoute(
      path: _PathConstants.productDetailsPath(),
      builder: (context, state) => ProductDetailsScreen(
            userRepository: _userRepository,
            cartRepository: _cartRepository,
            productRepository: _productRepository,
            onBackButtonTap: () => context.go(_PathConstants.productListPath),
            productId:
                state.pathParameters[_PathConstants.productIdPathParamter]!,
            onAuthenticationError: () {},
          ));

  static final _shoppingCartRoute = GoRoute(
      path: _PathConstants.shoppingCartPath,
      builder: (context, __) => CartScreen(
            userRepository: _userRepository,
            orderRepository: _orderRepository,
            cartRepository: _cartRepository,
            userId: '1',
            onAuthenticationError: () {},
          ));

  static final _orderListRoute = GoRoute(
    path: _PathConstants.ordersListPath,
    builder: (context, __) => OrderListScreen(
      userRepository: _userRepository,
      orderRepository: _orderRepository,
      onAuthenticationError: () {},
      userId: '',
      onOrderSelected: (id) => context.go(_PathConstants.orderDetailsPath(id)),
    ),
  );

  static final _orderDetailsRoute = GoRoute(
    path: _PathConstants.orderDetailsPath(),
    builder: (context, state) => OrderDetailsScreen(
      userRepository: _userRepository,
      orderRepository: _orderRepository,
      orderId:
          state.pathParameters[_PathConstants.orderIdPathParameter]!, // TODO:
      onBackButtonTap: () => context.go(_PathConstants.ordersListPath),
    ),
  );
}

abstract final class _PathConstants {
  const _PathConstants._();

  static const productIdPathParamter = 'productId';
  static const orderIdPathParameter = 'orderId';

  static String get rootPath => '/';

  static String get productListPath => '${rootPath}products';

  static String productDetailsPath([String? productId]) =>
      '$productListPath/${productId ?? ":$productIdPathParamter"}';

  static String get shoppingCartPath => '${rootPath}shoppings-cart';

  static String get ordersListPath => '${rootPath}orders';

  static String orderDetailsPath([String? orderId]) =>
      '$ordersListPath/${orderId ?? ":$orderIdPathParameter"}';
}
