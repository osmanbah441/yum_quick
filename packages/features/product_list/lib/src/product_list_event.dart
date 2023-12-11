part of 'product_list_bloc.dart';

sealed class ProductListEvent extends Equatable {
  const ProductListEvent();

  @override
  List<Object?> get props => [];
}

final class ProductListTagChanged extends ProductListEvent {
  const ProductListTagChanged(this.tag);

  final Tag? tag;

  @override
  List<Object?> get props => [tag];
}

final class ProductListSearchTermChanged extends ProductListEvent {
  const ProductListSearchTermChanged(this.searchTerm);

  final String searchTerm;

  @override
  List<Object?> get props => [searchTerm];
}

final class ProductListRefreshed extends ProductListEvent {
  const ProductListRefreshed();
}

final class ProductListNextPageRequested extends ProductListEvent {
  const ProductListNextPageRequested(this.pageNumber);

  final int pageNumber;

  @override
  List<Object?> get props => [pageNumber];
}

final class ProductListFilterByFavoritesToggled extends ProductListEvent {
  const ProductListFilterByFavoritesToggled();
}

final class ProductListFailedFetchRetried extends ProductListEvent {
  const ProductListFailedFetchRetried();
}

final class ProductListUsernameObtained extends ProductListEvent {
  const ProductListUsernameObtained();
}
