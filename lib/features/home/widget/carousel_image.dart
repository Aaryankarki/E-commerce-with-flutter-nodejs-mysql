import 'package:carousel_slider/carousel_slider.dart';
import 'dart:convert';
import 'package:flutter/material.dart';
import 'package:prisma_orm/common/widgets/loader.dart';
import 'package:prisma_orm/constants/global_variable.dart';
import 'package:http/http.dart' as http;

class CarouselImage extends StatefulWidget {
  const CarouselImage({super.key});

  @override
  State<CarouselImage> createState() => _CarouselImageState();
}

class _CarouselImageState extends State<CarouselImage> {
  List<String> carouselImages = [];
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    fetchCarouselImages();
  }

  void fetchCarouselImages() async {
    try {
      http.Response res = await http.get(
        Uri.parse('$uri/api/config'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      if (res.statusCode == 200) {
        var data = jsonDecode(res.body);
        setState(() {
          carouselImages = List<String>.from(data['carouselImages'] ?? []);
          isLoading = false;
        });
      }
    } catch (e) {
      print('Error fetching carousel: $e');
      setState(() {
        isLoading = false;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return const Loader();
    }

    if (carouselImages.isEmpty) {
      return const SizedBox.shrink();
    }

    return CarouselSlider(
      items: carouselImages.map((i) {
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
