import 'package:api/api.dart';
import 'package:domain_models/domain_models.dart';

extension UserRMtoDomain on UserRM {
  User get toDomain => User(
        id: id,
        cartId: cartId,
        username: username,
        email: email,
      );
}
