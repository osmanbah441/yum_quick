import 'package:cart_repository/cart_repository.dart';
import 'package:domain_models/domain_models.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:product_repository/product_repository.dart';

part 'product_details_state.dart';

class ProductDetailsCubit extends Cubit<ProductDetailsState> {
  ProductDetailsCubit(
      {required this.productId,
      required ProductRepository productRepository,
      required CartRepository cartRepository})
      : _productRepository = productRepository,
        _cartRepository = cartRepository,
        super(const ProductDetailsInProgress()) {
    _fetchProductDetails();
  }

  final String productId;
  final ProductRepository _productRepository;
  final CartRepository _cartRepository;

  Future<void> _fetchProductDetails() async {
    try {
      final product = await _productRepository.getProductDetails(productId);
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
      () => _productRepository.favoriteProduct(productId),
    );
  }

  void unfavoriteProduct() async {
    await _executeProductUpdateOperation(
      () => _productRepository.unfavoriteQuote(productId),
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

  Future<void> addProductToCart(Product product) async {
    try {
      await _cartRepository.addToCart(product);
      emit(ProductDetailsSuccess(product: product));
    } catch (error) {
      final lastState = state;
      if (lastState is ProductDetailsSuccess) {
        emit(ProductDetailsSuccess(
          product: lastState.product,
          productCartError: error,
        ));
      }
    }
  }
}
