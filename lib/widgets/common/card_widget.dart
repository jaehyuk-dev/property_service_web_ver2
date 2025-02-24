import 'package:flutter/material.dart';

class CardWidget extends StatelessWidget {
  final double width;
  String? title;
  VoidCallback? onTap;
  final Widget child;

  CardWidget({
    super.key,
    this.width = 720,
    this.title,
    this.onTap,
    required this.child,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      width: width,
      padding: EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
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
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceBetween,
            children: [
              Text(
                title ?? "",
                style: TextStyle(
                  fontSize: 16,
                  fontWeight: FontWeight.w700,
                  color: Color(0xFF374151),
                ),
              ),
              onTap == null
                  ? Spacer()
                  : InkWell(
                onTap: onTap,
                child: Icon(
                  Icons.edit,
                  size: 18,
                  color: Color(0xFF9CA3AF),
                ),
              ),
            ],
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 24),
            child: child,
          ),
        ],
      ),
    );
  }
}
