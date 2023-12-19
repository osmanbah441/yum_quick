import 'package:equatable/equatable.dart';

/// represents a registered user in the application.
class User extends Equatable {
  const User({
    required this.id,
    required this.cartId,
    required this.username,
    this.email,
    this.password,
  });

  final String id;
  final String cartId;
  final String username;
  final String? email;
  final String? password;

  @override
  List<Object?> get props => [id, username, email];
}
