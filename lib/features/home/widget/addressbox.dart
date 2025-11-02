
import 'package:flutter/material.dart';
import 'package:prisma_orm/providers/user_provider.dart';
import 'package:provider/provider.dart';

class AddressBox extends StatefulWidget {
  const AddressBox({super.key});

  @override
  State<AddressBox> createState() => _AddressBoxState();
}

class _AddressBoxState extends State<AddressBox> {
  @override
  Widget build(BuildContext context) {
    final user = Provider.of<UserProvider>(context).user;

    return Container(
      height: 40,
      decoration: BoxDecoration(
        gradient: LinearGradient(
          colors: [
            Color.fromARGB(255, 114, 226, 221),
            Color.fromARGB(255, 162, 236, 223),
          ],
          stops: [0.5, 1.0],
        ),
      ),
      padding: EdgeInsets.only(left: 10),
      child: Row(
        children: [
          Icon(Icons.location_on_outlined, size: 29),
          Expanded(
            child: Padding(
              padding: EdgeInsetsGeometry.only(left: 5),
              child: Text(
                'Delivery to ${user.name}-${user.address}',
                style: TextStyle(fontWeight: FontWeight.w500),
                overflow: TextOverflow.ellipsis,
              ),
            ),
          ),
          const Padding(
            padding: EdgeInsetsGeometry.only(left: 5, top: 2),
            child: Icon(Icons.arrow_drop_down, size: 18),
          ),
        ],
      ),
    );
  }
}
