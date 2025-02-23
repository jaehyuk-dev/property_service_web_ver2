import 'package:flutter/material.dart';

class MobileView extends StatefulWidget {
  const MobileView({super.key});

  @override
  State<MobileView> createState() => _MobileViewState();
}

class _MobileViewState extends State<MobileView> {
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return Scaffold(
      backgroundColor: Color(0xffeff0ed),
      body: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Text(
              "Property Service",
              style: TextStyle(
                fontSize: 36,
                fontWeight: FontWeight.w700,
                color: Color(0xFF728989),
              ),
            ),
            SizedBox(height: 48),
            Text(
              "모바일 화면은 현재 개발 중 입니다.",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Color(0xFF9baaa6),
              ),
            ),
            SizedBox(height: 24),
            Text(
              "기타 문의사항은 관리자에게 문의해 주세요.",
              style: TextStyle(
                fontSize: 16,
                fontWeight: FontWeight.w700,
                color: Color(0xFF9baaa6),
              ),
            ),
          ],
        ),
      ),
    );
  }
}
