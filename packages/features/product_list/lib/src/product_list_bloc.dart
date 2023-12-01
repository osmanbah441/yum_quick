import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:domain_models/domain_models.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:rxdart/rxdart.dart';
import 'package:yum_quick_backend/yum_quick_backend.dart';

part 'product_list_event.dart';
part 'product_list_state.dart';

final class ProductListBloc extends Bloc<ProductListEvent, ProductListState> {
  ProductListBloc({
    required YumQuickBackend yumQuickBackend,
  })  : _yumQuickBackend = yumQuickBackend,
        super(const ProductListState()) {
    _registerEventHandlers();

    _authChangesSubscription = _yumQuickBackend.getUser().listen((user) {
      _authenticatedUsername = user?.username;
      add(const ProductListUsernameObtained());
    });
  }

  late final StreamSubscription _authChangesSubscription;
  String? _authenticatedUsername;

  final YumQuickBackend _yumQuickBackend;

  void _registerEventHandlers() => on<ProductListEvent>(
        (event, emitter) async => switch (event) {
          ProductListTagChanged() =>
            _handleProductListTagChanged(emitter, event),
          ProductListSearchTermChanged() =>
            _handleProductListSearchTermChanged(emitter, event),
          ProductListRefreshed() => _handleProductListRefreshed(emitter, event),
          ProductListNextPageRequested() =>
            _handleProductListNextPageRequested(emitter, event),
          ProductListItemFavoriteToggled() =>
            _handleProductListItemFavoriteToggled(emitter, event),
          ProductListFailedFetchRetried() =>
            _handleProductListFailedFetchRetried(emitter),
          ProductListUsernameObtained() =>
            _handleProductListUsernameObtained(emitter),
          ProductListItemUpdated() =>
            _handleProductListItemUpdated(emitter, event),
          ProductListFilterByFavoritesToggled() =>
            _handleProductListFilterByFavoritesToggled(emitter),
        },
        transformer: (eventStream, eventHandler) {
          final nonDebounceEventStream = eventStream.where(
            (event) => event is! ProductListSearchTermChanged,
          );

          final debounceEventStream = eventStream
              .whereType<ProductListSearchTermChanged>()
              .debounceTime(const Duration(seconds: 1))
              .where((event) {
            final previousFilter = state.filter;
            final previousSearchTerm =
                previousFilter is ProductListFilterBySearchTerm
                    ? previousFilter.searchTerm
                    : '';

            return event.searchTerm != previousSearchTerm;
          });

          final mergedEventStream = MergeStream([
            nonDebounceEventStream,
            debounceEventStream,
          ]);

          final restartableTransformer = restartable<ProductListEvent>();
          return restartableTransformer(mergedEventStream, eventHandler);
        },
      );

  Future<void> _handleProductListFailedFetchRetried(Emitter emitter) {
    // Clears out the error and puts the loading indicator back on the screen.
    emitter(state.copyWithNewError(null));

    final firstPageFetchStream = _fetchProductPage(
      1,
    );

    return emitter.onEach<ProductListState>(
      firstPageFetchStream.asStream(),
      onData: emitter,
    );
  }

  void _handleProductListItemUpdated(
    Emitter emitter,
    ProductListItemUpdated event,
  ) {
    // Replaces the updated Product in the current state and re-emits it.
    emitter(
      state.copyWithUpdatedProduct(
        event.updatedProduct,
      ),
    );
  }

  Future<void> _handleProductListUsernameObtained(Emitter emitter) {
    emitter(
      ProductListState(
        filter: state.filter,
      ),
    );

    final firstPageFetchStream = _fetchProductPage(
      1,
    );

    return emitter.onEach<ProductListState>(
      firstPageFetchStream.asStream(),
      onData: emitter,
    );
  }

  Future<void> _handleProductListTagChanged(
    Emitter emitter,
    ProductListTagChanged event,
  ) {
    emitter(
      ProductListState.loadingNewTag(event.tag),
    );

    final firstPageFetchStream = _fetchProductPage(
      1,
      // If the user is *deselecting* a tag, the `cachePreferably` fetch policy
      // will return you the cached Products. If the user is selecting a new tag
      // instead, the `cachePreferably` fetch policy won't find any cached
      // Products and will instead use the network.
    );

    return emitter.onEach<ProductListState>(
      firstPageFetchStream.asStream(),
      onData: emitter,
    );
  }

  Future<void> _handleProductListSearchTermChanged(
    Emitter emitter,
    ProductListSearchTermChanged event,
  ) {
    emitter(ProductListState.loadingNewSearchTerm(event.searchTerm));

    final firstPageFetchStream = _fetchProductPage(
      1,
      // If the user is *clearing out* the search bar, the `cachePreferably`
      // fetch policy will return you the cached Products. If the user is
      // entering a new search instead, the `cachePreferably` fetch policy
      // won't find any cached Products and will instead use the network.
    );

    return emitter.onEach<ProductListState>(
      firstPageFetchStream.asStream(),
      onData: emitter,
    );
  }

  Future<void> _handleProductListRefreshed(
    Emitter emitter,
    ProductListRefreshed event,
  ) {
    final firstPageFetchStream = _fetchProductPage(
      1,
      // Since the user is asking for a refresh, you don't want to get cached
      // Products, thus the `networkOnly` fetch policy makes the most sense.
      isRefresh: true,
    );

    return emitter.onEach<ProductListState>(
      firstPageFetchStream.asStream(),
      onData: emitter,
    );
  }

  Future<void> _handleProductListNextPageRequested(
    Emitter emitter,
    ProductListNextPageRequested event,
  ) {
    emitter(
      state.copyWithNewError(null),
    );

    final nextPageFetchStream = _fetchProductPage(
      event.pageNumber,
      // The `networkPreferably` fetch policy prioritizes fetching the new page
      // from the server, and, if it fails, try grabbing it from the cache.
    );

    return emitter.onEach<ProductListState>(
      nextPageFetchStream.asStream(),
      onData: emitter,
    );
  }

  Future<void> _handleProductListItemFavoriteToggled(
    Emitter emitter,
    ProductListItemFavoriteToggled event,
  ) async {
    try {
      // The `favoriteProduct()` and `unfavoriteProduct()` functions return you the
      // updated Product object.
      final updatedProduct = await (event is ProductListItemFavorited
          ? _yumQuickBackend.favoriteProduct(
              event.id,
            )
          : _yumQuickBackend.favoriteProduct(
              event.id,
            ));
      final isFilteringByFavorites =
          state.filter is ProductListFilterByFavorites;

      // If the user isn't filtering by favorites, you just replace the changed
      // Product on-screen.
      if (!isFilteringByFavorites) {
        emitter(
          state.copyWithUpdatedProduct(
            updatedProduct,
          ),
        );
      } else {
        // If the user *is* filtering by favorites, that means the user is
        // actually *removing* a Product from the list, so you refresh the entire
        // list to make sure you won't break the pagination.
        emitter(
          ProductListState(
            filter: state.filter,
          ),
        );

        final firstPageFetchStream = _fetchProductPage(
          1,
        );

        await emitter.onEach<ProductListState>(
          firstPageFetchStream.asStream(),
          onData: emitter,
        );
      }
    } catch (error) {
      // If an error happens trying to (un)favorite a Product you attach an error
      // to the current state which will result on the screen showing a snackbar
      // to the user and possibly taking him to the Sign In screen in case the
      // cause is the user being signed out.
      emitter(
        state.copyWithFavoriteToggleError(
          error,
        ),
      );
    }
  }

  Future<void> _handleProductListFilterByFavoritesToggled(
    Emitter emitter,
  ) {
    final isFilteringByFavorites =
        state.filter is! ProductListFilterByFavorites;

    emitter(
      ProductListState.loadingToggledFavoritesFilter(
        isFilteringByFavorites,
      ),
    );

    final firstPageFetchStream = _fetchProductPage(
      1,
      // If the user is *adding* the favorites filter, you use the *cacheAndNetwork*
      // fetch policy to show the cached data first followed by the updated list
      // from the server.
      // If the user is *removing* the favorites filter, you simply show the
      // cached data they were seeing before applying the filter.
    );

    return emitter.onEach<ProductListState>(
      firstPageFetchStream.asStream(),
      onData: emitter,
    );
  }

  Future<ProductListState> _fetchProductPage(
    int page, {
    bool isRefresh = false,
  }) async {
    final currentlyAppliedFilter = state.filter;
    final isFilteringByFavorites =
        currentlyAppliedFilter is ProductListFilterByFavorites;
    final isUserSignedIn = _authenticatedUsername != null;
    if (isFilteringByFavorites && !isUserSignedIn) {
      return ProductListState.noItemsFound(currentlyAppliedFilter);
    }

    try {
      final newPage = await _yumQuickBackend.getProductListPage(
        page: page,
        tag: currentlyAppliedFilter is ProductListFilterByTag
            ? currentlyAppliedFilter.tag.name
            : null,
        searchTerm: currentlyAppliedFilter is ProductListFilterBySearchTerm
            ? currentlyAppliedFilter.searchTerm
            : '',
        favoritedByUsername:
            currentlyAppliedFilter is ProductListFilterByFavorites
                ? _authenticatedUsername
                : null,
      );

      final newItemList = newPage.productList;
      final oldItemList = state.itemList ?? [];
      final completeItemList =
          isRefresh || page == 1 ? newItemList : (oldItemList + newItemList);

      final nextPage = newPage.isLastPage ? null : page + 1;

      return ProductListState.success(
        nextPage: nextPage,
        itemList: completeItemList,
        filter: currentlyAppliedFilter,
        isRefresh: isRefresh,
      );
    } catch (error) {
      if (error is EmptySearchResultException) {
        return ProductListState.noItemsFound(
          currentlyAppliedFilter,
        );
      }

      if (isRefresh) {
        return state.copyWithNewRefreshError(
          error,
        );
      } else {
        return state.copyWithNewError(
          error,
        );
      }
    }
  }

  @override
  Future<void> close() {
    _authChangesSubscription.cancel();
    return super.close();
  }
}
