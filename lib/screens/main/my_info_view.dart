import 'package:flutter/material.dart';
import 'package:property_service_web_ver2/core/enums/screen_type.dart';
import 'package:property_service_web_ver2/core/utils/toast_manager.dart';
import 'package:property_service_web_ver2/widgets/common/card_widget.dart';
import 'package:property_service_web_ver2/widgets/common/sub_layout.dart';
import 'package:provider/provider.dart';

import '../../core/utils/dialog_utils.dart';
import '../../models/user/user_info.dart';
import '../../widgets/common/rotating_house_indicator.dart';
import '../user/user_service.dart';
import 'main_view.dart';

class MyInfo extends StatelessWidget {
  const MyInfo({super.key});

  @override
  Widget build(BuildContext context) {
    return SubLayout(screenType: ScreenType.MyInfo, child: MyInfoView());
  }
}

class MyInfoView extends StatefulWidget {
  const MyInfoView({super.key});

  @override
  State<MyInfoView> createState() => _MyInfoViewState();
}

class _MyInfoViewState extends State<MyInfoView> {
  late LoadingState loadingState;
  UserInfo? userInfo;
  bool isLoading = true;

  @override
  void initState() {
    super.initState();
    loadingState = Provider.of<LoadingState>(context, listen: false);
    _loadUserInfo();
  }

  Future<void> _loadUserInfo() async {
    setState(() {
      isLoading = true;
    });

    try {
      final info = await UserService().getCurrentUserInfo();
      setState(() {
        userInfo = info;
        isLoading = false;
      });
    } catch (e) {
      setState(() {
        isLoading = false;
      });
      ToastManager().showToast(context, "사용자 정보를 불러오는데 실패했습니다.");
    }
  }

  void onUpdateMyInfo() async {
    await DialogUtils.showAlertDialog(
        context: context, title: "경고!", content: "내 정보 수정");

    // 로딩 시작
    loadingState.setLoading(true);

    await Future.delayed(Duration(seconds: 1));

    // 로딩 종료
    loadingState.setLoading(false);
    ToastManager().showToast(context, "정보가 수정되었습니다.");
  }

  void onChangeMyPassword() async {
    await DialogUtils.showAlertDialog(
        context: context, title: "경고!", content: "비밀번호 변경");

    // 로딩 시작
    loadingState.setLoading(true);

    await Future.delayed(Duration(seconds: 1));

    // 로딩 종료
    loadingState.setLoading(false);
    ToastManager().showToast(context, "비밀번호가 변경되었습니다.");
  }

  @override
  Widget build(BuildContext context) {
    if (isLoading) {
      return Center(
        child: RotatingHouseIndicator(), // 로딩 인디케이터
      );
    }

    if (userInfo == null) {
      return Container();
    }

    return CardWidget(
      width: 480,
      title: "기본 정보",
      onEditTap: onUpdateMyInfo,
      child: Row(
        children: [
          Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              _buildInfoField("이름", userInfo!.name),
              SizedBox(height: 24),
              _buildInfoField("이메일", userInfo!.email),
              SizedBox(height: 24),
              _buildInfoField("전화번호", userInfo!.phoneNumber),
              SizedBox(height: 24),
              _buildInfoField("역할", userInfo!.role),
              if (userInfo!.officeName != null) ...[
                SizedBox(height: 24),
                _buildInfoField("사무소명", userInfo!.officeName!),
              ],
              SizedBox(height: 24),
              InkWell(
                onTap: onChangeMyPassword,
                child: Container(
                  height: 48,
                  width: 480 - 72,
                  padding: EdgeInsets.symmetric(vertical: 12),
                  decoration: BoxDecoration(
                    color: const Color(0xFFF3F4F6),
                    borderRadius: BorderRadius.circular(8),
                  ),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        "비밀번호 변경",
                        style: TextStyle(
                          fontSize: 16,
                          color: const Color(0xFF374151),
                        ),
                      ),
                    ],
                  ),
                ),
              )
            ],
          ),
        ],
      ),
    );
  }

  Widget _buildInfoField(String label, String value) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Text(
          label,
          style: TextStyle(
            fontSize: 14,
            color: Color(0xFF374151),
          ),
        ),
        Container(
          padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Text(
            value,
            style: TextStyle(
              fontSize: 16,
              color: Color(0xFF111827),
            ),
          ),
        ),
      ],
    );
  }
}