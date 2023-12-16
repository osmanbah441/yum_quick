import 'package:domain_models/domain_models.dart';

class CartRepository {
  int _idGenetor = 0;

  CartRepository();
  final List<CartItem> _cartItems =
      []; // Replace with your desired initial products

  Future<void> updateItemQuantity(String productId, int newQuantity) {
    final existingItem = _cartItems.firstWhere((p) => p.id == productId);
    existingItem.setQuantity(newQuantity);
    return Future
        .value(); // Replace with actual data persistence logic if needed
  }

  Cart getCart() {
    return Cart(userId: '1', id: 'id', cartItems: _cartItems, deliveryCost: 10);
  }

  Future<void> remove(String id) async =>
      _cartItems.removeWhere((item) => item.id == id);

  Future<void> addToCart(Product product) async {
    _cartItems.add(CartItem(id: '$_idGenetor', product: product));
    _idGenetor++;
  }

  Future<void> clearCart() async {
    _cartItems.clear();
  }
}
