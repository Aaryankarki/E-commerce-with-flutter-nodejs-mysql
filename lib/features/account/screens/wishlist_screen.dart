import 'package:flutter/material.dart';
import 'package:prisma_orm/common/widgets/loader.dart';
import 'package:prisma_orm/constants/global_variable.dart';
import 'package:prisma_orm/features/account/services/account_service.dart';
import 'package:prisma_orm/features/product_details/screens/product_details.dart';
import 'package:prisma_orm/features/product_details/services/product_details_services.dart';
import 'package:prisma_orm/features/search/widget/search_products.dart';
import 'package:prisma_orm/models/product.dart';

class WishlistScreen extends StatefulWidget {
  static const String routeName = "/wishlist-screen";
  const WishlistScreen({super.key});

  @override
  State<WishlistScreen> createState() => _WishlistScreenState();
}

class _WishlistScreenState extends State<WishlistScreen> {
  List<Product>? products;
  final AccountService accountService = AccountService();

  @override
  void initState() {
    super.initState();
    fetchWishlistProducts();
  }

  fetchWishlistProducts() async {
    products = await accountService.fetchWishlist(context);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: const Size.fromHeight(50),
        child: AppBar(
          flexibleSpace: Container(
            decoration: const BoxDecoration(
              gradient: GlobalVariables.appBarGradient,
            ),
          ),
          title: const Text(
            'Your Wish List',
            style: TextStyle(color: Colors.black, fontWeight: FontWeight.normal),
          ),
        ),
      ),
      body: products == null
          ? const Loader()
          : products!.isEmpty
              ? const Center(
                  child: Text('No products in your wishlist!'),
                )
              : Column(
                  children: [
                    const SizedBox(height: 10),
                    Expanded(
                      child: ListView.builder(
                        itemCount: products!.length,
                        itemBuilder: (context, index) {
                          final product = products![index];
                          return GestureDetector(
                            onTap: () {
                              Navigator.pushNamed(
                                context,
                                ProductDetailScreen.routeName,
                                arguments: product,
                              ).then((_) {
                                // Refresh wishlist when coming back in case favorite was removed
                                fetchWishlistProducts();
                              });
                            },
                            child: Stack(
                              children: [
                                SearchProduct(product: product),
                                Positioned(
                                  top: 15,
                                  right: 15,
                                  child: IconButton(
                                    icon: const Icon(Icons.favorite, color: Colors.red),
                                    onPressed: () async {
                                      await ProductDetailsServices().removeFavorite(
                                        context: context,
                                        productId: product.id!,
                                      );
                                      fetchWishlistProducts();
                                    },
                                  ),
                                ),
                              ],
                            ),
                          );
                        },
                      ),
                    ),
                  ],
                ),
    );
  }
}
