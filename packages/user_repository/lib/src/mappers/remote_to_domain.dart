import 'package:domain_models/domain_models.dart';
import 'package:quick_api/quick_api.dart';

extension UserRMtoDomain on UserRM {
  User get toDomain => User(
        id: id,
        cartId: cartId,
        username: username,
        email: email,
      );
}
