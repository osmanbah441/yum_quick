import 'dart:async';

import 'package:bloc_concurrency/bloc_concurrency.dart';
import 'package:domain_models/domain_models.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:equatable/equatable.dart';
import 'package:product_repository/product_repository.dart';
import 'package:user_repository/user_repository.dart';
import 'package:rxdart/rxdart.dart';

part 'product_list_event.dart';
part 'product_list_state.dart';

final class ProductListBloc extends Bloc<ProductListEvent, ProductListState> {
  ProductListBloc(
      {required ProductRepository productRepository,
      required UserRepository userRepository})
      : _productRepository = productRepository,
        super(const ProductListState()) {
    _registerEventHandlers();

    _authChangesSubscription = userRepository.getUserStream().listen((user) {
      _authenticatedUsername = user?.username;
      add(const ProductListUsernameObtained());
    });
  }

  late final StreamSubscription _authChangesSubscription;
  String? _authenticatedUsername;

  final ProductRepository _productRepository;

  void _registerEventHandlers() => on<ProductListEvent>(
        (event, emitter) async => switch (event) {
          ProductListTagChanged() =>
            _handleProductListTagChanged(emitter, event),
          ProductListSearchTermChanged() =>
            _handleProductListSearchTermChanged(emitter, event),
          ProductListRefreshed() => _handleProductListRefreshed(emitter, event),
          ProductListNextPageRequested() =>
            _handleProductListNextPageRequested(emitter, event),
          ProductListFailedFetchRetried() =>
            _handleProductListFailedFetchRetried(emitter),
          ProductListUsernameObtained() =>
            _handleProductListUsernameObtained(emitter),
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
      final newPage = await _productRepository.getProductListPage(
        page: page,
        category: currentlyAppliedFilter is ProductListFilterByTag
            ? currentlyAppliedFilter.tag
            : null,
        searchTerm: currentlyAppliedFilter is ProductListFilterBySearchTerm
            ? currentlyAppliedFilter.searchTerm
            : '',
        userFavoritesOnly: isFilteringByFavorites && isUserSignedIn,
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
