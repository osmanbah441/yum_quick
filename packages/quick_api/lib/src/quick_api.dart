// import 'package:quick_api/quick_api.dart';

// class QuickApiImp implements QuickApi {
//   const QuickApiImp();

//   Future<ProductListPageRM> getProductListPageRM({
//     required int page,
//     String? category,
//     String searchTerm = '',
//     String? favoritedByUsername,
//   }) async {
//     await Future.delayed(const Duration(seconds: 1));
//     List<ProductRM> products = [];
//     final isFilteringByCategory = category != null &&
//         category.isNotEmpty &&
//         searchTerm.isEmpty &&
//         favoritedByUsername == null;

//     final isSearching = category == null &&
//         favoritedByUsername == null &&
//         searchTerm.isNotEmpty;

//     final isFavorited =
//         favoritedByUsername != null && category == null && searchTerm.isEmpty;

//     if (isFilteringByCategory) {
//       products = _productList
//           .where((product) => product.category.name == category)
//           .toList();
//     } else if (isSearching) {
//       _productList.forEach((p) {
//         p.name.toLowerCase().contains(searchTerm.toLowerCase());
//         products.add(p);
//       });
//     } else if (isFavorited) {
//       products = _productList.where((product) => product.isFavorite).toList();
//     } else {
//       products = _productList;
//     }

//     return ProductListPageRM(isLastPage: true, productList: products);
//   }

//   Future<ProductRM> getProductDetails(String productId) async {
//     await Future.delayed(const Duration(seconds: 1));

//     return _productList.firstWhere((product) => product.id == productId);
//   }

//   Future<ProductRM> favoriteProduct(String productId) async {
//     final product = await getProductDetails(productId);

//     final newProduct = product.copywith(isFavorite: true);

//     _productList.remove(product);
//     _productList.add(newProduct);
//     return newProduct;
//   }

//   Future<ProductRM> unfavoriteQuote(String productId) async {
//     final product = await getProductDetails(productId);

//     final newProduct = product.copywith(isFavorite: false);

//     _productList.remove(product);
//     _productList.add(newProduct);

//     return newProduct;
//   }

//   Future<CartRM> getUserCartById(String cartId, String userId) async {
//     return _carts
//         .firstWhere((cart) => cart.id == cartId && cart.userId == userId);
//   }

//   Future<void> addCartItem(String cartId, ProductRM product) async {
//     final cartitems = _carts.firstWhere((c) => c.id == cartId).items;

//     final cartItem = CartItemRM(
//       product: product,
//       id: 'cartitem${_genCartId.toString()}',
//     );

//     _genCartId++;

//     cartitems.add(cartItem);
//   }

//   Future<void> updateCartItemQuantity(
//     String cartId,
//     String cartItemId,
//     int newQuantity,
//   ) async {
//     final cart = _carts.firstWhere((c) => c.id == cartId);
//     final cartItem = cart.items.firstWhere((item) => item.id == cartItemId);
//     cartItem.setQuantity(newQuantity);
//   }

//   Future<void> removeCartItem(String cartId, String cartItemId) async {
//     final cart = _carts.firstWhere((c) => c.id == cartId);
//     cart.items.removeWhere((item) => item.id == cartItemId);
//   }

//   Future<void> clearCart(String cartId) async {
//     final cart = _carts.firstWhere((c) => c.id == cartId);

//     cart.items.clear();
//   }

//   Future<OrderListPageRM> getOrderListPageByUser(
//     String userId, {
//     required int page,
//     OrderStatusRM? status,
//   }) async {
//     final orders = _orders.where((order) => order.userId == userId);
//     print(orders.length);

//     switch (status) {
//       case OrderStatusRM.pending:
//         final pendingOrder = orders
//             .where((order) => order.status == OrderStatusRM.pending)
//             .toList();
//         return OrderListPageRM(isLastPage: true, orderList: pendingOrder);

//       case OrderStatusRM.ongoing:
//         final onGoingOrder = orders
//             .where((order) => order.status == OrderStatusRM.ongoing)
//             .toList();
//         return OrderListPageRM(isLastPage: true, orderList: onGoingOrder);

//       case OrderStatusRM.completed:
//         final completedOrder = orders
//             .where((order) => order.status == OrderStatusRM.completed)
//             .toList();
//         return OrderListPageRM(isLastPage: true, orderList: completedOrder);

//       case OrderStatusRM.cancelled:
//         final cancelledOrders = orders
//             .where((order) => order.status == OrderStatusRM.cancelled)
//             .toList();
//         return OrderListPageRM(isLastPage: true, orderList: cancelledOrders);

//       case null:
//         return OrderListPageRM(isLastPage: true, orderList: orders.toList());
//     }
//   }

//   Future<void> placeOrderByUser(String userId, CartRM cart) async {
//     final newOrder = OrderRM(
//       id: 'orderid${_genOderId.toString()}',
//       userId: userId,
//       deliveryDate: DateTime.now(),
//       totalPrice: cart.total,
//       quantity: cart.quantity,
//       items: cart.items,
//     );

//     _genOderId++;

//     _orders.add(newOrder);
//   }

//   Future<OrderRM> getUserOrderById(String orderId, String userId) async {
//     final order = _orders
//         .firstWhere((order) => order.id == orderId && order.userId == userId);

//     return order;
//   }

//   @override
//   Stream<UserRM> getUserStream() {
//     // TODO: implement getUserStream
//     throw UnimplementedError();
//   }

//   @override
//   Future<UserRM> login(String email, String password) {
//     // TODO: implement login
//     throw UnimplementedError();
//   }

//   @override
//   Future<void> logout() {
//     // TODO: implement logout
//     throw UnimplementedError();
//   }

//   @override
//   Future<UserRM> register(String username, String email, String password) {
//     // TODO: implement register
//     throw UnimplementedError();
//   }
// }

// int _genOderId = 0;

// int _genCartId = 0;

// final _orders = <OrderRM>[];
// final _carts = [
//   CartRM(
//     id: 'cartid0',
//     userId: 'user0',
//     items: [],
//     deliveryCost: 10,
//   )
// ];

// final _productList = [
//   // Shawarma
//   ProductRM(
//     id: 'shawarma1',
//     name: 'Classic Beef Shawarma',
//     price: 8.99,
//     description:
//         'Thinly sliced marinated beef wrapped in warm pita bread with tahini sauce, onions, tomatoes, and parsley.',
//     imageUrl: 'https://via.placeholder.com/200',
//     category: ProductCategoryRM.shawarma,
//     inventory: 20,
//     averageRating: 4.2,
//     isFavorite: false,
//   ),
//   ProductRM(
//     id: 'shawarma2',
//     name: 'Chicken Shawarma Platter',
//     price: 12.99,
//     description:
//         'Marinated chicken shawarma served with rice, hummus, baba ghanoush, pita bread, and salad.',
//     imageUrl: 'https://via.placeholder.com/200',
//     category: ProductCategoryRM.shawarma,
//     inventory: 15,
//     averageRating: 4.5,
//     isFavorite: true,
//   ),

//   // Pizza
//   ProductRM(
//     id: 'pizza1',
//     name: 'Margherita Pizza',
//     price: 10.99,
//     description:
//         'Classic pizza with tomato sauce, mozzarella cheese, fresh basil, and olive oil.',
//     imageUrl: 'https://via.placeholder.com/200',
//     category: ProductCategoryRM.pizza,
//     inventory: 30,
//     averageRating: 4.0,
//     isFavorite: false,
//   ),
//   ProductRM(
//     id: 'pizza2',
//     name: 'Hawaiian Pizza',
//     price: 11.99,
//     description:
//         'Pizza with tomato sauce, mozzarella cheese, ham, pineapple, and red onion.',
//     imageUrl: 'https://via.placeholder.com/200',
//     category: ProductCategoryRM.pizza,
//     inventory: 25,
//     averageRating: 3.8,
//     isFavorite: false,
//   ),

//   // Burger
//   ProductRM(
//     id: 'burger1',
//     name: 'Cheeseburger',
//     price: 7.99,
//     description:
//         'Classic beef burger with cheddar cheese, lettuce, tomato, onion, and pickles on a sesame seed bun.',
//     imageUrl: 'https://via.placeholder.com/200',
//     category: ProductCategoryRM.burger,
//     inventory: 40,
//     averageRating: 4.3,
//     isFavorite: true,
//   ),
//   ProductRM(
//     id: 'burger2',
//     name: 'Bacon Cheeseburger',
//     price: 8.99,
//     description: 'Cheeseburger with extra crispy bacon.',
//     imageUrl: 'https://via.placeholder.com/200',
//     category: ProductCategoryRM.burger,
//     inventory: 35,
//     averageRating: 4.4,
//     isFavorite: false,
//   ),

//   // Yogurt
//   ProductRM(
//     id: 'yogurt1',
//     name: 'Mango Lassi',
//     price: 4.99,
//     description: 'Refreshing blend of yogurt, mango, and spices.',
//     imageUrl: 'https://via.placeholder.com/200',
//     category: ProductCategoryRM.yogurt,
//     inventory: 50,
//     averageRating: 4.8,
//     isFavorite: false,
//   ),
//   ProductRM(
//     id: 'yogurt2',
//     name: 'Honeyed Greek Yogurt with Berries',
//     price: 5.99,
//     description: 'Greek yogurt topped with honey and fresh berries.',
//     imageUrl: 'https://via.placeholder.com/200',
//     category: ProductCategoryRM.yogurt,
//     inventory: 45,
//     averageRating: 4.7,
//     isFavorite: true,
//   ),
// ];
