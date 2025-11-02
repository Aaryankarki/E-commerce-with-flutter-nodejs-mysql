
import 'package:flutter/material.dart';
import 'package:prisma_orm/constants/global_variable.dart';
import 'package:prisma_orm/features/home/screens/category_details.dart';

class TopCategory extends StatelessWidget {
  const TopCategory({super.key});
  void navigateToCategoryPage(BuildContext context, String category) {
    Navigator.pushNamed(
      context,
      CategoryDealsScreen.routeName,
      arguments: category,
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 60,
      child: ListView.builder(
        scrollDirection: Axis.horizontal,
        itemExtent: 75,
        itemCount: GlobalVariables.categoryImages.length,
        itemBuilder: (context, index) {
          return GestureDetector(
            onTap: () => navigateToCategoryPage(
              context,
              GlobalVariables.categoryImages[index]['title']!, 
            ),
            child: Column(
              children: [
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 10),
                  child: ClipRRect(
                    borderRadius: BorderRadiusGeometry.circular(50),

                    child: Image.asset(
                      GlobalVariables.categoryImages[index]['image']!,
                      fit: BoxFit.cover,
                      height: 40,
                      width: 40,
                    ),
                  ),
                ),
                Text(
                  GlobalVariables.categoryImages[index]['title']!,
                  style: TextStyle(fontSize: 12, fontWeight: FontWeight.w400),
                ),
              ],
            ),
          );
        },
      ),
    );
  }
}
