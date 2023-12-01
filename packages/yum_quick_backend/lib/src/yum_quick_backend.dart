import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart' as authn;
import 'package:firebase_core/firebase_core.dart';
import 'package:domain_models/domain_models.dart';
import 'package:meta/meta.dart';

import 'firebase_options.dart';

// when true local emulator is use, which is good for testing
// set to false for production
@visibleForTesting
const kDebugMode = true;

final class YumQuickBackend {
  YumQuickBackend();

  static final _db = FirebaseFirestore.instance;
  DocumentSnapshot? _lastDocSnapshot;

  static Future<void> initialize() async {
    await Firebase.initializeApp(
      options: DefaultFirebaseOptions.currentPlatform,
    );

    if (kDebugMode) {
      try {
        FirebaseFirestore.instance.useFirestoreEmulator('localhost', 8080);
        await authn.FirebaseAuth.instance.useAuthEmulator('localhost', 9099);
      } catch (e) {
        rethrow;
      }
    }
  }

  void signIn(String email, String password) {}

  Future<ProductListPage> getProductListPage(
      {required int page,
      String searchTerm = '',
      String? tag,
      String? favoritedByUsername,
      int pageSize = 2}) async {
    var productQuery = _db.collection('products').orderBy('name');

    if (searchTerm.isNotEmpty) {
      searchTerm = searchTerm.toLowerCase();
      productQuery = productQuery
          .where('name', isGreaterThanOrEqualTo: searchTerm)
          .where('name', isLessThanOrEqualTo: searchTerm + '\uf8ff');
    } else if (tag != null && tag.isNotEmpty) {
      productQuery = productQuery.where('category', isEqualTo: tag);
    } else if (favoritedByUsername != null && favoritedByUsername.isNotEmpty) {
      // TODO: replace with favorited by user id;
      productQuery = productQuery.where('isFavorite', isEqualTo: true);
    }

    return await _fetchPaginatePage(page, productQuery, pageSize);
  }

  Future<ProductListPage> _fetchPaginatePage(
      int page, Query query, int pageSize) async {
    final isFirstPage = page == 1;
    if (isFirstPage) _lastDocSnapshot = null;

    if (_lastDocSnapshot != null) {
      query = query.startAfterDocument(_lastDocSnapshot!);
    }

    final snapshot = await query.limit(pageSize).get();
    final products = snapshot.docs
        .map((doc) =>
            Product.fromFirestore(doc.data() as Map<String, dynamic>, doc.id))
        .toList();

    _lastDocSnapshot = snapshot.docs.isNotEmpty ? snapshot.docs.last : null;
    return ProductListPage(
      productList: products,
      isLastPage: snapshot.docs.length < pageSize,
    );
  }

  favoriteProduct(String id) {}

  Stream<User?> getUser() {
    return Stream.value(User(email: '', username: 'osman'));
  }
}
