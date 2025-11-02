
import 'package:flutter/material.dart';
import 'package:prisma_orm/features/cart/services/cart_service.dart';
import 'package:prisma_orm/features/product_details/services/product_details_services.dart';
import 'package:prisma_orm/models/product.dart';
import 'package:prisma_orm/providers/user_provider.dart';
import 'package:provider/provider.dart';

class CartProduct extends StatefulWidget {
  final int index;
  const CartProduct({super.key, required this.index});

  @override
  State<CartProduct> createState() => _CartProductState();
}

class _CartProductState extends State<CartProduct> {
  final ProductDetailsServices productDetailsServices =
      ProductDetailsServices();
  final CartServices cartServices = CartServices();
  void incrementQuantity(Product product) async {
    await productDetailsServices.addToCart(context: context, product: product);
  }

  void decrementQuantity(Product product) async {
    await cartServices.removeFromCart(context: context, product: product);
  }

  @override
  Widget build(BuildContext context) {
    final productCart = context.watch<UserProvider>().user.cart[widget.index];
    final product = Product.fromMap(productCart['product']);
    final quantity = productCart['quantity'];

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
        Container(
          margin: EdgeInsets.all(10),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                decoration: BoxDecoration(
                  border: Border.all(color: Colors.black12, width: 1.5),
                  borderRadius: BorderRadius.circular(5),
                  color: Colors.black12,
                ),
                child: Row(
                  children: [
                    InkWell(
                      onTap: () => decrementQuantity(product),
                      child: Container(
                        width: 35,
                        height: 32,
                        alignment: Alignment.center,
                        child: Icon(Icons.remove, size: 18),
                      ),
                    ),
                    DecoratedBox(
                      decoration: BoxDecoration(
                        border: Border.all(color: Colors.black12, width: 1.5),
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(0),
                      ),
                      child: Container(
                        width: 35,
                        height: 32,
                        alignment: Alignment.center,
                        child: Text(quantity.toString()),
                      ),
                    ),
                    InkWell(
                      onTap: () => incrementQuantity(product),
                      child: Container(
                        width: 35,
                        height: 32,
                        alignment: Alignment.center,
                        child: Icon(Icons.add, size: 18),
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ],
    );
  }
}
