import 'package:flutter/material.dart';
import 'package:property_service_web_ver2/core/enums/screen_type.dart';

class SubLayout extends StatelessWidget {
  final ScreenType screenType;
  final Widget child;

  SubLayout({
    super.key,
    required this.screenType,
    required this.child,
  });

  final ScrollController verticalScrollController = ScrollController();
  final ScrollController horizontalScrollController = ScrollController();

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
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
            child: Row(
              children: [
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      screenType.name,
                      style: TextStyle(
                        fontSize: 24,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                    SizedBox(height: 32),
                    child,
                  ],
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
