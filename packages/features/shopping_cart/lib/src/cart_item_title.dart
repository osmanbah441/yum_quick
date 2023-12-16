import 'package:flutter/material.dart';
import 'package:domain_models/domain_models.dart';

class CartItemTile extends StatelessWidget {
  final CartItem cartItem;
  final VoidCallback onIncrement, onDecrement, onRemove;

  const CartItemTile({
    super.key,
    required this.cartItem,
    required this.onDecrement,
    required this.onIncrement,
    required this.onRemove,
  });

  @override
  Widget build(BuildContext context) {
    return Card(
      child: Padding(
        padding: const EdgeInsets.only(right: 8.0),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Image.network(
              cartItem.product.imageUrl,
              width: 100.0,
              height: 100.0,
              fit: BoxFit.cover,
            ),
            const SizedBox(width: 16.0),
            Expanded(
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Text(
                        cartItem.product.name,
                        style: const TextStyle(
                            fontSize: 18.0, fontWeight: FontWeight.bold),
                      ),
                      IconButton(
                          onPressed: onRemove, icon: const Icon(Icons.delete))
                    ],
                  ),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Column(
                        children: [
                          const Text(
                            'size',
                            style: TextStyle(fontSize: 16),
                          ),
                          Text(
                            '\$${cartItem.totalPrice}',
                            style: const TextStyle(fontSize: 16.0),
                          ),
                        ],
                      ),
                      _ItemQuantityButtons(
                          onDecrement: onDecrement,
                          cartItem: cartItem,
                          onIncrement: onIncrement),
                    ],
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}

class _ItemQuantityButtons extends StatelessWidget {
  const _ItemQuantityButtons({
    required this.onDecrement,
    required this.cartItem,
    required this.onIncrement,
  });

  final VoidCallback onDecrement;
  final CartItem cartItem;
  final VoidCallback onIncrement;

  @override
  Widget build(BuildContext context) {
    return Container(
        decoration: BoxDecoration(
          gradient: const LinearGradient(
            colors: [Color(0xFFAFC9FA), Color(0xFFCBBAFA), Color(0xFFFD9D9D)],
            begin: Alignment.topLeft,
            end: Alignment.bottomRight,
          ),
          borderRadius: BorderRadius.circular(24.0),
        ),
        child: ButtonBar(
          mainAxisSize: MainAxisSize.min,
          buttonPadding: const EdgeInsets.all(0),
          children: [
            IconButton(onPressed: onDecrement, icon: const Icon(Icons.remove)),
            Text(
              '${cartItem.quantity}',
              style: const TextStyle(fontSize: 18.0),
            ),
            IconButton(
              onPressed: onIncrement,
              icon: const Icon(Icons.add),
            ),
          ],
        ));
  }
}
