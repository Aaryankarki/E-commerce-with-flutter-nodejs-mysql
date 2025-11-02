
import 'package:flutter/material.dart';
import 'package:prisma_orm/common/widgets/loader.dart';
import 'package:prisma_orm/features/account/widget/single_product.dart';
import 'package:prisma_orm/features/admin/services/admin_service.dart';
import 'package:prisma_orm/features/orders_details/screens/order_details.dart';
import 'package:prisma_orm/models/order.dart';

class OrdersScreen extends StatefulWidget {
  const OrdersScreen({super.key});

  @override
  State<OrdersScreen> createState() => _OrdersScreenState();
}

class _OrdersScreenState extends State<OrdersScreen> {
  List<Order>? orders;
  final AdminServices adminServices = AdminServices();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchOrders();
  }

  fetchOrders() async {
    orders = await adminServices.fetchAllOrders(context);
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return orders == null
        ? Loader()
        : GridView.builder(
            gridDelegate: SliverGridDelegateWithFixedCrossAxisCount(
              crossAxisCount: 2,
            ),
            itemCount: orders!.length,
            itemBuilder: (context, index) {
              final orderData = orders![index];

              return GestureDetector(
                onTap: () {
                  Navigator.pushNamed(
                    context,
                    OrderDetailScreen.routeName,
                    arguments: orderData,
                  );
                },
                child: SizedBox(
                  height: 140,
                  child:
                      (orderData.products.isNotEmpty &&
                          orderData.products[0].images.isNotEmpty)
                      ? SingleProduct(image: orderData.products[0].images[0])
                      : const Center(
                          child: Icon(
                            Icons.image_not_supported,
                            size: 40,
                            color: Colors.grey,
                          ),
                        ),
                ),
              );
            },
          );
  }
}
