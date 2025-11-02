import 'dart:developer';


import 'package:flutter/material.dart';
import 'package:prisma_orm/common/widgets/loader.dart';
import 'package:prisma_orm/features/admin/model/sales.dart';
import 'package:prisma_orm/features/admin/services/admin_service.dart';
import 'package:prisma_orm/features/admin/widget/category_products_chart.dart';

class AnalyticsScreen extends StatefulWidget {
  const AnalyticsScreen({super.key});

  @override
  State<AnalyticsScreen> createState() => _AnalyticsScreenState();
}

class _AnalyticsScreenState extends State<AnalyticsScreen> {
  final AdminServices adminServices = AdminServices();
  int? totalSales;
  List<Sales>? earnings;
  @override
  void initState() {
    super.initState();
    getEarnings();
  }

  getEarnings() async {
    var earningData = await adminServices.getEarnings(context);
    print(earningData); // debug

    if (!mounted)
      return; // <--- prevents calling setState if widget is disposed

    totalSales = earningData['totalEarnings'];
    earnings = earningData['sales'];
    print('Total Sales: $totalSales');
    for (int i = 0; i < earnings!.length; i++) {
      print('Earnings: ${earnings![i].earning}');
    }
    setState(() {});
  }

  @override
  Widget build(BuildContext context) {
    return earnings == null || totalSales == null
        ? const Loader()
        : Column(
            children: [
              Text(
                '\$ $totalSales',
                style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
              ),
              CategoryProductsChart(data: earnings!),
            ],
          );
  }
}
