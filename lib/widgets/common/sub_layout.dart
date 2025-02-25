import 'package:flutter/material.dart';
import 'package:property_service_web_ver2/core/enums/screen_type.dart';
import 'package:property_service_web_ver2/widgets/button/custom_button.dart';

class SubLayout extends StatelessWidget {
  final ScreenType screenType;
  final Widget child;
  final String? buttonText;
  final VoidCallback? onTap;

  SubLayout({
    super.key,
    required this.screenType,
    required this.child,
    this.buttonText,
    this.onTap,
  });

  final ScrollController verticalScrollController = ScrollController();
  final ScrollController horizontalScrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.transparent,
      body: SingleChildScrollView(
        controller: verticalScrollController,
        scrollDirection: Axis.vertical,
        child: SingleChildScrollView(
          controller: horizontalScrollController,
          scrollDirection: Axis.horizontal,
          child: Padding(
            padding: const EdgeInsets.symmetric(horizontal: 44, vertical: 44),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      screenType.name,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                    if(buttonText != null && onTap != null)
                      Row(
                        children: [
                          SizedBox(width: 1280),
                          CustomButton(text: buttonText!, onTap: onTap!),
                        ],
                      )
                  ],
                ),
                SizedBox(height: 32),
                child,
              ],
            ),
          ),
        ),
      ),
    );
  }
}
