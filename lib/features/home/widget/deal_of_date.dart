import 'package:flutter/material.dart';
import 'package:prisma_orm/common/widgets/loader.dart';
import 'package:prisma_orm/features/home/services/home_services.dart';
import 'package:prisma_orm/features/product_details/screens/product_details.dart';
import 'package:prisma_orm/models/product.dart';

class DealOfDay extends StatefulWidget {
  const DealOfDay({super.key});

  @override
  State<DealOfDay> createState() => _DealOfDayState();
}

class _DealOfDayState extends State<DealOfDay> {
  Product? product;
  final HomeServices homeServices = HomeServices();
  @override
  void initState() {
    // TODO: implement initState
    super.initState();
    fetchDealOfDay();
  }

  void navigateToDetailScreen() {
    Navigator.pushNamed(
      context,
      ProductDetailScreen.routeName,
      arguments: product,
    );
  }

  void fetchDealOfDay() async {
    product = await homeServices.fetchDealOfDay(context);
    print('Fetched Deal of Day: ${product?.name}');
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    if (product == null) return const Loader();
    if (product!.name.isEmpty) {
      return Container(
        padding: const EdgeInsets.all(20),
        alignment: Alignment.center,
        child: const Text(
          "No deals available today",
          style: TextStyle(fontSize: 16),
        ),
      );
    }
    return product == null
        ? const Loader()
        : product!.name.isEmpty
        ? SizedBox()
        : GestureDetector(
            onTap: navigateToDetailScreen,
            child: Column(
              children: [
                Container(
                  alignment: Alignment.topLeft,
                  padding: EdgeInsets.only(left: 10, top: 15),
                  child: Text(
                    'Deal of the Day',
                    style: TextStyle(fontSize: 20),
                  ),
                ),
                Image.network(
                  product!.images[0],
                  height: 235,
                  fit: BoxFit.fitHeight,
                ),
                Container(
                  alignment: Alignment.topLeft,
                  padding: EdgeInsets.only(left: 15),
                  child: Text(
                    product!.price.toString(),
                    style: const TextStyle(fontSize: 18),
                  ),
                ),
                Container(
                  alignment: Alignment.topLeft,
                  padding: EdgeInsets.only(left: 15, top: 5, right: 40),
                  child: Text(
                    product!.name,
                    maxLines: 2,
                    overflow: TextOverflow.ellipsis,
                  ),
                ),
                SingleChildScrollView(
                  scrollDirection: Axis.horizontal,
                  child: Row(
                    children: product!.images
                        .map(
                          (e) => Image.network(
                            e,
                            fit: BoxFit.cover,
                            width: 100,
                            height: 100,
                          ),
                        )
                        .toList(),
                  ),
                ),
                Container(
                  padding: EdgeInsets.symmetric(
                    vertical: 15,
                  ).copyWith(left: 15),
                  alignment: Alignment.topLeft,
                  child: Text(
                    "Sell a deals",
                    style: TextStyle(color: Colors.cyan[800]),
                  ),
                ),
              ],
            ),
          );
  }
}
