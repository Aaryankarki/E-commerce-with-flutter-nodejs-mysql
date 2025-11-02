import 'package:carousel_slider/carousel_slider.dart';

import 'package:flutter/material.dart';
import 'package:prisma_orm/constants/global_variable.dart';

class CarouselImage extends StatelessWidget {
  const CarouselImage({super.key});

  @override
  Widget build(BuildContext context) {
    return CarouselSlider(
      items: GlobalVariables.carouselImages.map((i) {
        return Builder(
          builder: (BuildContext context) =>
              Image.network(i, fit: BoxFit.cover, height: 200),
        );
      }).toList(),

      options: CarouselOptions(
        viewportFraction: 1,
        height: 200,
        autoPlay: true,
        autoPlayInterval: const Duration(seconds: 2),
        autoPlayAnimationDuration: const Duration(
          milliseconds: 1400,
        ), // 🔹 Slide speed
        autoPlayCurve: Curves.easeInOut,
      ),
    );
  }
}
