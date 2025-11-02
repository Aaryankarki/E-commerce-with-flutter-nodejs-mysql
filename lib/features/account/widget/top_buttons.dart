
import 'package:flutter/material.dart';
import 'package:prisma_orm/features/account/services/account_service.dart';
import 'package:prisma_orm/features/account/widget/account_button.dart';

class TopButtons extends StatefulWidget {
  const TopButtons({super.key});

  @override
  State<TopButtons> createState() => _TopButtonsState();
}

class _TopButtonsState extends State<TopButtons> {
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Row(
          children: [
            AccountButton(text: 'Yours Orders', onTap: () {}),
            AccountButton(text: 'Turn Seller', onTap: () {}),
          ],
        ),
        SizedBox(height: 10),
        Row(
          children: [
            AccountButton(text: 'Logout', onTap: ()=>
            AccountService().logOut(context)),
            AccountButton(text: 'Your Wish List', onTap: () {}),
          ],
        ),
      ],
    );
  }
}
