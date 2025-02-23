import 'package:flutter/material.dart';

import '../../core/constants/app_colors.dart';

class CustomTextButton extends StatelessWidget {
  final Text child;
  final VoidCallback? onPressed;

  const CustomTextButton({
    super.key,
    required this.child,
    required this.onPressed,
  });

  @override
  Widget build(BuildContext context) {
    return TextButton(
      onPressed: onPressed,
      style: TextButton.styleFrom(
        overlayColor: AppColors.color4,
      ),
      child: child,
    );
  }
}
