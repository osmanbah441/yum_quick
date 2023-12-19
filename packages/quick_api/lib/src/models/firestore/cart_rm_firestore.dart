// import 'package:quick_api/quick_api.dart';
// import 'package:quick_api/src/models/firestore/product_rm_firestore.dart';

// class CartRMFirestore extends CartRM {
//   CartRMFirestore({
//     required String id,
//     required String userId,
//     required List<CartItemRM> items,
//     required double deliveryCost,
//   }) : super(
//           id: id,
//           userId: userId,
//           items: items,
//           deliveryCost: deliveryCost,
//         );

//   factory CartRMFirestore.fromSnapshot(Map<String, dynamic> data, {
//     required String CartId,
//     required String cartItemid
//   }) {
//     List<CartItemRM> cartItems = (data['items'] as List<dynamic>)
//         .map((item) => CartItemRMFirestore.fromFirestore(item, ))
//         .toList();

//     return CartRMFirestore(
//       id: snapshot.id,
//       userId: data['userId'] ?? '',
//       items: cartItems,
//       deliveryCost: data['deliveryCost'] ?? 0.0,
//     );
//   }

//   Map<String, dynamic> toFirestoreJson() => {
//         'userId': userId,
//         'items': items
//             .map((item) => (item as CartItemRMFirestore).toFirestoreJson())
//             .toList(), // Convert items to Firestore JSON
//         'deliveryCost': deliveryCost,
//       };
// }

// class CartItemRMFirestore extends CartItemRM {
//   CartItemRMFirestore({
//     super.id,
//     required super.product,
//     super.quantity = 0,
//   });

//   factory CartItemRMFirestore.fromFirestore(
//     Map<String, dynamic> data, {
//     required String cartItemId,
//     required String productId,
//   }) {
//     return CartItemRMFirestore(
//       id: data['id'],
//       product: ProductRMfirestore.fromSnapshot(data['product'], productId),
//       quantity: data['quantity'] ?? 0,
//     );
//   }

//   Map<String, dynamic> toFirestoreJson() => {
//         'id': id,
//         'product': (product as ProductRMfirestore).toFirestoreJson(),
//         'quantity': quantity,
//       };
// }
