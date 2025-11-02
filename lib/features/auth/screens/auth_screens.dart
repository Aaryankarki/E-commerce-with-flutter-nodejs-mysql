import 'dart:developer';

import 'package:flutter/material.dart';
import 'package:prisma_orm/common/widgets/custom_buttom.dart';
import 'package:prisma_orm/common/widgets/custom_textfield.dart';
import 'package:prisma_orm/constants/global_variable.dart';
import 'package:prisma_orm/features/auth/services/auth_service.dart';

enum Auth { signin, signup }

class AuthScreen extends StatefulWidget {
  static const String routeName = '/auth-screen';
  const AuthScreen({super.key});

  @override
  State<AuthScreen> createState() => _AuthScreenState();
}

class _AuthScreenState extends State<AuthScreen> {
  final AuthService authService = AuthService();
  Auth _auth = Auth.signin;
  final _signUpFormScreens = GlobalKey<FormState>();
  final _signInFormScreens = GlobalKey<FormState>();
  final TextEditingController _emailController = TextEditingController();
  final TextEditingController _nameController = TextEditingController();
  final TextEditingController _passwordController = TextEditingController();

  @override
  void dispose() {
    // TODO: implement dispose
    super.dispose();
    _emailController.dispose();
    _nameController.dispose();
    _passwordController.dispose();
  }

  void signUpUser() {
    authService.signUpUser(
      context: context,
      name: _nameController.text,
      email: _emailController.text,
      password: _passwordController.text,
    );

    
  }

  void signinUser() {
    authService.signInUser(
      context: context,
      email: _emailController.text,
      password: _passwordController.text,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: GlobalVariables.backgroundColor,
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(8.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Welcome ",
                style: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
              ),
              ListTile(
                tileColor: _auth == Auth.signup
                    ? GlobalVariables.backgroundColor
                    : GlobalVariables.greyBackgroundColor,
                title: Text(
                  "create a  Account",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                leading: Radio(
                  activeColor: GlobalVariables.secondaryColor,
                  value: Auth.signup,
                  groupValue: _auth,
                  onChanged: (Auth? val) {
                    setState(() {
                      _auth = val!;
                    });
                  },
                ),
              ),
              if (_auth == Auth.signup)
                Container(
                  padding: EdgeInsets.all(8),
                  color: GlobalVariables.backgroundColor,
                  child: Form(
                    key: _signUpFormScreens,
                    child: Column(
                      children: [
                        CustomTextfield(
                          controller: _nameController,
                          hintText: "name",
                        ),
                        SizedBox(height: 10),
                        CustomTextfield(
                          controller: _emailController,
                          hintText: "Email",
                        ),
                        SizedBox(height: 10),
                        CustomTextfield(
                          controller: _passwordController,
                          hintText: "Password",
                        ),
                        SizedBox(height: 10),
                        CustomButtom(
                          text: "Sign Up",
                          onTap: () {
                            if (_signUpFormScreens.currentState!.validate()) {
                              signUpUser();
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
              ListTile(
                title: Text(
                  "Sign_In Account",
                  style: TextStyle(fontWeight: FontWeight.bold),
                ),
                leading: Radio(
                  activeColor: GlobalVariables.secondaryColor,
                  value: Auth.signin,
                  groupValue: _auth,
                  onChanged: (Auth? val) {
                    setState(() {
                      _auth = val!;
                    });
                  },
                ),
              ),
              if (_auth == Auth.signin)
                Container(
                  padding: EdgeInsets.all(8),
                  color: GlobalVariables.backgroundColor,
                  child: Form(
                    key: _signInFormScreens,
                    child: Column(
                      children: [
                        SizedBox(height: 10),
                        CustomTextfield(
                          controller: _emailController,
                          hintText: "Email",
                        ),
                        SizedBox(height: 10),
                        CustomTextfield(
                          controller: _passwordController,
                          hintText: "Password",
                        ),
                        SizedBox(height: 10),
                        CustomButtom(
                          text: "SignIn",
                          onTap: () {
                            if (_signInFormScreens.currentState!.validate()) {
                              signinUser();
                            }
                          },
                        ),
                      ],
                    ),
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }
}
