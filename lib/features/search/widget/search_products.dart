
import 'package:flutter/material.dart';
import 'package:prisma_orm/common/widgets/starts.dart';
import 'package:prisma_orm/models/product.dart';

//inside the after we search

class SearchProduct extends StatelessWidget {
  final Product product;
  const SearchProduct({super.key, required this.product});

  @override
  Widget build(BuildContext context) {
    double avgRating = 0;


    double totalRating = 0;
    for (int i = 0; i < product.rating!.length; i++) {
      totalRating += product.rating![i].rating;
    }
    if (totalRating != 0) {
      avgRating = totalRating /  product.rating!.length;
    }

    return Column(
      children: [
        // Container(color: Colors.black12, height: 5),
        Container(
          margin: EdgeInsets.symmetric(horizontal: 10, vertical: 10),
          child: Row(
            children: [
              Image.network(
                product.images[0],
                height: 135,
                width: 135,
                fit: BoxFit.fitWidth,
                loadingBuilder: (context, child, loadingProgress) {
                  if (loadingProgress == null) return child; //image loaded
                  return Center(child: CircularProgressIndicator()); // loading
                },
                errorBuilder: (context, error, stackTrace) =>
                    Icon(Icons.broken_image, size: 50), //if image fails
              ),

              Column(
                children: [
                  Container(
                    width: 235,
                    padding: EdgeInsets.only(left: 10, top: 5),
                    child: Text(
                      product.name,
                      style: TextStyle(fontSize: 16),
                      maxLines: 2,
                    ),
                  ),
                  Column(
                    children: [
                      Container(
                        width: 235,
                        padding: EdgeInsets.only(left: 10, top: 5),
                        child: Stars(rating: avgRating),
                      ),
                      Container(
                        width: 235,
                        padding: EdgeInsets.only(left: 10, top: 5),
                        child: Text(
                          '\$ ${product.price}',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2,
                        ),
                      ),
                      Container(
                        width: 235,
                        padding: EdgeInsets.only(left: 10, top: 5),
                        child: Text(
                          'Eligible for FREE Shipping',
                          style: TextStyle(
                            fontSize: 20,
                            fontWeight: FontWeight.bold,
                          ),
                          maxLines: 2,
                        ),
                      ),
                      Container(
                        width: 235,
                        padding: EdgeInsets.only(left: 10, top: 5),
                        child: Text(
                          'In stock',
                          style: TextStyle(color: Colors.teal),
                          maxLines: 2,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ],
          ),
        ),
        Container(color: Colors.black12, height: 5),
      ],
    );
  }
}
