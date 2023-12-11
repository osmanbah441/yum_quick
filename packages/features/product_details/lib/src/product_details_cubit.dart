import 'package:domain_models/domain_models.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:yum_quick_backend/yum_quick_backend.dart';

part 'product_details_state.dart';

class ProductDetailsCubit extends Cubit<ProductDetailsState> {
  ProductDetailsCubit({
    required this.productId,
    required YumQuickBackend productRepository,
  })  : _yumQuickBackend = productRepository,
        super(const ProductDetailsInProgress()) {
    _fetchProductDetails();
  }

  final String productId;
  final YumQuickBackend _yumQuickBackend;

  Future<void> _fetchProductDetails() async {
    try {
      final product = await _yumQuickBackend.getProductDetails(productId);
      emit(ProductDetailsSuccess(product: product));
    } catch (error) {
      emit(const ProductDetailsFailure());
    }
  }

  Future<void> refetch() async {
    emit(const ProductDetailsInProgress());

    _fetchProductDetails();
  }

  void favoriteProduct() async {
    await _executeProductUpdateOperation(
      () => _yumQuickBackend.favoriteProduct(productId),
    );
  }

  void unfavoriteProduct() async {
    await _executeProductUpdateOperation(
      () => _yumQuickBackend.unfavoriteQuote(productId),
    );
  }

  Future<void> _executeProductUpdateOperation(
    Future<Product> Function() updateQuote,
  ) async {
    try {
      final updatedQuote = await updateQuote();
      emit(
        ProductDetailsSuccess(product: updatedQuote),
      );
    } catch (error) {
      final lastState = state;
      if (lastState is ProductDetailsSuccess) {
        emit(
          ProductDetailsSuccess(
            product: lastState.product,
            productUpdateError: error,
          ),
        );
      }
    }
  }
}
