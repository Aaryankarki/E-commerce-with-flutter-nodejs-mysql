
import 'package:flutter/material.dart';
import 'package:prisma_orm/common/widgets/button_bar.dart';
import 'package:prisma_orm/features/address/screens/address_screen.dart';
import 'package:prisma_orm/features/admin/screens/add_product_screen.dart';
import 'package:prisma_orm/features/auth/screens/auth_screens.dart';
import 'package:prisma_orm/features/home/screens/category_details.dart';
import 'package:prisma_orm/features/home/screens/home_screens.dart';
import 'package:prisma_orm/features/orders_details/screens/order_details.dart';
import 'package:prisma_orm/features/product_details/screens/product_details.dart';
import 'package:prisma_orm/features/search/screens/search_screen.dart';
import 'package:prisma_orm/models/order.dart';
import 'package:prisma_orm/models/product.dart';

Route<dynamic> generateRoute(RouteSettings routeSettings) {
  switch (routeSettings.name) {
    case AuthScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const AuthScreen(),
      );
    case HomeScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const HomeScreen(),
      );
    case ButtomBar.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const ButtomBar(),
      );
    case AddProductScreen.routeName:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => const AddProductScreen(),
      );
    case CategoryDealsScreen.routeName:
      var category = routeSettings.arguments as String;
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => CategoryDealsScreen(category: category),
      );
    case SearchScreen.routeName:
      var searchQuery = routeSettings.arguments as String;
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => SearchScreen(searchQuery: searchQuery),
      );
    case ProductDetailScreen.routeName:
      var product = routeSettings.arguments as Product;
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => ProductDetailScreen(product: product),
      );
    case AddressScreen.routeName:
      var totalAmount = routeSettings.arguments as String;

      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => AddressScreen(totalAmount: totalAmount),
      );
      case OrderDetailScreen.routeName:
      var order = routeSettings.arguments as Order;

      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) => OrderDetailScreen(order: order),
      );
    default:
      return MaterialPageRoute(
        settings: routeSettings,
        builder: (_) =>
            Center(child: const Scaffold(body: Text("Screens doesnot exist"))),
      );
  }
}
