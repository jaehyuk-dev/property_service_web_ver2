import 'package:flutter/material.dart';
import 'package:property_service_web_ver2/core/enums/screen_type.dart';
import 'package:provider/provider.dart';

import '../../widgets/common/rotating_house_indicator.dart';

class MainView extends StatefulWidget {
  const MainView({super.key});

  @override
  State<MainView> createState() => MainViewState();
}

class MainViewState extends State<MainView> {
  late LoadingState loadingState;

  // 현재 활성화된 화면의 상태를 저장
  ScreenType activeScreen = ScreenType.Dashboard;

  // 상태 변경을 관리하는 함수
  void updateActiveScreen(ScreenType screen) {
    setState(() {
      activeScreen = screen;
    });
  }

  @override
  void initState() {
    // TODO: implement initState
    loadingState = Provider.of<LoadingState>(context, listen: false);
    super.initState();
  }
  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;
    return ListenableBuilder(
        listenable: loadingState,
        builder: (context, child)
        => Stack(
          children: [
            Scaffold(
              body: Container(
                decoration: BoxDecoration(
                  image: DecorationImage(
                    image: AssetImage('assets/silhouette-skyline-illustration/78786.jpg'),
                    fit: BoxFit.cover,
                  ),
                ),
                child: Column(
                  children: [
                    // 상단 네비게이션 바
                    Container(
                      height: 64,
                      color: Color(0xFF728989),
                      child: Padding(
                        padding: const EdgeInsets.symmetric(vertical: 18, horizontal: 32),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.spaceBetween,
                          children: [
                            Text(
                              "Property Service",
                              style: TextStyle(
                                fontSize: 20,
                                fontWeight: FontWeight.w400,
                                color: Colors.white,
                              ),
                            ),
                            InkWell(
                              onTap: () {
                                Navigator.pushReplacementNamed(context, '/',);
                              },
                              child: Icon(
                                Icons.logout,
                                size: 20,
                                color: Colors.white,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                    Expanded(
                      child: Row(
                        children: [
                          // 메뉴 영역
                          Container(
                            width: 240,
                            color: Colors.white,
                            child: ListView(
                              children: [
                                SizedBox(height: 16),
                                _buildMenuItem(
                                    title: ScreenType.Dashboard.name,
                                    depth: 0,
                                    icon: Icons.dashboard,
                                    onTap: () => updateActiveScreen(ScreenType.Dashboard),
                                    isSelected: activeScreen == ScreenType.Dashboard
                                ),
                                _buildMenuItem(
                                    title: ScreenType.MyInfo.name,
                                    depth: 0,
                                    icon: Icons.person,
                                    onTap: () => updateActiveScreen(ScreenType.MyInfo),
                                    isSelected: activeScreen == ScreenType.MyInfo
                                ),
                                _buildExpansionMenu(
                                  title: "매출 장부",
                                  depth: 0,
                                  icon: Icons.attach_money,
                                  isSelected: false,
                                  children: [
                                    _buildMenuItem(
                                      title: ScreenType.RevenueList.name,
                                      depth: 1,
                                      onTap: () => updateActiveScreen(ScreenType.RevenueList),
                                      isSelected: activeScreen == ScreenType.RevenueList,
                                    ),
                                  ],
                                ),
                                _buildExpansionMenu(
                                  title: "영업 장부",
                                  depth: 0,
                                  icon: Icons.real_estate_agent,
                                  isSelected: false,
                                  children: [
                                    _buildMenuItem(
                                      title: ScreenType.PropertyList.name,
                                      depth: 1,
                                      onTap: () => updateActiveScreen(ScreenType.PropertyList),
                                      isSelected: activeScreen == ScreenType.PropertyList,
                                    ),
                                    _buildMenuItem(
                                      title: ScreenType.PropertyRegister.name,
                                      depth: 1,
                                      onTap: () => updateActiveScreen(ScreenType.PropertyRegister),
                                      isSelected: activeScreen == ScreenType.PropertyRegister,
                                    ),
                                    _buildMenuItem(
                                      title: ScreenType.BuildingRegister.name,
                                      depth: 1,
                                      onTap: () => updateActiveScreen(ScreenType.BuildingRegister),
                                      isSelected: activeScreen == ScreenType.BuildingRegister,
                                    ),
                                  ],
                                ),
                                _buildExpansionMenu(
                                  title: "고객 장부",
                                  depth: 0,
                                  icon: Icons.group,
                                  isSelected: false,
                                  children: [
                                    _buildMenuItem(
                                      title: ScreenType.ClientList.name,
                                      depth: 1,
                                      onTap: () => updateActiveScreen(ScreenType.ClientList),
                                      isSelected: activeScreen == ScreenType.ClientList,
                                    ),
                                    _buildMenuItem(
                                      title: ScreenType.ClientRegister.name,
                                      depth: 1,
                                      onTap: () => updateActiveScreen(ScreenType.ClientRegister),
                                      isSelected: activeScreen == ScreenType.ClientRegister,
                                    ),
                                  ],
                                ),
                                _buildMenuItem(
                                  title: ScreenType.Calendar.name,
                                  depth: 0,
                                  icon: Icons.calendar_month,
                                  onTap: () => updateActiveScreen(ScreenType.Calendar),
                                  isSelected: activeScreen == ScreenType.Calendar,
                                ),
                                SizedBox(height: 16),
                              ],
                            ),
                          ),
                          // 본문 영역
                          Container(
                            width: size.width - 240,
                            height: size.height - 64,
                            color: Color(0xFFF9fAFB).withAlpha(216),
                            // color: Colors.transparent,
                            child: activeScreen.screen,
                          ),
                        ],
                      ),
                    ),
                  ],
                ),
              ),
            ),
            if (loadingState.isLoading)
              Positioned.fill(
                child: Container(
                  decoration: BoxDecoration(
                    borderRadius: BorderRadius.circular(8),
                    color: Colors.black.withAlpha(8), // 반투명 배경
                  ),
                  child: Center(
                    child: RotatingHouseIndicator(),
                  ),
                ),
              ),
          ],
        ),
    );
  }

  Widget _buildMenuItem({
    required String title,
    required int depth,
    IconData? icon,
    required VoidCallback onTap,
    required bool isSelected,
  }) {
    return Padding(
      padding: EdgeInsets.only(left: 12.0 * depth),
      child: Container(
        margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
        decoration: BoxDecoration(
          color: isSelected ? Color(0xFF6A8988).withAlpha(38) : null,
          borderRadius: BorderRadius.circular(8)
        ),
        child: ListTile(
          leading: icon != null ? Icon(icon, size: 20) : null,
          title: Text(
              title,
            style: TextStyle(
              fontSize: 16,
              color: Color(0xFF374151),
            ),
          ),
          onTap: onTap,
        ),
      ),
    );
  }

  Widget _buildExpansionMenu({
    required String title,
    required int depth,
    IconData? icon,
    required List<Widget> children,
    required bool isSelected,
  }) {
    return Padding(
      padding: EdgeInsets.only(left: 16.0 * depth),
      child: Theme(
        data: Theme.of(context).copyWith(dividerColor: Colors.transparent),
        child: Container(
          margin: EdgeInsets.symmetric(horizontal: 8, vertical: 4),
          decoration: BoxDecoration(
              color: isSelected ? Color(0xFF6A8988).withAlpha(38) : null,
              borderRadius: BorderRadius.circular(8)
          ),
          child: ExpansionTile(
            leading: icon != null ? Icon(icon, size: 20) : null,
            title: Text(
              title,
              style: TextStyle(
                  fontSize: 16,
                  fontWeight: isSelected ? FontWeight.bold : null,
                  color: Color(0xFF374151)
              ),
            ),
            // 색상 관련 속성 설정
            collapsedBackgroundColor: Colors.transparent, // 닫혔을 때 배경 색상
            backgroundColor: Colors.transparent, // 열렸을 때 배경 색상
            textColor: Colors.black, // 열렸을 때 텍스트 색상
            collapsedTextColor: Colors.black, // 닫혔을 때 텍스트 색상
            iconColor: Colors.black, // 열렸을 때 아이콘 색상
            collapsedIconColor: Colors.black,
            children: children, // 닫혔을 때 아이콘 색상
          ),
        ),
      ),
    );
  }
}
