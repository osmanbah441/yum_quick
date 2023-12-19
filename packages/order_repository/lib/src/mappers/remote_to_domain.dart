import 'package:domain_models/domain_models.dart';
import 'package:quick_api/quick_api.dart';

extension OrderListPageRMtoDomain on OrderListPageRM {
  OrderListPage get toDomain => OrderListPage(
        isLastPage: isLastPage,
        orderList: orderList.map((list) => list.toDomain).toList(),
      );
}

extension OrderRMtoDomain on OrderRM {
  Order get toDomain => Order(
        id: id,
        userId: userId,
        deliveryDate: deliveryDate,
        totalPrice: totalPrice,
        quantity: quantity,
        items: items.map((item) => item.toDomain).toList(),
      );
}

extension CartItemRMtoDomain on CartItemRM {
  CartItem get toDomain => CartItem(
        id: id,
        product: product.toDomain,
        quantity: quantity,
        totalPrice: totalPrice,
      );
}

extension ProductRMtoDomain on ProductRM {
  Product get toDomain => Product(
        id: id,
        name: name,
        price: price,
        averageRating: averageRating,
        category: category?.toDomain,
        description: description,
        imageUrl: imageUrl,
        inventory: inventory,
        isFavorite: isFavorite,
      );
}

extension ProductCategoryRMtoDomain on ProductCategoryRM {
  ProductCategory get toDomain => switch (this) {
        ProductCategoryRM.shawarma => ProductCategory.shawarma,
        ProductCategoryRM.pizza => ProductCategory.pizza,
        ProductCategoryRM.burger => ProductCategory.burger,
        ProductCategoryRM.yogurt => ProductCategory.yogurt,
      };
}
