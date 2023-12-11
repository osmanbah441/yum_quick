import 'package:flutter/material.dart';

class UserReviewsWidget extends StatelessWidget {
  const UserReviewsWidget({
    super.key,
    required this.averageRating,
  });

  final double averageRating;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 8.0),
      child: Row(
        children: [
          Text(
            '$averageRating stars',
          ),
          const SizedBox(width: 8),
          ...List.generate(
            averageRating.round(),
            (_) => const Icon(Icons.star, color: Colors.yellow),
          )
        ],
      ),
    );
  }
}
