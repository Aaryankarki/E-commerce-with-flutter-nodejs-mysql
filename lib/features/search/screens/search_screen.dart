
import 'package:flutter/material.dart';
import 'package:prisma_orm/common/widgets/loader.dart';
import 'package:prisma_orm/constants/global_variable.dart';
import 'package:prisma_orm/features/home/widget/addressbox.dart';
import 'package:prisma_orm/features/product_details/screens/product_details.dart';
import 'package:prisma_orm/features/search/services/search_services.dart';
import 'package:prisma_orm/features/search/widget/search_products.dart';
import 'package:prisma_orm/models/product.dart';

//this is the next screen after which we get the list of the product that we have searched

class SearchScreen extends StatefulWidget {
  static const String routeName = "/search-screen";
  final String searchQuery;
  const SearchScreen({super.key, required this.searchQuery});

  @override
  State<SearchScreen> createState() => _SearchScreenState();
}

class _SearchScreenState extends State<SearchScreen> {
  List<Product>? products;
  final SearchServices searchServices = SearchServices();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchSearchedProduct();
  }

  void navigateToSearch(String query) {
    Navigator.pushNamed(context, SearchScreen.routeName, arguments: query);
  }

  fetchSearchedProduct() async {
    products = await searchServices.fetchSearchProduct(
      context: context,
      searchQuery: widget.searchQuery,
    );
    setState(() {});
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
      body: products == null
          ? const Loader()
          : Column(
              children: [
                AddressBox(),
                SizedBox(height: 30),
                Expanded(
                  child: ListView.builder(
                    itemCount: products!.length,
                    itemBuilder: (context, index) {
                      return GestureDetector(
                        onTap: () {
                          Navigator.pushNamed(
                            context,
                            ProductDetailScreen.routeName,
                            arguments: products![index],
                          );
                        },
                        child: SearchProduct(product: products![index]),
                      );
                    },
                  ),
                ),
              ],
            ),
    );
  }
}
