import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;
import 'package:prisma_orm/constants/error_handling.dart';
import 'package:prisma_orm/constants/global_variable.dart';
import 'package:prisma_orm/constants/utils.dart';
import 'package:prisma_orm/models/product.dart';
import 'package:prisma_orm/models/user.dart';
import 'package:prisma_orm/providers/user_provider.dart';
import 'package:provider/provider.dart';

class AddressServices {
  Future<void> saveUserAddress({
    required BuildContext context,
    required String address,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    try {
      http.Response res = await http.post(
        Uri.parse('$uri/api/save-user-address'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
        body: jsonEncode({'address': address}),
      );

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          User user = userProvider.user.copyWith(
            address: jsonDecode(res.body)['address'],
          );
          userProvider.setUserFromModel(user);
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  //get all products
  void placeOrder({
    required BuildContext context,
    required String address,
    required double totalSum,
    Product? buyNowProduct,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);

    try {
      String endpoint = buyNowProduct != null ? '/api/buy-now' : '/api/order';
      Map<String, dynamic> bodyData = {
        'address': address,
        'totalPrice': totalSum,
      };
      
      if (buyNowProduct != null) {
        bodyData['product'] = buyNowProduct.toMap();
      } else {
        bodyData['cart'] = userProvider.user.cart;
      }

      http.Response res = await http.post(
        Uri.parse('$uri$endpoint'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
        body: jsonEncode(bodyData),
      );
      print(res.body);
      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          showSnackBar(context, 'Your order has been placed');
          if (buyNowProduct == null) {
            User user = userProvider.user.copyWith(cart: []);
            userProvider.setUserFromModel(user);
          }
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }
}
