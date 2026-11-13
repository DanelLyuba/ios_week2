import 'package:flutter/material.dart';

import '../core/theme.dart';

class RatingRow extends StatelessWidget {
  const RatingRow({
    super.key,
    required this.rating,
    required this.reviewCount,
    this.large = false,
  });

  final double rating;
  final int reviewCount;
  final bool large;

  @override
  Widget build(BuildContext context) {
    final size = large ? 15.0 : 13.0;
    return Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        Icon(Icons.star_rounded, size: large ? 20 : 16, color: NovaColors.star),
        const SizedBox(width: 4),
        Text(
          rating.toStringAsFixed(1),
          style: TextStyle(fontSize: size, fontWeight: FontWeight.w700),
        ),
        const SizedBox(width: 4),
        Text(
          large ? '$reviewCount reviews' : '($reviewCount)',
          style: TextStyle(fontSize: size, color: NovaColors.muted),
        ),
      ],
    );
  }
}
