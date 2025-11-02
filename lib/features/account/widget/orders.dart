
import 'package:flutter/material.dart';
import 'package:prisma_orm/common/widgets/loader.dart';
import 'package:prisma_orm/constants/global_variable.dart';
import 'package:prisma_orm/features/account/services/account_service.dart';
import 'package:prisma_orm/features/account/widget/single_product.dart';
import 'package:prisma_orm/features/orders_details/screens/order_details.dart';
import 'package:prisma_orm/models/order.dart';

class Orders extends StatefulWidget {
  const Orders({super.key});

  @override
  State<Orders> createState() => _OrdersState();
}

class _OrdersState extends State<Orders> {
  List<Order>? orders;
  final AccountService accountService = AccountService();

  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchOrders();
  }

  void fetchOrders() async {
    orders = await accountService.fetchMyOrders(context);
    print('Fetched orders: $orders');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return orders == null
        ? Loader()
        : Column(
            children: [
              Row(
                mainAxisAlignment: MainAxisAlignment.spaceBetween,
                children: [
                  Container(
                    padding: EdgeInsets.only(left: 15),
                    child: Text(
                      "Your Orders",
                      style: TextStyle(
                        fontSize: 18,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                  Container(
                    padding: EdgeInsets.only(right: 15),
                    child: Text(
                      "See All",
                      style: TextStyle(
                        color: GlobalVariables.selectedNavBarColor,
                      ),
                    ),
                  ),
                ],
              ),
              //display  orders
              Container(
                height: 170,
                padding: EdgeInsets.only(left: 10, top: 20, right: 0),
                child: ListView.builder(
                  scrollDirection: Axis.horizontal,
                  itemCount: orders!.length,
                  itemBuilder: (context, index) {
                    // print(
                    //   'Order ${index} first product first image: ${orders![index].products[0].images[0]}',
                    // );
                    return GestureDetector(
                      onTap: () {
                        Navigator.of(context).pushNamed(
                          OrderDetailScreen.routeName,
                          arguments: orders![index],
                        );
                      },
                      child: SingleProduct(
                        image: orders![index].products[0].images[0],
                      ),
                    );
                  },
                ),
              ),
            ],
          );
  }
}
