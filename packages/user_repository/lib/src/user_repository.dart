// Mock repository for User class
import 'package:domain_models/domain_models.dart';

class UserRepository {
  const UserRepository();
  // Simulated list of users (replace this with your actual data source)
  static List<User> _users = [
    User(
      id: '1',
      username: 'user1',
      email: 'user1@example.com',
      password: 'password1',
    ),
    User(
      id: '2',
      username: 'user2',
      email: 'user2@example.com',
      password: 'password2',
    ),
    // Add more mock users here
  ];

  Stream<User?> getUser() {
    return Stream.value(_users.first);
  }
}
