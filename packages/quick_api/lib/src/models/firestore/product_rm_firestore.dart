// import 'package:cloud_firestore/cloud_firestore.dart';
// import 'package:quick_api/src/models/response/response.dart';

// final class ProductRMfirestore extends ProductRM {
//   ProductRMfirestore({
//     required super.id,
//     required super.name,
//     required super.price,
//     required super.imageUrl,
//     required super.category,
//     required super.description,
//     required super.averageRating,
//     required super.inventory,
//     required super.isFavorite,
//   });

//   factory ProductRMfirestore.fromSnapshot(
//       Map<String, dynamic> data, String id) {
//     return ProductRMfirestore(
//       id: id,
//       name: data['name'] ?? '',
//       price: data['price'] ?? 0.0,
//       description: data['description'],
//       imageUrl: data['imageUrl'] ?? '',
//       category: _parseCategory(data['category']),
//       averageRating: data['averageRating'] ?? 0.0,
//       inventory: data['inventory'] ?? 0,
//       isFavorite: data['isFavorite'] ?? false,
//     );
//   }

//   Map<String, dynamic> toFirestoreJson() => {
//         'name': name,
//         'price': price,
//         'description': description,
//         'imageUrl': imageUrl,
//         'category': category.toString(),
//         'averageRating': averageRating,
//         'inventory': inventory,
//         'isFavorite': isFavorite,
//       };

//   static ProductCategoryRM? _parseCategory(String? category) {
//     switch (category) {
//       case 'shawarma':
//         return ProductCategoryRM.shawarma;
//       case 'pizza':
//         return ProductCategoryRM.pizza;
//       case 'burger':
//         return ProductCategoryRM.burger;
//       case 'yogurt':
//         return ProductCategoryRM.yogurt;
//       default:
//         return null;
//     }
//   }
// }
