import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quick_api/src/models/response/user_rm.dart';

final class UserRMFireStore extends UserRM {
  const UserRMFireStore({
    required super.id,
    required super.cartId,
    required super.username,
    required super.email,
  });

  factory UserRMFireStore.fromSnapshot(DocumentSnapshot snapshot) {
    Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
    return UserRMFireStore(
      id: snapshot.id,
      cartId: data['cartId'] ?? '',
      username: data['username'] ?? '',
      email: data['email'] ?? '',
    );
  }

  Map<String, dynamic> toFirestoreJson() {
    return {
      'id': id,
      'cartId': cartId,
      'username': username,
      'email': email,
    };
  }
}
