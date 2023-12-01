import 'package:equatable/equatable.dart';

class User extends Equatable {
  const User({
    required this.username,
    required this.email,
  });

  final String username;
  final String email;

  factory User.fromJson(Map json) => User(
        username: json['username'] as String,
        email: json['email'] as String,
      );

  Map<String, dynamic> toJson() => {
        'username': username,
        'email': email,
      };

  @override
  List<Object?> get props => [username, email];
}
