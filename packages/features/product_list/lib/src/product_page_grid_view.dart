import 'dart:math';

import 'package:component_library/component_library.dart';
import 'package:domain_models/domain_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:product_list/src/product_list_bloc.dart';

class ProductPagedGridView extends StatelessWidget {
  const ProductPagedGridView({
    super.key,
    required this.pagingController,
    required this.onProductSelected,
  });

  final PagingController<int, Product> pagingController;
  final ProductSelected onProductSelected;

  @override
  Widget build(BuildContext context) => LayoutBuilder(
        builder: (context, constraints) {
          final bloc = context.read<ProductListBloc>();

          int gridColumnCount = constraints.maxWidth ~/ 150;
          gridColumnCount = max(1, min(gridColumnCount, 3));

          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            // For a deep dive on how the pagination works, refer to: https://www.raywenderlich.com/14214369-infinite-scrolling-pagination-in-flutter
            child: PagedMasonryGridView.count(
                pagingController: pagingController,
                builderDelegate: PagedChildBuilderDelegate<Product>(
                  itemBuilder: (context, product, index) {
                    return ProductCard(
                      product: product,
                      onTap: () => onProductSelected(product.id!),
                    );
                  },
                  firstPageErrorIndicatorBuilder: (context) {
                    return ExceptionIndicator(
                      onTryAgain: () {
                        bloc.add(const ProductListFailedFetchRetried());
                      },
                    );
                  },
                ),
                crossAxisCount: gridColumnCount,
                crossAxisSpacing: 4,
                mainAxisSpacing: 4),
          );
        },
      );
}
