import 'package:domain_models/domain_models.dart';
import 'package:equatable/equatable.dart';

class ProductListPage extends Equatable {
  const ProductListPage({
    required this.isLastPage,
    required this.productList,
  });

  final bool isLastPage;
  final List<Product> productList;

  @override
  List<Object?> get props => [
        isLastPage,
        productList,
      ];
}
