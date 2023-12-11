import 'package:domain_models/domain_models.dart';
import 'package:flutter/material.dart';

typedef ProductSelected = Function(String productId);

class ProductCard extends StatelessWidget {
  const ProductCard({
    Key? key,
    required this.product,
    required this.onTap,
  }) : super(key: key);

  final Product product;
  final VoidCallback? onTap;

  @override
  Widget build(BuildContext context) {
    final textTheme = Theme.of(context).textTheme;
    return Material(
      child: InkWell(
        onTap: onTap,
        child: Card(
          elevation: 4,
          surfaceTintColor: Colors.white,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.center,
            mainAxisAlignment: MainAxisAlignment.center,
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
              Text(product.name, style: textTheme.titleMedium),
              const SizedBox(height: 4),
              Text('\$${product.price}', style: textTheme.titleSmall),
              const SizedBox(height: 16)
            ],
          ),
        ),
      ),
    );
  }
}
