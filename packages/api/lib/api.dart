import 'package:api/src/utils/custom_http_client.dart';

import 'src/cart_endpoint.dart';
import 'src/order_endpoint.dart';
import 'src/user_endpoint.dart';
import 'src/product_endpoint.dart';

export 'src/models/models.dart';

final class Api {
  Api();

  late final _client = CustomHttpClient();
  late final UserEndpoint user = UserEndpoint(_client);
  late final ProductEndpoint product = ProductEndpoint(_client);
  late final CartEndpoint cart = CartEndpoint(_client);
  late final OrderEndpoint order = OrderEndpoint(_client);

  void close() => _client.close();
}
