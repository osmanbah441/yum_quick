import 'dart:async';

import 'package:domain_models/domain_models.dart';
import 'package:equatable/equatable.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:repositories/repositories.dart';

part 'product_details_state.dart';

class ProductDetailsCubit extends Cubit<ProductDetailsState> {
  ProductDetailsCubit({
    required this.productId,
    required ProductRepository productRepository,
    required CartRepository cartRepository,
    required UserRepository userRepository,
  })  : _productRepository = productRepository,
        _cartRepository = cartRepository,
        super(const ProductDetailsInProgress()) {
    _authChangesSubscription = userRepository.getUserStream().listen((user) {
      _authenticatedUserId = user?.id;
      _authenticatedUserCartId = user?.cartId;

      _fetchProductDetails();
    });
  }

  late final StreamSubscription _authChangesSubscription;
  String? _authenticatedUserId, _authenticatedUserCartId;

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
    Future<Product> Function() updateProduct,
  ) async {
    try {
      final updatedQuote = await updateProduct();
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
      final isUserAuthenticatedAndOwnsCart =
          _authenticatedUserCartId != null && _authenticatedUserId != null;

      if (!isUserAuthenticatedAndOwnsCart) {
        throw const UserAuthenticationRequiredException();
      }

      await _cartRepository.addCartItem(_authenticatedUserCartId!, product);
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

  @override
  Future<void> close() {
    _authChangesSubscription.cancel();
    return super.close();
  }
}
