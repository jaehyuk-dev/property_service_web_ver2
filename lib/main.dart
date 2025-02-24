import 'package:flutter/material.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:property_service_web_ver2/screens/calendar/calendar_view.dart';
import 'dart:html' as html;
import 'package:provider/provider.dart';

import 'package:property_service_web_ver2/screens/auth/login_view.dart';
import 'package:property_service_web_ver2/screens/auth/mobile_view.dart';
import 'package:property_service_web_ver2/widgets/common/rotating_house_indicator.dart';

void main() {
  runApp(
    MultiProvider(
      providers: [
        ChangeNotifierProvider(create: (_) => LoadingState()),
      ],
      child: MyApp(),
    ),
  );
}

class MyApp extends StatelessWidget {
  const MyApp({super.key});

  bool isMobileBrowser() {
    final userAgent = html.window.navigator.userAgent.toLowerCase();
    return userAgent.contains('mobile') ||
        userAgent.contains('android') ||
        userAgent.contains('iphone') ||
        userAgent.contains('ipad');
  }

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return MaterialApp(
      debugShowCheckedModeBanner: false,
      localizationsDelegates: [
        GlobalMaterialLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
      ],
      supportedLocales: [
        const Locale('ko', 'KR'), // 한국어 지원
      ],
      locale: const Locale('ko', 'KR'), // 기본 언어를 한국어로 설정
      title: "Property Service",
      theme: ThemeData(
        scaffoldBackgroundColor: Colors.white, // 모든 Scaffold에 흰 배경 설정
        // fontFamily: 'NotoSansKR', // pubspec.yaml에 정의한 family 이름 사용
        // textTheme: TextTheme(
        //   displayLarge: TextStyle(fontSize: 34, fontWeight: FontWeight.bold),
        //   displayMedium: TextStyle(fontSize: 28, fontWeight: FontWeight.w600),
        //   displaySmall: TextStyle(fontSize: 22, fontWeight: FontWeight.w500),
        //   titleLarge: TextStyle(fontSize: 20, fontWeight: FontWeight.w500),
        //   bodyLarge: TextStyle(fontSize: 16, fontWeight: FontWeight.normal),
        //   bodyMedium: TextStyle(fontSize: 14, fontWeight: FontWeight.normal),
        //   bodySmall: TextStyle(fontSize: 12, fontWeight: FontWeight.normal),
        // ),
      ),
      home: isMobileBrowser() ? MobileView() : LoginView(),
    );
  }
}
