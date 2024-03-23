// Mock repository for User class
import 'package:api/api.dart';
import 'package:domain_models/domain_models.dart';
import './mappers/remote_to_domain.dart';

class UserRepository {
  const UserRepository({
    required Api api,
  }) : _api = api;

  final Api _api;

  Future<String?> getAccessToken() {
    return Future.value(null);
  }

  Stream<User?> getUserStream() =>
      _api.user.currentUser().map((user) => user?.toDomain);

  Future<User> register(String username, String email, String password) async {
    try {
      final user = await _api.user
          .createUserWithEmailAndPassword(username, email, password);
      return user.toDomain;
    } catch (e) {
      throw e;
    }
  }

  Future<User> login(String email, String password) async {
    try {
      final user = await _api.user.signInWithEmailAndPassword(email, password);
      return user.toDomain;
    } catch (e) {
      throw e;
    }
  }

  Future<void> logout() async {
    try {
      await _api.user.signOut();
    } catch (e) {
      throw e;
    }
  }
}
