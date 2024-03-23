import 'package:api/api.dart';

import 'utils/custom_http_client.dart';

final class UserEndpoint {
  const UserEndpoint(this._client);
  final CustomHttpClient _client;

  Stream<UserRM?> currentUser() {
    return Stream.value(
        UserRM(id: 'id', cartId: 'cartId', username: 'username'));
  }

  Future<UserRM> signInWithEmailAndPassword(String email, String password) {
    // TODO: implement login
    throw UnimplementedError();
  }

  Future<void> signOut() {
    // TODO: implement logout
    throw UnimplementedError();
  }

  Future<UserRM> createUserWithEmailAndPassword(
      String username, String email, String password) {
    // TODO: implement register
    throw UnimplementedError();
  }

  Future<void> sendPasswordResetEmail(String email) {
    throw UnimplementedError();
  }

  Future<void> deleteUser() {
    throw UnimplementedError();
  }
}
