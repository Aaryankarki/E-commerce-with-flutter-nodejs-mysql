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

class ProductDetailsServices {
  Future<void> addToCart({
    required BuildContext context,
    required Product product,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    try {
      http.Response res = await http.post(
        Uri.parse('$uri/api/add-to-cart'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
        body: jsonEncode({"id": product.id}),
      );

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          // User.fromMap(jsonDecode(res.body));
          User user = userProvider.user.copyWith(
            cart: jsonDecode(res.body),
          );
          userProvider.setUserFromModel(user);
          print('DEBUG UPDATED CART: ${jsonDecode(res.body)}');
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  Future<Product?> rateProduct({
    required BuildContext context,
    required Product product,
    required double rating,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    try {
      http.Response res = await http.post(
        Uri.parse('$uri/api/rate-product'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
        body: jsonEncode({"id": product.id, "rating": rating}),
      );

      Product? updatedProduct;
      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          updatedProduct = Product.fromJson(res.body);
        },
      );
      return updatedProduct;
    } catch (e) {
      showSnackBar(context, e.toString());
      return null;
    }
  }
  // Add product to favorites
  Future<void> addFavorite({
    required BuildContext context,
    required String productId,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    try {
      http.Response res = await http.post(
        Uri.parse('$uri/api/add-favorite'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
        body: jsonEncode({"id": productId}),
      );

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          // Update user favorites list
          User updatedUser = userProvider.user.copyWith(
            favorites: jsonDecode(res.body)['favorites'],
          );
          userProvider.setUserFromModel(updatedUser);
          showSnackBar(context, "Added to favorites!");
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  // Remove product from favorites
  Future<void> removeFavorite({
    required BuildContext context,
    required String productId,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    try {
      http.Response res = await http.delete(
        Uri.parse('$uri/api/remove-favorite/$productId'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
      );

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          User updatedUser = userProvider.user.copyWith(
            favorites: jsonDecode(res.body)['favorites'],
          );
          userProvider.setUserFromModel(updatedUser);
          showSnackBar(context, "Removed from favorites!");
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

}
