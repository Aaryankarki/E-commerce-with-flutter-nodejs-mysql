import 'dart:convert';
import 'dart:developer';

import 'package:flutter/material.dart';
import "package:http/http.dart" as http;
import 'package:prisma_orm/common/widgets/button_bar.dart';
import 'package:prisma_orm/constants/error_handling.dart';
import 'package:prisma_orm/constants/global_variable.dart';
import 'package:prisma_orm/constants/utils.dart';
import 'package:prisma_orm/features/home/screens/home_screens.dart';
import 'package:prisma_orm/models/user.dart';
import 'package:prisma_orm/providers/user_provider.dart';
import 'package:provider/provider.dart';
import 'package:shared_preferences/shared_preferences.dart';

class AuthService {
  //signUp user
  void signUpUser({
    required BuildContext context,
    required String name,
    required String email,
    required String password,
  }) async {
    try {
      User user = User(
        id: '',
        email: email,
        name: name,
        password: password,
        address: '',
        type: '',
        token: '',
        cart: [],
      );

      http.Response res = await http.post(
        Uri.parse('$uri/api/signup'),

        body: user.toJson(),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () {
          showSnackBar(context, "Account created! Login with same credentials");
          Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => HomeScreen()),
          );
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  //signIN
  void signInUser({
    required BuildContext context,
    required String email,
    required String password,
  }) async {
    try {
      http.Response res = await http.post(
        Uri.parse('$uri/api/signin'),
        body: jsonEncode({'email': email, 'password': password}),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
        },
      );

      httpErrorHandle(
        response: res,
        context: context,
        onSuccess: () async {
          SharedPreferences prefs = await SharedPreferences.getInstance();
          Provider.of<UserProvider>(context, listen: false).setUser(res.body);

          await prefs.setString('x-auth-token', jsonDecode(res.body)['token']);

          Navigator.pushNamedAndRemoveUntil(
            context,
            ButtomBar.routeName,
            (route) => false, // remove all previous routes
          );
        },
      );
    } catch (e) {
      showSnackBar(context, e.toString());
    }
  }

  //get the data
  void getUserData(BuildContext context) async {
    try {
      SharedPreferences prefs = await SharedPreferences.getInstance();

      String? token = prefs.getString('x-auth-token');

      if (token == null) {
        await prefs.setString('x-auth-token', '');
        token = '';
      }

      var tokenRes = await http.post(
        Uri.parse('$uri/tokenIsValid'),
        headers: <String, String>{
          'Content-Type': 'application/json; charset=UTF-8',
          'x-auth-token': token,
        },
      );
      // print(tokenRes.body);
      var response = jsonDecode(tokenRes.body);

      if (response == true) {
        http.Response userRes = await http.get(
          Uri.parse("$uri/"),
          headers: <String, String>{
            'Content-Type': 'application/json; charset=UTF-8',
            'x-auth-token': token,
          },
        );

        // print(userRes.body);
        var userProvider = Provider.of<UserProvider>(context, listen: false);

        userProvider.setUser(userRes.body);
      }
    } catch (e) {
      print('Error fetching user data: $e');
    }
  }
}
