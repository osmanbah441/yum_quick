import 'package:domain_models/domain_models.dart';
import 'package:quick_api/quick_api.dart';

extension ProductCategorytoRemote on ProductCategory {
  ProductCategoryRM get toRemote => switch (this) {
        ProductCategory.shawarma => ProductCategoryRM.shawarma,
        ProductCategory.pizza => ProductCategoryRM.pizza,
        ProductCategory.burger => ProductCategoryRM.burger,
        ProductCategory.yogurt => ProductCategoryRM.yogurt,
      };
}
