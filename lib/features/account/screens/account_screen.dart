
import 'package:flutter/material.dart';
import 'package:prisma_orm/constants/global_variable.dart';
import 'package:prisma_orm/features/account/widget/below_appbar.dart';
import 'package:prisma_orm/features/account/widget/orders.dart';
import 'package:prisma_orm/features/account/widget/top_buttons.dart';

class AccountScreen extends StatefulWidget {
  const AccountScreen({super.key});

  @override
  State<AccountScreen> createState() => _AccountScreenState();
}

class _AccountScreenState extends State<AccountScreen> {
  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: PreferredSize(
        preferredSize: Size.fromHeight(50),
        child: AppBar(
          flexibleSpace: Container(
            decoration: BoxDecoration(gradient: GlobalVariables.appBarGradient),
          ),
          title: Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Container(
                alignment: Alignment.topLeft,

                child: Image.asset(
                  'assets/images/logo.png',
                  width: 120,
                  height: 45,
                ),
              ),
              Container(
                padding: const EdgeInsets.only(left: 15, right: 15),
                child: Row(
                  children: [
                    Padding(
                      padding: EdgeInsets.only(left: 15, right: 15),
                      child: Icon(Icons.notifications_outlined),
                    ),
                    Icon(Icons.search_outlined),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
      body: Column(
        children: [
          BelowAppBar(),
          SizedBox(height: 10),
          TopButtons(),
          SizedBox(height: 10),
          Orders(),
        ],
      ),
    );
  }
}
