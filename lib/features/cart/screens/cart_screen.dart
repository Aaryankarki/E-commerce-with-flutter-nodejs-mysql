
import 'package:flutter/material.dart';
import 'package:prisma_orm/common/widgets/custom_buttom.dart';
import 'package:prisma_orm/constants/global_variable.dart';
import 'package:prisma_orm/features/address/screens/address_screen.dart';
import 'package:prisma_orm/features/cart/widget/cart_product.dart';
import 'package:prisma_orm/features/cart/widget/cart_subtotal.dart';
import 'package:prisma_orm/features/home/widget/addressbox.dart';
import 'package:prisma_orm/features/search/screens/search_screen.dart';
import 'package:prisma_orm/providers/user_provider.dart';
import 'package:provider/provider.dart';

class CartScreen extends StatefulWidget {
  const CartScreen({super.key});

  @override
  State<CartScreen> createState() => _CartScreenState();
}

class _CartScreenState extends State<CartScreen> {
  void navigateToSearch(String query) {
    Navigator.pushNamed(context, SearchScreen.routeName, arguments: query);
  }

  void navigateToAddress(int sum) {
    Navigator.pushNamed(
      context,
      AddressScreen.routeName,
      arguments: sum.toString(),
    );
  }
  // void navigateToAddress() async {
  // print("Hello");
  //   String pidx = "";
  //   try {
  //     PaymentService paymentService = PaymentService();
  //     final paymentInitiate = await paymentService.paymentInitiate();
  //     pidx = paymentInitiate.pidx;
  //   } catch (e) {
  //     print("issue $e");
  //   } finally {
  //     print("Your pidx is $pidx");
  //     Navigator.pushNamed(context, AddressScreen.routeName, arguments: pidx);
  //   }
  // }

  @override
  Widget build(BuildContext context) {
    final user = context.watch<UserProvider>().user;
    int sum = 0;
    user.cart
        .map((e) => sum += e['quantity'] * e['product']['price'] as int)
        .toList();
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
          children: [
            AddressBox(),
            CartSubtotal(),
            Padding(
              padding: const EdgeInsets.all(8.0),
              child: CustomButtom(
                text: "Procceed to Buy (${user.cart.length} items)",
                onTap: () => navigateToAddress(sum),
                color: Colors.yellow[600],
              ),
            ),
            SizedBox(height: 15),
            Container(color: Colors.black12.withOpacity(0.08), height: 1),
            SizedBox(height: 15),
            ListView.builder(
              itemCount: user.cart.length,
              shrinkWrap: true,
              itemBuilder: (context, index) {
                return CartProduct(index: index);
              },
            ),
          ],
        ),
      ),
    );
  }
}
