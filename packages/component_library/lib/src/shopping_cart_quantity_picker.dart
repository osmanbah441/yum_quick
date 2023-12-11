import 'package:flutter/material.dart';

class ShoppingCartQuantityPicker extends StatefulWidget {
  final int initialQuantity;
  final int minimumQuantity;
  final int maximumQuantity;
  final void Function(int newQuantity) onQuantityChanged;

  const ShoppingCartQuantityPicker({
    Key? key,
    required this.initialQuantity,
    required this.minimumQuantity,
    required this.maximumQuantity,
    required this.onQuantityChanged,
  }) : super(key: key);

  @override
  State<ShoppingCartQuantityPicker> createState() =>
      _ShoppingCartQuantityPickerState();
}

class _ShoppingCartQuantityPickerState
    extends State<ShoppingCartQuantityPicker> {
  int _currentQuantity = 0;

  @override
  void initState() {
    super.initState();
    _currentQuantity = widget.initialQuantity;
  }

  void _incrementQuantity() {
    if (_currentQuantity < widget.maximumQuantity) {
      setState(() {
        _currentQuantity++;
      });
      widget.onQuantityChanged(_currentQuantity);
    }
  }

  void _decrementQuantity() {
    if (_currentQuantity > widget.minimumQuantity) {
      setState(() {
        _currentQuantity--;
      });
      widget.onQuantityChanged(_currentQuantity);
    }
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 40,
      width: 120,
      decoration: BoxDecoration(
        gradient: const LinearGradient(
          colors: [
            Colors.blueAccent,
            Colors.deepPurpleAccent,
            Colors.redAccent
          ],
          begin: Alignment.topLeft,
          end: Alignment.bottomRight,
        ),
        borderRadius: BorderRadius.circular(10.0),
      ),
      child: Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          IconButton(
            onPressed: _decrementQuantity,
            icon: const Icon(
              Icons.remove,
              color: Colors.white,
            ),
          ),
          Text(
            '$_currentQuantity',
            style: const TextStyle(
              fontSize: 18.0,
              color: Colors.white,
              fontWeight: FontWeight.bold,
            ),
          ),
          IconButton(
            onPressed: _incrementQuantity,
            icon: const Icon(
              Icons.add,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }
}
