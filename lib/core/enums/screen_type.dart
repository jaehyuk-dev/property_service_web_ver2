import 'package:flutter/material.dart';
import 'package:property_service_web_ver2/screens/calendar/calendar_view.dart';
import 'package:property_service_web_ver2/screens/client/client_list_view.dart';
import 'package:property_service_web_ver2/screens/client/client_register_view.dart';
import 'package:property_service_web_ver2/screens/main/dashboard_view.dart';
import 'package:property_service_web_ver2/screens/main/my_info_view.dart';
import 'package:property_service_web_ver2/screens/revenue/revenue_list_view.dart';
import 'package:property_service_web_ver2/screens/sales/building_register_view.dart';
import 'package:property_service_web_ver2/screens/sales/property_list_view.dart';
import 'package:property_service_web_ver2/screens/sales/property_register_view.dart';

enum ScreenType {
  Dashboard,
  MyInfo,
  RevenueList,
  PropertyList,
  PropertyRegister,
  BuildingRegister,
  ClientList,
  ClientRegister,
  Calendar,
}

extension ScreenTypeExtension on ScreenType {
  String get name {
    switch (this) {
      case ScreenType.Dashboard:
        return "대시보드";
      case ScreenType.MyInfo:
        return "나의 정보";
      case ScreenType.RevenueList:
        return "매출 목록";
      case ScreenType.PropertyList:
        return "매물 목록";
      case ScreenType.PropertyRegister:
        return "매물 등록";
      case ScreenType.BuildingRegister:
        return "건물 등록";
      case ScreenType.ClientList:
        return "고객 목록";
      case ScreenType.ClientRegister:
        return "고객 등록";
      case ScreenType.Calendar:
        return "일정";
    }
  }

  Widget get screen {
    switch (this) {
      case ScreenType.Dashboard:
        return Dashboard();
      case ScreenType.MyInfo:
        return MyInfo();
      case ScreenType.RevenueList:
        return RevenueList();
      case ScreenType.PropertyList:
        return PropertyList();
      case ScreenType.PropertyRegister:
        return PropertyRegister();
      case ScreenType.BuildingRegister:
        return BuildingRegister();
      case ScreenType.ClientList:
        return ClientList();
      case ScreenType.ClientRegister:
        return ClientRegister();
      case ScreenType.Calendar:
        return Calendar();
    }
  }
}