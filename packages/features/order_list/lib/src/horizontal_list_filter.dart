import 'package:component_library/component_library.dart';
import 'package:domain_models/domain_models.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class HorizontalListFilter extends StatelessWidget {
  const HorizontalListFilter({
    Key? key,
  }) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      scrollDirection: Axis.horizontal,
      child: Row(
          children: OrderStatus.values
              .map((status) => Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 4),
                    child: RoundedChoiceChip(
                      label: status.name,
                      isSelected: false,
                      onSelected: (d) {},
                    ),
                  ))
              .toList()),
    );
  }
}
