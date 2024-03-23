import 'package:component_library/component_library.dart';
import 'package:domain_models/domain_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:repositories/repositories.dart';
import 'package:screens/src/product_details/product_details_cubit.dart';

class ProductDetailsScreen extends StatelessWidget {
  const ProductDetailsScreen({
    required this.productId,
    required this.onAuthenticationError,
    required this.productRepository,
    required this.cartRepository,
    required this.userRepository,
    super.key,
    required this.onBackButtonTap,
  });

  final String productId;
  final VoidCallback onAuthenticationError, onBackButtonTap;
  final ProductRepository productRepository;
  final CartRepository cartRepository;
  final UserRepository userRepository;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProductDetailsCubit>(
      create: (_) => ProductDetailsCubit(
          userRepository: userRepository,
          productId: productId,
          productRepository: productRepository,
          cartRepository: cartRepository),
      child: ProductDetailsView(
        onAuthenticationError: onAuthenticationError,
        onBackButtonTap: onBackButtonTap,
      ),
    );
  }
}

@visibleForTesting
class ProductDetailsView extends StatelessWidget {
  const ProductDetailsView({
    required this.onAuthenticationError,
    super.key,
    required this.onBackButtonTap,
  });

  final VoidCallback onAuthenticationError, onBackButtonTap;

  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ProductDetailsCubit, ProductDetailsState>(
      listener: (context, state) {
        final productUpdateError =
            state is ProductDetailsSuccess ? state.productUpdateError : null;
        final productCartError =
            state is ProductDetailsSuccess ? state.productCartError : null;

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

        if (productCartError != null) {
          final snackBar =
              productCartError is UserAuthenticationRequiredException
                  ? const AuthenticationRequiredErrorSnackBar()
                  : const GenericErrorSnackBar();

          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(snackBar);

          if (productCartError is UserAuthenticationRequiredException) {
            onAuthenticationError();
          }
        }
      },
      builder: (context, state) {
        return PopScope(
          canPop: false,
          onPopInvoked: (bool didPop) async {
            if (didPop) return;
            onBackButtonTap();
          },
          child: Scaffold(
            appBar: state is ProductDetailsSuccess
                ? AppBar(
                    leading: BackButton(onPressed: onBackButtonTap),
                    title: Text(state.product.name),
                    centerTitle: true,
                    actions: [
                      FavoriteIconButton(
                        isFavorite: state.product.isFavorite,
                        onTap: () {
                          final cubit = context.read<ProductDetailsCubit>();
                          final isFavorite = state.product.isFavorite;
                          isFavorite
                              ? cubit.unfavoriteProduct()
                              : cubit.favoriteProduct();
                        },
                      )
                    ],
                  )
                : null,
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
          ),
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
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Expanded(
          child: ListView(
            children: [
              Image.network(
                height: 240,
                product.imageUrl,
                fit: BoxFit.fitWidth,
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(product.price.toStringAsFixed(2)),
                    const UserReviewsWidget(averageRating: 4.0),
                  ],
                ),
              ),
              Padding(
                padding: const EdgeInsets.all(8.0),
                child: Text(
                  product.description ?? '',
                  maxLines: 3,
                ),
              ),
              ProductSizePicker(
                  sizes: const ['small', 'medium', 'large'],
                  onSizeSelected: (d) {}),
              const SizedBox(height: 16),
              const NutritionalInfo(nutritionalInfo: {
                "fat": "10.0",
                'protein': "10.30",
                'vitmin': "30.03",
              }),
            ],
          ),
        ),
        Padding(
          padding: const EdgeInsets.all(8.0),
          child: ExpandedElevatedButton(
            icon: const Icon(Icons.shopping_cart),
            label: 'Add to Cart',
            onTap: () {
              context.read<ProductDetailsCubit>().addProductToCart(product);
            },
          ),
        ),
      ],
    );
  }
}
