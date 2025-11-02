import 'dart:convert';
import 'dart:io';

import 'package:cloudinary_public/cloudinary_public.dart';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:prisma_orm/constants/error_handling.dart';
import 'package:prisma_orm/constants/global_variable.dart';
import 'package:prisma_orm/constants/utils.dart';
import 'package:prisma_orm/features/admin/model/sales.dart';
import 'package:prisma_orm/models/order.dart';
import 'package:prisma_orm/models/product.dart';
import 'package:prisma_orm/providers/user_provider.dart';
import 'package:provider/provider.dart';

class AdminServices {
  Future<void> sellProduct({
    required BuildContext context,
    required String name,
    required String description,
    required double price,
    required double quantity,
    required String category,
    required List<File> images,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    try {
      final cloudinary = CloudinaryPublic("dz5rms9di", "aaryan");
      List<String> imagesUrls = [];

      for (int i = 0; i < images.length; i++) {
        CloudinaryResponse res = await cloudinary.uploadFile(
          CloudinaryFile.fromFile(images[i].path, folder: name),
        );
        imagesUrls.add(res.secureUrl);
      }
      print(cloudinary);
      Product product = Product(
        name: name,
        description: description,
        quantity: quantity,
        images: imagesUrls,
        category: category,
        price: price,
        rating: [],
      );
      print(product);

      http.Response res = await http.post(
        Uri.parse('$uri/admin/add-product'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
        body: product.toJson(),
      );
      print("Response status: ${res.statusCode}");
      print("Response body: ${res.body}");

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          showSnackBar(context, "Product Added Successfully");
          Navigator.pop(context);
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  //get all products
  Future<List<Product>> fetchAllProducts(BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    List<Product> productList = [];
    try {
      http.Response res = await http.get(
        Uri.parse('$uri/admin/get-products'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
      );
      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          for (int i = 0; i < jsonDecode(res.body).length; i++) {
            productList.add(
              Product.fromJson(jsonEncode(jsonDecode(res.body)[i])),
            );
          }
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
    return productList;
  }

  void deleteProduct({
    required BuildContext context,
    required Product product,
    required VoidCallback onSuccess,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    try {
      http.Response res = await http.delete(
        Uri.parse('$uri/admin/delete-product'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
        body: jsonEncode({'id': product.id}),
      );
      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          onSuccess();
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  //fetch orders
  Future<List<Order>> fetchAllOrders(BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    List<Order> orderList = [];
    try {
      http.Response res = await http.get(
        Uri.parse('$uri/admin/get-orders'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
      );
      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          for (int i = 0; i < jsonDecode(res.body).length; i++) {
            orderList.add(Order.fromJson(jsonEncode(jsonDecode(res.body)[i])));
          }
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
    return orderList;
  }

  //status
  void changeOrderStatus({
    required BuildContext context,
    required int status,
    required Order order,
    required VoidCallback onSuccess,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    try {
      http.Response res = await http.post(
        Uri.parse('$uri/admin/change-order-status'),
        headers: {
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
        body: jsonEncode({'id': order.id, 'status': status}),
      );
      httpErrorHandle(response: res, context: context, onSuccess: onSuccess);
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  //analytics
  Future<Map<String, dynamic>> getEarnings(BuildContext context) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    List<Sales> sales = [];
    int? totalEarning;
    try {
      http.Response res = await http.get(
        Uri.parse('$uri/admin/analytics'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
      );

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          var response = jsonDecode(res.body);
          // print('${response}is as ssd');
          totalEarning = response['totalEarnings'];
          sales = [
            Sales('Mobiles', response['mobileEarnings']),
            Sales('Essentials', response['essentialEarnings']),
            Sales('Books', response['booksEarnings']),
            Sales('Appliances', response['applianceEarnings']),
            Sales('Fashion', response['fashionEarnings']),
          ];
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
    return {'sales': sales, 'totalEarnings': totalEarning};
  }
}
