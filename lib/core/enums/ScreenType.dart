import 'package:flutter/material.dart';

enum MainScreenType {
  Dashboard,
  MyInfo,
  RevenueList,
  SalesList,
  SalesPropertyRegister,
  SalesBuildingRegister,
  ClientList,
  ClientRegister,
  Calendar,
}

extension MainScreenTypeExtension on MainScreenType {
  String get name {
    switch (this) {
      case MainScreenType.Dashboard:
        return "대시보드";
      case MainScreenType.MyInfo:
        return "나의 정보";
      case MainScreenType.RevenueList:
        return "매출 목록";
      case MainScreenType.SalesList:
        return "매물 목록";
      case MainScreenType.SalesPropertyRegister:
        return "매물 등록";
      case MainScreenType.SalesBuildingRegister:
        return "건물 등록";
      case MainScreenType.ClientList:
        return "고객 목록";
      case MainScreenType.ClientRegister:
        return "고객 등록";
      case MainScreenType.Calendar:
        return "일정";
    }
  }
}