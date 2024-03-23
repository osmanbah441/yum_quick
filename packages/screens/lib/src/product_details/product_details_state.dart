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
    this.productCartError,
  });

  final Product product;
  final dynamic productUpdateError;
  final dynamic productCartError;

  @override
  List<Object?> get props => [
        product,
        productUpdateError,
        productCartError,
      ];
}

class ProductDetailsFailure extends ProductDetailsState {
  const ProductDetailsFailure();

  @override
  List<Object?> get props => [];
}
