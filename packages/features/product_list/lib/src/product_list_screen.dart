import 'package:component_library/component_library.dart';
import 'package:domain_models/domain_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:infinite_scroll_pagination/infinite_scroll_pagination.dart';
import 'package:product_list/src/product_page_grid_view.dart';
import 'package:yum_quick_backend/yum_quick_backend.dart';

import 'filter_horizontal_list.dart';

import 'product_list_bloc.dart';

class ProductListScreen extends StatelessWidget {
  const ProductListScreen({
    super.key,
    required this.onAuthenticationError,
    required this.yumQuickBackend,
    required this.onProductSelected,
    this.onProfileAvaterTap,
    this.onCartIconTap,
  });

  final ProductSelected onProductSelected;
  final VoidCallback? onProfileAvaterTap;
  final VoidCallback? onCartIconTap;
  final YumQuickBackend yumQuickBackend;
  final void Function(BuildContext context) onAuthenticationError;

  @override
  Widget build(BuildContext context) {
    return BlocProvider<ProductListBloc>(
      create: (_) => ProductListBloc(
        yumQuickBackend: yumQuickBackend,
      ),
      child: ProductListView(
        onAuthenticationError: onAuthenticationError,
        onProductSelected: onProductSelected,
      ),
    );
  }
}

@visibleForTesting
class ProductListView extends StatefulWidget {
  const ProductListView({
    super.key,
    required this.onProductSelected,
    this.onProfileAvaterTap,
    this.onCartIconTap,
    required this.onAuthenticationError,
  });

  final ProductSelected onProductSelected;
  final VoidCallback? onProfileAvaterTap;
  final VoidCallback? onCartIconTap;
  final void Function(BuildContext context) onAuthenticationError;

  @override
  State<ProductListView> createState() => _ProductListViewState();
}

class _ProductListViewState extends State<ProductListView> {
  final PagingController<int, Product> _pagingController = PagingController(
    firstPageKey: 1,
  );

  final TextEditingController _searchBarController = TextEditingController();

  ProductListBloc get _bloc => context.read<ProductListBloc>();

  @override
  void initState() {
    _pagingController.addPageRequestListener((pageNumber) {
      if (pageNumber > 1) _bloc.add(ProductListNextPageRequested(pageNumber));
    });

    _searchBarController.addListener(() {
      _bloc.add(ProductListSearchTermChanged(_searchBarController.text));
    });

    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    return BlocListener<ProductListBloc, ProductListState>(
      listener: (context, state) {
        final searchBarText = _searchBarController.text;
        final isSearching = state.filter != null &&
            state.filter is ProductListFilterBySearchTerm;
        if (searchBarText.isNotEmpty && !isSearching) {
          _searchBarController.text = '';
        }

        if (state.refreshError != null) {
          ScaffoldMessenger.of(context).showSnackBar(
            const SnackBar(content: Text('refresh errror text message')),
          );
        } else if (state.favoriteToggleError != null) {
          final snackBar =
              state.favoriteToggleError is UserAuthenticationRequiredException
                  ? const AuthenticationRequiredErrorSnackBar()
                  : const GenericErrorSnackBar();

          ScaffoldMessenger.of(context)
            ..hideCurrentSnackBar()
            ..showSnackBar(snackBar);

          widget.onAuthenticationError(context);
        }

        _pagingController.value = state.toPagingState();
      },
      child: SafeArea(
        child: Scaffold(
          body: Column(
            children: [
              Padding(
                padding:
                    const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
                child: YummySearchBar(
                  controller: _searchBarController,
                  imageProvider: const AssetImage(
                    'assets/images/profile_1.jpg',
                    package: 'component_library',
                  ),
                  onCartIconTap: widget.onCartIconTap,
                  onProfileAvaterTap: widget.onProfileAvaterTap,
                ),
              ),
              const FilterHorizontalList(),
              Expanded(
                child: RefreshIndicator(
                    onRefresh: () {
                      _bloc.add(const ProductListRefreshed());

                      final stateChangeFuture = _bloc.stream.first;
                      return stateChangeFuture;
                    },
                    child: ProductPagedGridView(
                      pagingController: _pagingController,
                      onProductSelected: widget.onProductSelected,
                    )),
              ),
            ],
          ),
        ),
      ),
    );
  }

  @override
  void dispose() {
    _pagingController.dispose();
    _searchBarController.dispose();
    super.dispose();
  }
}

extension on ProductListState {
  PagingState<int, Product> toPagingState() {
    return PagingState(
      itemList: itemList,
      nextPageKey: nextPage,
      error: error,
    );
  }
}
