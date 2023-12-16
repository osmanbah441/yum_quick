import 'package:equatable/equatable.dart';

/// represents a registered user in the application.
class User extends Equatable {
  const User({
    required this.id,
    required this.username,
    this.email,
    this.password,
    this.favorites = const {},
    this.location,
  });

  final String id;
  final String username;
  final String? email;
  final String? password;
  final Set<String>? favorites; // IDs the user has marked as favorites.
  final (double long, double lat)? location;

  @override
  List<Object?> get props => [id, username, email, location];
}
