import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:quick_api/quick_api.dart';

class QuickApiFirestoreQueryBuilder {
  QuickApiFirestoreQueryBuilder()
      : _productCollection = FirebaseFirestore.instance.collection('products'),
        _userCollection = FirebaseFirestore.instance.collection('users'),
        _cartCollection = FirebaseFirestore.instance.collection('carts'),
        _orderCollection = FirebaseFirestore.instance.collection('orders');

  final CollectionReference _productCollection;
  final CollectionReference _userCollection;
  final CollectionReference _cartCollection;
  final CollectionReference _orderCollection;

  Query getProductListQuery({
    required String? category,
    required String searchTerm,
    required int pageSize,
    required DocumentSnapshot? lastDocument,
  }) {
    Query query = _productCollection;

    if (category != null && category.isNotEmpty) {
      query = query.where('category', isEqualTo: category);
    }

    if (searchTerm.isNotEmpty) {
      query = query
          .where('name', isGreaterThanOrEqualTo: searchTerm)
          .where('name', isLessThan: searchTerm + 'z');
    }

    if (lastDocument != null) {
      query = query.startAfterDocument(lastDocument);
    }

    return query.limit(pageSize);
  }

  // UserRM methods
  Query getUserById(String userId) {
    return _userCollection.doc(userId).collection('details');
  }

  Query getUsersByEmail(String email) {
    return _userCollection.where('email', isEqualTo: email);
  }

  // CartRM methods
  Query getCartById(String cartId) {
    return _cartCollection.doc(cartId).collection('items');
  }

  Query getCartByUserId(String userId) {
    return _cartCollection.where('userId', isEqualTo: userId);
  }

  // OrderRM methods
  Query getOrderListQueryByUser({
    required String userId,
    int pageSize = 10,
    DocumentSnapshot? lastDocument,
    OrderStatusRM? status,
  }) {
    Query query = _orderCollection.where('userId', isEqualTo: userId);

    if (status != null) {
      query = query.where('status', isEqualTo: status.toString());
    }

    if (lastDocument != null) {
      query = query.startAfterDocument(lastDocument);
    }

    return query.limit(pageSize);
  }
}
