import 'package:flutter/material.dart';

class ProductImagesRow extends StatelessWidget {
  const ProductImagesRow({super.key, required this.imageUrls});

  final List<String> imageUrls;

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: 300,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemCount: imageUrls.length,
        itemBuilder: (BuildContext context, int index) {
          return Padding(
            padding: const EdgeInsets.symmetric(horizontal: 4.0),
            child: ClipRRect(
              borderRadius: BorderRadius.circular(16.0),
              child: Image.network(
                imageUrls[index],
                width: 250,
                height: 300,
                fit: BoxFit.cover,
              ),
            ),
          );
        },
      ),
    );
  }
}
