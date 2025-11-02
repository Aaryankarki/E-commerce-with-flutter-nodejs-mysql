


import 'package:flutter/material.dart';
import 'package:prisma_orm/constants/global_variable.dart';
import 'package:prisma_orm/features/account/screens/account_screen.dart';
import 'package:prisma_orm/features/cart/screens/cart_screen.dart';
import 'package:prisma_orm/features/home/screens/home_screens.dart';
import 'package:prisma_orm/providers/user_provider.dart';
import 'package:provider/provider.dart';

class ButtomBar extends StatefulWidget {
  static const String routeName = '/actual-home';
  const ButtomBar({super.key});

  @override
  State<ButtomBar> createState() => _ButtomBarState();
}

class _ButtomBarState extends State<ButtomBar> {
  int _page = 0;
  double buttomBarWidth = 42;
  double bottomBarBorderWidth = 5;

  List<Widget> pages = [
    const HomeScreen(),
    const AccountScreen(),
    const CartScreen(),
  ];

  void updatePage(int page) {
    setState(() {
      _page = page;
    });
  }

  @override
  Widget build(BuildContext context) {
    final userCartLen = context.watch<UserProvider>().user.cart.length;
    return Scaffold(
      body: pages[_page],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _page,

        selectedItemColor: GlobalVariables.selectedNavBarColor,
        unselectedItemColor: GlobalVariables.unselectedNavBarColor,
        backgroundColor: GlobalVariables.backgroundColor,
        iconSize: 28,
        onTap: updatePage,
        items: [
          //homepage
          BottomNavigationBarItem(
            icon: Container(
              width: buttomBarWidth,
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: _page == 0
                        ? GlobalVariables.selectedNavBarColor
                        : GlobalVariables.backgroundColor,
                    width: bottomBarBorderWidth,
                  ),
                ),
              ),
              child: Icon(Icons.home_outlined),
            ),
            label: '',
          ),
          //accountj
          BottomNavigationBarItem(
            icon: Container(
              width: buttomBarWidth,
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: _page == 1
                        ? GlobalVariables.selectedNavBarColor
                        : GlobalVariables.backgroundColor,
                    width: bottomBarBorderWidth,
                  ),
                ),
              ),
              child: Icon(Icons.person_2_outlined),
            ),
            label: '',
          ),

          //cart
          BottomNavigationBarItem(
            icon: Container(
              width: buttomBarWidth,
              decoration: BoxDecoration(
                border: Border(
                  top: BorderSide(
                    color: _page == 2
                        ? GlobalVariables.selectedNavBarColor
                        : GlobalVariables.backgroundColor,
                    width: bottomBarBorderWidth,
                  ),
                ),
              ),
              child: Badge(
                label: Text(userCartLen.toString()),
                textColor: Colors.black,
                backgroundColor: Colors.white,
                child: Icon(Icons.shopping_cart_outlined),
              ),
            ),
            label: '',
          ),
        ],
      ),
    );
  }
}
