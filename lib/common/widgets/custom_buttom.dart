import 'package:flutter/material.dart';

class CustomButtom extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  final Color? color;
  const CustomButtom({
    super.key,
    required this.text,
    required this.onTap,
    this.color,
  });

  @override
  Widget build(BuildContext context) {
    return ElevatedButton(
      onPressed: onTap,
      style: ElevatedButton.styleFrom(
        minimumSize: Size(double.infinity, 50),
        backgroundColor: color,
        shape: const RoundedRectangleBorder(borderRadius: BorderRadius.zero),
      ),
      child: Text(
        text,
        style: TextStyle(color: color == null ? Colors.white : Colors.black),
      ),
    );
  }
}
