class UserRM {
  const UserRM({
    required this.id,
    required this.cartId,
    required this.username,
    this.email,
  });

  final String id;
  final String cartId;
  final String username;
  final String? email;
}
