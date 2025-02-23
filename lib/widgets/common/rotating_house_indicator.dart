import 'package:flutter/material.dart';
import 'dart:math';

import '../../core/constants/app_colors.dart';

class RotatingHouseIndicator extends StatefulWidget {
  @override
  _RotatingHouseIndicatorState createState() => _RotatingHouseIndicatorState();
}

class _RotatingHouseIndicatorState extends State<RotatingHouseIndicator> with SingleTickerProviderStateMixin {
  late AnimationController _controller;

  @override
  void initState() {
    super.initState();
    _controller = AnimationController(
      duration: Duration(seconds: 2),
      vsync: this,
    )..repeat(); // 무한 반복
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Center(
      child: AnimatedBuilder(
        animation: _controller,
        builder: (context, child) {
          return Transform.rotate(
            angle: _controller.value * 2 * pi, // 0 ~ 360도 회전
            child: Icon(Icons.home, size: 50, color: AppColors.color3),
          );
        },
      ),
    );
  }
}
