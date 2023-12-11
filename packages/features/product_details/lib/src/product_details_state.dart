part of 'product_details_cubit.dart';

sealed class ProductDetailsState extends Equatable {
  const ProductDetailsState();
}

class ProductDetailsInProgress extends ProductDetailsState {
  const ProductDetailsInProgress();

  @override
  List<Object?> get props => [];
}

class ProductDetailsSuccess extends ProductDetailsState {
  const ProductDetailsSuccess({
    required this.product,
    this.productUpdateError,
  });

  final Product product;
  final dynamic productUpdateError;

  @override
  List<Object?> get props => [
        product,
        productUpdateError,
      ];
}

class ProductDetailsFailure extends ProductDetailsState {
  const ProductDetailsFailure();

  @override
  List<Object?> get props => [];
}
