import 'package:flutter/material.dart';

class CardWidget extends StatelessWidget {
  final double width;
  String? title;
  VoidCallback? onEditTap;
  VoidCallback? onPlusTap;
  final Widget child;

  CardWidget({
    super.key,
    this.width = 720,
    this.title,
    this.onEditTap,
    this.onPlusTap,
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
              _buildButton(),
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

  Widget _buildButton() {
    if(onEditTap != null){
      return InkWell(
        onTap: onEditTap,
        child: Icon(
          Icons.edit,
          size: 18,
          color: Color(0xFF9CA3AF),
        ),
      );
    } else if(onPlusTap != null){
      return InkWell(
        onTap: onPlusTap,
        child: Container(
          width: 72,
          padding: EdgeInsets.symmetric(horizontal: 12, vertical: 4),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(8),
            color: Colors.grey.shade800,
          ),
          child: Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              Icon(Icons.add, size: 14, color: Colors.white),
              SizedBox(width: 4),
              Text(
                "추가",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w500,
                  color: Colors.white,
                ),
              )
            ],
          ),
        ),
      );
    } else {
      return Spacer();
    }
  }
}
