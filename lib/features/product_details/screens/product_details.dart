import 'package:carousel_slider/carousel_slider.dart';

import 'package:flutter/material.dart';
import 'package:flutter_rating_bar/flutter_rating_bar.dart';
import 'package:prisma_orm/common/widgets/custom_buttom.dart';
import 'package:prisma_orm/common/widgets/starts.dart';
import 'package:prisma_orm/constants/global_variable.dart';
import 'package:prisma_orm/constants/utils.dart';
import 'package:prisma_orm/features/product_details/services/product_details_services.dart';
import 'package:prisma_orm/features/search/screens/search_screen.dart';
import 'package:prisma_orm/features/address/screens/address_screen.dart';
import 'package:prisma_orm/models/product.dart';
import 'package:prisma_orm/providers/user_provider.dart';
import 'package:provider/provider.dart';

class ProductDetailScreen extends StatefulWidget {
  static const String routeName = '/product_details';
  final Product product;
  const ProductDetailScreen({super.key, required this.product});

  @override
  State<ProductDetailScreen> createState() => _ProductDetailScreenState();
}

class _ProductDetailScreenState extends State<ProductDetailScreen> {
  final ProductDetailsServices productDetailsServices =
      ProductDetailsServices();
  late Product product;
  double avgRating = 0;
  double myRatings = 0;
  bool isFavorited = false;
  @override
  void initState() {
    super.initState();
    // TODO: implement initState
    product = widget.product;
    calculateRatings();
    // Determine if product is already in favorites
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    isFavorited = userProvider.user.favorites.map((e) => e.toString()).contains(product.id);
    // Listen for changes to update favorite status
    userProvider.addListener(() {
      final fav = userProvider.user.favorites;
      final now = fav.map((e) => e.toString()).contains(product.id);
      if (now != isFavorited) {
        isFavorited = now;
        setState(() {});
      }
    });
  }
    

  void calculateRatings() {
    double totalRating = 0;
    myRatings = 0;
    for (int i = 0; i < product.rating!.length; i++) {
      totalRating += product.rating![i].rating;
      if (product.rating![i].userId ==
          Provider.of<UserProvider>(context, listen: false).user.id) {
        myRatings = product.rating![i].rating;
      }
    }
    // Update favorite status after ratings maybe changed
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    isFavorited = userProvider.user.favorites.map((e) => e.toString()).contains(product.id);

    if (totalRating != 0) {
      avgRating = totalRating / product.rating!.length;
    } else {
      avgRating = 0;
    }
  }

  void navigateToSearch(String query) {
    Navigator.pushNamed(context, SearchScreen.routeName, arguments: query);
  }

  void addToCart() {
    productDetailsServices.addToCart(context: context, product: product);
    showSnackBar(context, "Product has been added to the cart");
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(60),
        child: AppBar(
          flexibleSpace: Container(
            decoration: BoxDecoration(gradient: GlobalVariables.appBarGradient),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Expanded(
                child: Container(
                  height: 42,
                  margin: EdgeInsets.only(left: 15),

                  child: Material(
                    borderRadius: BorderRadius.circular(7),
                    elevation: 1,
                    child: TextFormField(
                      onFieldSubmitted: navigateToSearch,
                      decoration: InputDecoration(
                        prefixIcon: InkWell(
                          onTap: () {},

                          child: Padding(
                            padding: const EdgeInsets.only(left: 6),
                            child: Icon(
                              Icons.search,
                              color: Colors.black,
                              size: 23,
                            ),
                          ),
                        ),
                        filled: true,
                        fillColor: Colors.white,
                        contentPadding: EdgeInsets.only(top: 10),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(7)),
                          borderSide: BorderSide.none,
                        ),
                        enabledBorder: OutlineInputBorder(
                          borderRadius: BorderRadius.all(Radius.circular(7)),
                          borderSide: BorderSide(
                            color: Colors.black38,
                            width: 1,
                          ),
                        ),
                        hintText: 'Search in Aaryan Shop',
                        hintStyle: TextStyle(
                          fontWeight: FontWeight.w500,
                          fontSize: 17,
                        ),
                      ),
                    ),
                  ),
                ),
              ),
              Container(
                color: Colors.transparent,
                height: 42,
                margin: EdgeInsets.symmetric(horizontal: 10),
                child: Icon(Icons.mic, color: Colors.black),
              ),
            ],
          ),
        ),
      ),
      body: SingleChildScrollView(
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Text(product.id!),
                  Row(
                    children: [
                      IconButton(
                        icon: Icon(
                          isFavorited ? Icons.favorite : Icons.favorite_border,
                          color: Colors.red,
                        ),
                        onPressed: () async {
                          if (isFavorited) {
                            await productDetailsServices.removeFavorite(
                              context: context,
                              productId: product.id!,
                            );
                          } else {
                            await productDetailsServices.addFavorite(
                              context: context,
                              productId: product.id!,
                            );
                          }
                        },
                      ),
                      Stars(rating: avgRating),
                    ],
                  ),
                ],
              ),
            ),
            Padding(
              padding: EdgeInsetsGeometry.symmetric(
                vertical: 20,
                horizontal: 10,
              ),
              child: Text(product.name, style: TextStyle(fontSize: 15)),
            ),
            CarouselSlider(
              items: product.images.map((i) {
                return Builder(
                  builder: (BuildContext context) =>
                      Image.network(i, fit: BoxFit.contain, height: 200),
                );
              }).toList(),

              options: CarouselOptions(
                viewportFraction: 1,
                height: 200,
                autoPlay: true,
                autoPlayInterval: const Duration(seconds: 50),
                autoPlayAnimationDuration: const Duration(
                  milliseconds: 1400,
                ), // 🔹 Slide speed
                autoPlayCurve: Curves.easeInOut,
              ),
            ),
            Container(color: Colors.black12, height: 5),
            Padding(
              padding: EdgeInsetsGeometry.all(8),
              child: RichText(
                text: TextSpan(
                  text: 'Deal Price: ',
                  style: TextStyle(
                    fontSize: 16,
                    color: Colors.black,
                    fontWeight: FontWeight.bold,
                  ),
                  children: [
                    TextSpan(
                      text: '\$${product.price}',
                      style: TextStyle(
                        fontSize: 22,
                        color: Colors.red,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
              ),
            ),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: Text(product.description),
            ),
            Padding(
              padding: const EdgeInsets.all(10),
              child: CustomButtom(
                text: 'Buy Now',
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    AddressScreen.routeName,
                    arguments: {
                      'totalAmount': product.price.toString(),
                      'buyNowProduct': product,
                    },
                  );
                },
              ),
            ),
            SizedBox(height: 10),
            Padding(
              padding: const EdgeInsets.all(10),
              child: CustomButtom(
                text: 'Add to cart',
                onTap: addToCart,
                color: Color.fromRGBO(254, 216, 19, 1),
              ),
            ),
            Container(color: Colors.black12, height: 5),
            Padding(
              padding: const EdgeInsets.symmetric(horizontal: 10),
              child: Text(
                "Rate The Product",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.bold),
              ),
            ),
            RatingBar.builder(
              initialRating: myRatings,
              minRating: 1,
              direction: Axis.horizontal,
              allowHalfRating: true,
              itemCount: 5,
              itemPadding: EdgeInsets.symmetric(horizontal: 4),
              itemBuilder: (context, _) =>
                  Icon(Icons.star, color: GlobalVariables.secondaryColor),
              onRatingUpdate: (rating) async {
                Product? updatedProduct = await productDetailsServices.rateProduct(
                  context: context,
                  product: product,
                  rating: rating,
                );
                if (updatedProduct != null) {
                  setState(() {
                    product = updatedProduct;
                    calculateRatings();
                  });
                }
              },
            ),
          ],
        ),
      ),
    );
  }
}
