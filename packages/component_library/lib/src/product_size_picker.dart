import 'package:component_library/component_library.dart';
import 'package:flutter/material.dart';

class ProductSizePicker extends StatefulWidget {
  const ProductSizePicker({
    Key? key,
    required this.sizes,
    required this.onSizeSelected,
  }) : super(key: key);

  final List<String> sizes;
  final void Function(String) onSizeSelected;

  @override
  State<ProductSizePicker> createState() => _ProductSizePickerState();
}

class _ProductSizePickerState extends State<ProductSizePicker> {
  int _selectedSizeIndex = 0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Wrap(
        spacing: 10.0,
        children: List.generate(widget.sizes.length, (index) {
          return RoundedChoiceChip(
            label: widget.sizes[index],
            isSelected: _selectedSizeIndex == index,
            onSelected: (selected) {
              if (selected) {
                setState(() {
                  _selectedSizeIndex = index;
                });
                widget.onSizeSelected(widget.sizes[index]);
              }
            },
          );
        }),
      ),
    );
  }
}
