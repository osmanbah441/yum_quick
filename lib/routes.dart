import 'package:go_router/go_router.dart';
import 'package:product_details/product_details.dart';
import 'package:product_list/product_list.dart';
import 'package:yum_quick_backend/yum_quick_backend.dart';

final class YumQuickRouter {
  static final _yumQuickBackend = YumQuickBackend();

  static final router = GoRouter(
    debugLogDiagnostics: true,
    initialLocation: _PathConstants.productListPath,
    routes: [
      _productListRoute,
      _productDetailsRoute,
    ],
  );

  static final _productListRoute = GoRoute(
    path: _PathConstants.productListPath,
    builder: (context, state) => ProductListScreen(
      onAuthenticationError: (context) {},
      yumQuickBackend: _yumQuickBackend,
      onProductSelected: (id) async {
        context.go(_PathConstants.productDetailsPath(productId: id));
        return null;
      },
    ),
  );

  static final _productDetailsRoute = GoRoute(
      path: _PathConstants.productDetailsPath(),
      builder: (context, state) => ProductDetailsScreen(
            productId:
                state.pathParameters[_PathConstants.productIdPathParamter]!,
            onAuthenticationError: () {},
            onProductPoped: (product) {
              context.go(_PathConstants.productListPath);
            },
            yumQuickBackend: _yumQuickBackend,
          ));
}

final class _PathConstants {
  const _PathConstants._();

  static const productIdPathParamter = 'productId';

  static String get rootPath => '/';

  static String get productListPath => '${rootPath}products';

  static String productDetailsPath({String? productId}) =>
      '$productListPath/${productId ?? ":$productIdPathParamter"}';
}
