import 'package:flutter/material.dart';

import 'yummy_avatar.dart';

class YummySearchBar extends StatelessWidget {
  const YummySearchBar({
    super.key,
    required this.controller,
    required this.imageProvider,
    required this.onProfileAvaterTap,
    required this.onCartIconTap,
  });

  final ImageProvider imageProvider;
  final VoidCallback? onProfileAvaterTap;
  final VoidCallback? onCartIconTap;
  final TextEditingController controller;

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.center,
      children: [
        SearchBar(
          controller: controller,
          elevation: MaterialStateProperty.all(1.0),
          hintText: 'search',
          leading: IconButton(
            onPressed: onProfileAvaterTap,
            icon: YummyAvatar(imageProvider: imageProvider),
          ),
          trailing: [
            IconButton(
              onPressed: onCartIconTap,
              icon: const Icon(Icons.shopping_cart),
            ),
          ],
        ),
      ],
    );
  }
}
