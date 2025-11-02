
import 'package:flutter/material.dart';
import 'package:prisma_orm/constants/global_variable.dart';
import 'package:prisma_orm/features/admin/screens/analytics.dart';
import 'package:prisma_orm/features/admin/screens/order_screens.dart';
import 'package:prisma_orm/features/admin/screens/posts_screen.dart';

class AdminScreen extends StatefulWidget {
  const AdminScreen({super.key});

  @override
  State<AdminScreen> createState() => _AdminScreenState();
}

class _AdminScreenState extends State<AdminScreen> {
  int _page = 0;
  double buttomBarWidth = 42;
  double bottomBarBorderWidth = 5;

  List<Widget> pages = [PostsScreen(), AnalyticsScreen(), OrdersScreen()];

  void updatePage(int page) {
    setState(() {
      _page = page;
    });
  }

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

              Text("Admin", style: TextStyle(fontWeight: FontWeight.bold)),
            ],
          ),
        ),
      ),
      body: pages[_page],
      bottomNavigationBar: BottomNavigationBar(
        currentIndex: _page,

        selectedItemColor: GlobalVariables.selectedNavBarColor,
        unselectedItemColor: GlobalVariables.unselectedNavBarColor,
        backgroundColor: GlobalVariables.backgroundColor,
        iconSize: 28,
        onTap: updatePage,
        items: [
          //posts
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
          //account
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
              child: Icon(Icons.analytics_outlined),
            ),
            label: '',
          ),
          //Analytics
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
              child: Icon(Icons.all_inbox_outlined),
            ),
            label: '',
          ),
        ],
      ),
    );
  }
}
