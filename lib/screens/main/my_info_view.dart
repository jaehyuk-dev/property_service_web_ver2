import 'package:flutter/material.dart';
import 'package:property_service_web_ver2/core/enums/screen_type.dart';
import 'package:property_service_web_ver2/core/utils/toast_manager.dart';
import 'package:property_service_web_ver2/widgets/common/card_widget.dart';
import 'package:property_service_web_ver2/widgets/common/sub_layout.dart';
import 'package:provider/provider.dart';

import '../../core/utils/dialog_utils.dart';
import '../../widgets/common/rotating_house_indicator.dart';
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

  void onUpdateMyInfo() async {
    await DialogUtils.showAlertDialog(context: context, title: "경고!", content: "내 정보 수정");

    // 로딩 시작
    loadingState.setLoading(true);

    await Future.delayed(Duration(seconds: 1));

    // 로딩 종료
    loadingState.setLoading(false);
    ToastManager().showToast(context, "정보가 수정되었습니다.");
  }

  void onChangeMyPassword() async {
    await DialogUtils.showAlertDialog(context: context, title: "경고!", content: "비밀번호 변경");

    // 로딩 시작
    loadingState.setLoading(true);

    await Future.delayed(Duration(seconds: 1));

    // 로딩 종료
    loadingState.setLoading(false);
    ToastManager().showToast(context, "비밀번호가 변경되었습니다.");
  }

  @override
  void initState() {
    // TODO: implement initState
    loadingState = Provider.of<LoadingState>(context, listen: false);
    super.initState();
  }
  
  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        Stack(
          children: [
            CardWidget(
              width: 480,
              title: "기본 정보",
              onTap: onUpdateMyInfo,
              child: Row(
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      Text(
                        "이름",
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF374151),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        child: Text(
                          "홍길동",
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xFF111827),
                          ),
                        ),
                      ),
                      SizedBox(height: 24),
                      Text(
                        "이메일",
                        style: TextStyle(
                          fontSize: 14,
                          color: Color(0xFF374151),
                        ),
                      ),
                      Container(
                        padding: EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                        child: Text(
                          "example@email.com",
                          style: TextStyle(
                            fontSize: 16,
                            color: Color(0xFF111827),
                          ),
                        ),
                      ),
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
            ),
          ],
        ),
      ],
    );
  }
}

