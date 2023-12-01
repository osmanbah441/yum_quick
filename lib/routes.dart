import 'package:go_router/go_router.dart';
import 'package:product_list/product_list.dart';
import 'package:yum_quick_backend/yum_quick_backend.dart';

final class _PathConstants {
  static const productList = '/product-list';
}

final class YumQuickRouter {
  static final _yumQuickBackend = YumQuickBackend();

  static final router = GoRouter(
    initialLocation: _PathConstants.productList,
    routes: [
      _home,
    ],
  );

  static final _home = GoRoute(
    path: _PathConstants.productList,
    builder: (context, state) => ProductListScreen(
      onAuthenticationError: (context) {},
      yumQuickBackend: _yumQuickBackend,
    ),
  );
}
