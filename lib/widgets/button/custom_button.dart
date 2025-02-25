import 'package:flutter/material.dart';

class CustomButton extends StatelessWidget {
  final String text;
  final VoidCallback onTap;
  const CustomButton({super.key, required this.text, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: onTap,
      child: Container(
        width: 88,
        height: 40,
        padding: EdgeInsets.symmetric(horizontal: 24, vertical: 2),
        decoration: BoxDecoration(
          color: Color(0xFF6A8988),
          borderRadius: BorderRadius.circular(12),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withAlpha(32),
              blurRadius: 10,
              spreadRadius: 2,
              offset: const Offset(0, 5),
            ),
          ],
        ),
        child: Center(
          child: Text(
            "등록",
            style: TextStyle(
                fontSize: 16,
                color: Colors.white
            ),
          ),
        ),
      ),
    );
  }
}
