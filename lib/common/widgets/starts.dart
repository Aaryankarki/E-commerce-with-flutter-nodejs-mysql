
import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:prisma_orm/constants/global_variable.dart';

class Stars extends StatelessWidget {
  final double rating;
  const Stars({super.key, required this.rating});

  @override
  Widget build(BuildContext context) {
    return RatingBarIndicator(
      direction: Axis.horizontal,
      itemCount: 5,
      rating: rating,
      itemSize: 15,
      itemBuilder: (context, _) =>
          Icon(Icons.star, color: GlobalVariables.secondaryColor),
    );
  }
}
