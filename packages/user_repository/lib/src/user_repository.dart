// Mock repository for User class
import 'package:domain_models/domain_models.dart';
import 'package:quick_api/quick_api.dart';
import 'package:user_repository/src/mappers/remote_to_domain.dart';

class UserRepository {
  const UserRepository({
    required QuickApi api,
  }) : _api = api;

  final QuickApi _api;

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
