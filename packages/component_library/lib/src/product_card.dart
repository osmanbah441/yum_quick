import 'package:domain_models/domain_models.dart';
import 'package:flutter/material.dart';

typedef ProductSelected = Future<Product?> Function(String selectedProduct);

class ProductCard extends StatelessWidget {
  const ProductCard({
    Key? key,
    required this.product,
    required this.onTap,
    required this.onFavorite,
  }) : super(key: key);

  final Product product;
  final VoidCallback? onTap;
  final VoidCallback onFavorite;

  @override
  Widget build(BuildContext context) {
    return Material(
      child: InkWell(
        onTap: onTap,
        child: Card(
          elevation: 0,
          surfaceTintColor: Colors.white,
          child: Stack(
            children: [
              Column(
                children: [
                  AspectRatio(
                    aspectRatio: 16 / 9,
                    child: Image.asset(
                      product.imageUrl,
                      fit: BoxFit.cover,
                      package: 'component_library',
                    ),
                  ),
                  const SizedBox(height: 8),
                  Text(product.name,
                      style: Theme.of(context).textTheme.titleMedium),
                  const SizedBox(height: 4),
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text('\$${product.price}',
                          style: Theme.of(context).textTheme.titleSmall),
                      const SizedBox(width: 24),
                    ],
                  )
                ],
              ),
              Positioned(
                top: 8,
                right: 8,
                child: IconButton(
                  icon: Icon(
                    product.isFavorite ? Icons.favorite : Icons.favorite_border,
                    size: 32,
                    color: Colors.red,
                  ),
                  onPressed: onFavorite,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
