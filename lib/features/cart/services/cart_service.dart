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

class CartServices {
  Future<void> removeFromCart({
    required BuildContext context,
    required Product product,
  }) async {
    final userProvider = Provider.of<UserProvider>(context, listen: false);
    try {
      http.Response res = await http.delete(
        Uri.parse('$uri/api/remove-from-cart/${product.id}'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': userProvider.user.token,
        },
        
      );

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          // User.fromMap(jsonDecode(res.body));
          User user = userProvider.user.copyWith(
            cart: jsonDecode(res.body)['cart'],
          );
          userProvider.setUserFromModel(user);
          print('DEBUGsknfjsbnjfbhsD CART: ${jsonDecode(res.body)['cart']}');
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }
}
