import 'package:component_library/component_library.dart';
import 'package:domain_models/domain_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:product_details/src/product_details_cubit.dart';
import 'package:yum_quick_backend/yum_quick_backend.dart';

typedef OnProductPoped = Function(Product?);

class ProductDetailsScreen extends StatelessWidget {
  const ProductDetailsScreen({
    required this.productId,
    required this.onAuthenticationError,
    required this.yumQuickBackend,
    super.key,
    required this.onProductPoped,
  });

  final String productId;
  final VoidCallback onAuthenticationError;
  final OnProductPoped onProductPoped;
  final YumQuickBackend yumQuickBackend;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProductDetailsCubit>(
      create: (_) => ProductDetailsCubit(
        productId: productId,
        productRepository: yumQuickBackend,
      ),
      child: ProductDetailsView(
        onAuthenticationError: onAuthenticationError,
        onProductPoped: onProductPoped,
      ),
    );
  }
}

@visibleForTesting
class ProductDetailsView extends StatelessWidget {
  const ProductDetailsView({
    required this.onAuthenticationError,
    super.key,
    required this.onProductPoped,
  });

  final VoidCallback onAuthenticationError;
  final OnProductPoped onProductPoped;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProductDetailsCubit, ProductDetailsState>(
      listener: (context, state) {
        final productUpdateError =
            state is ProductDetailsSuccess ? state.productUpdateError : null;
        if (productUpdateError != null) {
          final snackBar =
              productUpdateError is UserAuthenticationRequiredException
                  ? const AuthenticationRequiredErrorSnackBar()
                  : const GenericErrorSnackBar();

          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(snackBar);

          if (productUpdateError is UserAuthenticationRequiredException) {
            onAuthenticationError();
          }
        }
      },
      builder: (context, state) {
        final isSuccessState = state is ProductDetailsSuccess;
        return PopScope(
          canPop: false,
          onPopInvoked: (bool didPop) async {
            if (didPop) return;
            final displayedProduct = isSuccessState ? state.product : null;
            onProductPoped(displayedProduct);
          },
          child: Scaffold(
              body: SafeArea(
                  child: switch (state) {
                ProductDetailsInProgress() =>
                  const CenteredCircularProgressIndicator(),
                ProductDetailsSuccess() => _Product(product: state.product),
                ProductDetailsFailure() => ExceptionIndicator(
                    onTryAgain: () {
                      final cubit = context.read<ProductDetailsCubit>();
                      cubit.refetch();
                    },
                  ),
              }),
              floatingActionButtonLocation: isSuccessState
                  ? FloatingActionButtonLocation.centerFloat
                  : null,
              floatingActionButton: isSuccessState
                  ? FloatingActionButton.extended(
                      elevation: 2,
                      isExtended: true,
                      icon: const Icon(Icons.shopping_cart),
                      extendedTextStyle: Theme.of(context).textTheme.titleLarge,
                      onPressed: () {},
                      label: Row(
                        children: [
                          const SizedBox(width: 8),
                          const Text('Add to Cart'),
                          const SizedBox(width: 32),
                          Text('LE ${state.product.price}')
                        ],
                      ),
                    )
                  : null),
        );
      },
    );
  }
}

class _Product extends StatelessWidget {
  const _Product({
    required this.product,
    Key? key,
  }) : super(key: key);

  final Product product;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;

    return SingleChildScrollView(
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Image.asset(
            product.imageUrl,
            package: 'component_library',
            fit: BoxFit.fitWidth,
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                Text(
                  product.name,
                  style: textTheme.headlineSmall,
                ),
                FavoriteIconButton(
                  isFavorite: product.isFavorite,
                  onTap: () {},
                ),
              ],
            ),
          ),
          const UserReviewsWidget(averageRating: 4.0),
          Padding(
            padding: const EdgeInsets.all(8.0),
            child: Text(
              product.description,
              maxLines: 3,
            ),
          ),
          ProductSizePicker(
              sizes: ['small', 'medium', 'large'], onSizeSelected: (d) {}),
          NutritionalInfo(nutritionalInfo: {
            "fat": "10.0",
            'protein': "10.30",
            'vitmin': "30.03",
          }),
          const SizedBox(height: 56),
        ],
      ),
    );
  }
}
