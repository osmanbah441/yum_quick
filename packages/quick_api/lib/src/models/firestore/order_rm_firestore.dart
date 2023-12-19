// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:quick_api/src/models/response/response.dart';

// final class OrderRMfirestore extends OrderRM {
//   OrderRMfirestore({
//     required super.id,
//     required super.userId,
//     required super.deliveryDate,
//     required super.totalPrice,
//     required super.quantity,
//     required super.items,
//     required super.status,
//   });

//   factory OrderRMfirestore.fromSnapshot(
//       DocumentSnapshot<Map<String, dynamic>> snapshot) {
//     Map<String, dynamic> data = snapshot.data() as Map<String, dynamic>;
//     return OrderRMfirestore(
//       id: snapshot.id,
//       userId: data['userId'] ?? '',
//       deliveryDate: (data['deliveryDate'] as Timestamp).toDate(),
//       totalPrice: data['totalPrice'] ?? 0.0,
//       quantity: data['quantity'] ?? 0,
//       items: (data['items'] as List<dynamic>)
//           .map((item) => item.toString())
//           .toList(),
//       status: _parseStatus(data['status']),
//     );
//   }

//   Map<String, dynamic> toFirestoreJson() => {
//         'userId': userId,
//         'deliveryDate': deliveryDate,
//         'totalPrice': totalPrice,
//         'quantity': quantity,
//         'items': items,
//         'status': status.name,
//       };

//   static OrderStatusRM? _parseStatus(String? status) {
//     switch (status) {
//       case 'pending':
//         return OrderStatusRM.pending;
//       case 'completed':
//         return OrderStatusRM.completed;
//       case 'cancelled':
//         return OrderStatusRM.cancelled;
//       case 'ongoing':
//         return OrderStatusRM.ongoing;
//       default:
//         return null;
//     }
//   }
// }
