
import 'package:flutter/material.dart';
import 'package:prisma_orm/constants/global_variable.dart';


import 'package:prisma_orm/features/home/services/home_services.dart';
import 'package:prisma_orm/features/product_details/screens/product_details.dart';
import 'package:prisma_orm/models/product.dart';

class CategoryDealsScreen extends StatefulWidget {
  static const String routeName = '/category-deals';
  final String category;
  const CategoryDealsScreen({Key? key, required this.category})
    : super(key: key);

  @override
  State<CategoryDealsScreen> createState() => _CategoryDealsScreenState();
}

class _CategoryDealsScreenState extends State<CategoryDealsScreen> {
  List<Product>? productList;
  final HomeServices homeServices = HomeServices();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchCategoryProducts();
  }

  void fetchCategoryProducts() async {
    productList = await homeServices.fetchCategoryProducts(
      context,
      widget.category,
    );
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: AppBar(
          flexibleSpace: Container(
            decoration: BoxDecoration(gradient: GlobalVariables.appBarGradient),
          ),
          title: Text(
            widget.category,
            style: TextStyle(fontWeight: FontWeight.bold, color: Colors.black),
          ),
        ),
      ),
      body: productList == null
          ? Center(child: CircularProgressIndicator())
          : Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10, vertical: 15),
                  alignment: Alignment.topLeft,
                  child: Text(
                    "keep Shop for ${widget.category}",
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                SizedBox(
                  height: 170,
                  child: GridView.builder(
                    itemCount: productList!.length,
                    scrollDirection: Axis.horizontal,
                    padding: EdgeInsets.only(left: 15),
                    gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                      crossAxisCount: 1,
                      childAspectRatio: 1.4,
                      mainAxisSpacing: 10,
                    ),
                    itemBuilder: (context, index) {
                      final product = productList![index];
                      return GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            ProductDetailScreen.routeName,
                            arguments: product,
                          );
                        },
                        child: Column(
                          children: [
                            SizedBox(
                              height: 130,
                              child: DecoratedBox(
                                decoration: BoxDecoration(
                                  border: Border.all(color: Colors.black12),
                                ),
                                child: Padding(
                                  padding: EdgeInsetsGeometry.all(10),
                                  child: Image.network(
                                    product.images[0],
                                    loadingBuilder:
                                        (context, child, loadingProgress) {
                                          if (loadingProgress == null)
                                            return child;
                                          return Center(
                                            child: CircularProgressIndicator(),
                                          );
                                        },
                                    errorBuilder:
                                        (context, error, stackTrace) =>
                                            Icon(Icons.broken_image, size: 50),
                                  ),
                                ),
                              ),
                            ),

                            Container(
                              alignment: Alignment.topLeft,
                              padding: EdgeInsets.only(
                                left: 0,
                                top: 5,
                                right: 15,
                              ),
                              child: Text(
                                product.name,
                                maxLines: 1,
                                overflow: TextOverflow.ellipsis,
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
