
import 'package:flutter/material.dart';
import 'package:prisma_orm/common/widgets/loader.dart';
import 'package:prisma_orm/constants/global_variable.dart';
import 'package:prisma_orm/features/account/widget/single_product.dart';
import 'package:prisma_orm/features/admin/screens/add_product_screen.dart';
import 'package:prisma_orm/features/admin/services/admin_service.dart';
import 'package:prisma_orm/models/product.dart';

class PostsScreen extends StatefulWidget {
  const PostsScreen({super.key});

  @override
  State<PostsScreen> createState() => _PostsScreenState();
}

class _PostsScreenState extends State<PostsScreen> {
  List<Product>? products;
  final AdminServices adminServices = AdminServices();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchAllProducts();
  }

  fetchAllProducts() async {
    products = await adminServices.fetchAllProducts(context);
    setState(() {});
  }

  void deleteProducts(Product product, int index) {
    showDialog(
      context: context,
      builder: (ctx) => AlertDialog(
        title: Text("Delete Product"),
        content: Text("Are you sure you want to delete ${product.name}?"),
        actions: [
          TextButton(
            onPressed: () => Navigator.of(ctx).pop(),
            child: Text("Cancel"),
          ),
          TextButton(
            onPressed: () {
              Navigator.of(ctx).pop();
              adminServices.deleteProduct(
                context: context,
                product: product,
                onSuccess: () {
                  setState(() {
                    products!.removeAt(index);
                  });
                },
              );
            },
            child: Text("Delete"),
          ),
        ],
      ),
    );
  }

  void navigateToAddProduct() {
    Navigator.pushNamed(context, AddProductScreen.routeName);
  }

  @override
  Widget build(BuildContext context) {
    return products == null
        ? Loader()
        : Scaffold(
            body: GridView.builder(
              itemCount: products!.length,
              gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
                crossAxisCount: 2,
              ),
              itemBuilder: (context, index) {
                final productData = products![index];
                return Column(
                  children: [
                    SizedBox(
                      height: 140,
                      child: SingleProduct(image: productData.images[0]),
                    ),
                    Row(
                      mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                      children: [
                        Expanded(
                          child: Text(
                            productData.name,
                            overflow: TextOverflow.ellipsis,
                            maxLines: 2,
                          ),
                        ),
                        IconButton(
                          onPressed: () => deleteProducts(productData, index),
                          icon: Icon(Icons.delete),
                        ),
                      ],
                    ),
                  ],
                );
              },
            ),
            floatingActionButton: FloatingActionButton(
              backgroundColor: GlobalVariables.selectedNavBarColor,
              onPressed: () {
                navigateToAddProduct();
              },
              tooltip: "Add a product",
              child: Icon(Icons.add),
            ),
            floatingActionButtonLocation:
                FloatingActionButtonLocation.centerFloat,
          );
  }
}
