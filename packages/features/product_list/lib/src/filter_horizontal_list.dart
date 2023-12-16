import 'package:component_library/component_library.dart';
import 'package:domain_models/domain_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:product_list/src/product_list_bloc.dart';

class FilterHorizontalList extends StatelessWidget {
  const FilterHorizontalList({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      padding: const EdgeInsets.symmetric(vertical: 8),
      child: Row(children: [
        const _FavoritesChip(),
        ...Category.values.map((tag) => _TagChip(tag: tag)).toList(),
      ]),
    );
  }
}

class _FavoritesChip extends StatelessWidget {
  const _FavoritesChip({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 8, left: 8),
      child: BlocSelector<ProductListBloc, ProductListState, bool>(
        selector: (state) {
          final isFilteringByFavorites =
              state.filter is ProductListFilterByFavorites;
          return isFilteringByFavorites;
        },
        builder: (context, isFavoritesOnly) {
          return RoundedChoiceChip(
            showCheckmark: false,
            label: 'favorites',
            avatar: Icon(
              isFavoritesOnly ? Icons.favorite : Icons.favorite_border_outlined,
              color: isFavoritesOnly ? Colors.red : Colors.black,
            ),
            isSelected: isFavoritesOnly,
            onSelected: (isSelected) {
              _releaseFocus(context);
              final bloc = context.read<ProductListBloc>();
              bloc.add(
                const ProductListFilterByFavoritesToggled(),
              );
            },
          );
        },
      ),
    );
  }
}

class _TagChip extends StatelessWidget {
  const _TagChip({
    required this.tag,
    Key? key,
  }) : super(key: key);

  final Category tag;

  @override
  Widget build(BuildContext context) {
    final isLastTag = Category.values.last == tag;
    return Padding(
      padding: EdgeInsets.only(
        right: isLastTag ? 8 : 4,
        left: 4,
      ),
      child: BlocSelector<ProductListBloc, ProductListState, Category?>(
        selector: (state) {
          final filter = state.filter;
          final selectedTag =
              filter is ProductListFilterByTag ? filter.tag : null;
          return selectedTag;
        },
        builder: (context, selectedTag) {
          final isSelected = selectedTag == tag;
          return RoundedChoiceChip(
            label: tag.toLocalizedString(context),
            isSelected: isSelected,
            onSelected: (isSelected) {
              _releaseFocus(context);
              final bloc = context.read<ProductListBloc>();
              bloc.add(
                ProductListTagChanged(isSelected ? tag : null),
              );
            },
          );
        },
      ),
    );
  }
}

void _releaseFocus(BuildContext context) {
  FocusScope.of(context).unfocus();
}

extension on Category {
  String toLocalizedString(BuildContext context) {
    switch (this) {
      case Category.burger:
        return Category.burger.name;
      case Category.pizza:
        return Category.pizza.name;
      case Category.shawarma:
        return Category.shawarma.name;
      case Category.yogurt:
        return Category.yogurt.name;
    }
  }
}
