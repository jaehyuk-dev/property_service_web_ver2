import 'package:flutter/material.dart';
import 'package:kpostal_web/model/kakao_address.dart';

import '../../widgets/common/rotating_house_indicator.dart';
import '../constants/app_colors.dart';
import 'custom_kakao_address_widget.dart';

class DialogUtils {

  static Future<T?> showCustomDialog<T>({
    required BuildContext context,
    required String title,
    required Widget child,
    double width = 400,
    String confirmText = "저장",
    String cancelText = "취소",
    required Future<T?> Function() onConfirm, // ✅ Future<T?> 적용
  }) async {
    final result = await showDialog<T?>(
      context: context,
      builder: (context)  {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8), // 테두리 둥근 정도
          ),
          child: SizedBox(
            width: width,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.home, size: 32, color: AppColors.color4),
                          SizedBox(width: 12),
                          Text(
                            title,
                            style: TextStyle(
                              fontSize: 18, // 제목 글자 크기
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      InkWell(
                          onTap: ()=> Navigator.pop(context),
                          child: Icon(Icons.close, size: 28, color: Color(0xFF9CA3AF))
                      ),
                    ],
                  ),
                ),
                Divider(height: 0, thickness: 1, color: Colors.grey[400]),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 36, vertical: 24),
                  alignment: Alignment.center,
                  child: child
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 24),
                      child: InkWell(
                        onTap: ()=>Navigator.pop(context),
                        child: Container(
                          width: 76,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Color(0xFFF3F4F6),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Center(
                            child: Text(
                              cancelText,
                              style: const TextStyle(
                                fontSize: 16, // 버튼 글자 크기
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF6A8988),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 12),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 24),
                      child: InkWell(
                        onTap: () async {
                          onConfirm();
                        },
                        child: Container(
                          width: 76,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Color(0xFF6A8988),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Center(
                            child: Text(
                              confirmText,
                              style: const TextStyle(
                                fontSize: 16, // 버튼 글자 크기
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
    return result;
  }

  static Future<void> showAlertDialog({
    required BuildContext context,
    required String title,
    required String content,
    double width = 400,
    String confirmText = "확인",
  }) async {
    await showDialog(
      context: context,
      builder: (context)  {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8), // 테두리 둥근 정도
          ),
          child: SizedBox(
            width: 400,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.home, size: 32, color: AppColors.color4),
                          SizedBox(width: 12),
                          Text(
                            title,
                            style: TextStyle(
                              fontSize: 18, // 제목 글자 크기
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      InkWell(
                          onTap: ()=> Navigator.pop(context),
                          child: Icon(Icons.close, size: 28, color: Color(0xFF9CA3AF))
                      ),
                    ],
                  ),
                ),
                Divider(height: 0, thickness: 1, color: Colors.grey[400]),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 36, vertical: 24),
                  alignment: Alignment.center,
                  child: Text(
                    content,
                    style: const TextStyle(
                      fontSize: 16, // 내용 글자 크기
                    ),
                  ),
                ),
                Center(
                  child: Padding(
                    padding: const EdgeInsets.only(bottom: 24),
                    child: InkWell(
                      onTap: () => Navigator.pop(context),
                      child: Container(
                        width: 76,
                        height: 40,
                        decoration: BoxDecoration(
                          color: Color(0xFF6A8988),
                          borderRadius: BorderRadius.circular(4),
                        ),
                        child: Center(
                          child: Text(
                                confirmText,
                                style: const TextStyle(
                                    fontSize: 16, // 버튼 글자 크기
                                    fontWeight: FontWeight.w600,
                                    color: Colors.white,
                                ),
                          ),
                        ),
                      ),
                    ),
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }

  static Future<bool> showConfirmDialog({
    required BuildContext context,
    required String title,
    required String content,
    double width = 400,
    String confirmText = "확인",
    String cancelText = "취소",
  }) async {
    final result = await showDialog(
      context: context,
      builder: (context)  {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8), // 테두리 둥근 정도
          ),
          child: SizedBox(
            width: 400,
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                Padding(
                  padding: const EdgeInsets.all(24),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Icon(Icons.home, size: 32, color: AppColors.color4),
                          SizedBox(width: 12),
                          Text(
                            title,
                            style: TextStyle(
                              fontSize: 18, // 제목 글자 크기
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ],
                      ),
                      InkWell(
                          onTap: ()=> Navigator.pop(context),
                          child: Icon(Icons.close, size: 28, color: Color(0xFF9CA3AF))
                      ),
                    ],
                  ),
                ),
                Divider(height: 0, thickness: 1, color: Colors.grey[400]),
                Container(
                  padding: EdgeInsets.symmetric(horizontal: 36, vertical: 24),
                  alignment: Alignment.center,
                  child: Text(
                    content,
                    style: const TextStyle(
                      fontSize: 16, // 내용 글자 크기
                    ),
                  ),
                ),
                Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Padding(
                      padding: const EdgeInsets.only(bottom: 24),
                      child: InkWell(
                        onTap: ()=>Navigator.pop(context),
                        child: Container(
                          width: 76,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Color(0xFFF3F4F6),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Center(
                            child: Text(
                              cancelText,
                              style: const TextStyle(
                                fontSize: 16, // 버튼 글자 크기
                                fontWeight: FontWeight.w600,
                                color: Color(0xFF6A8988),
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                    SizedBox(width: 12),
                    Padding(
                      padding: const EdgeInsets.only(bottom: 24),
                      child: InkWell(
                        onTap: ()=>Navigator.pop(context, true),
                        child: Container(
                          width: 76,
                          height: 40,
                          decoration: BoxDecoration(
                            color: Color(0xFF6A8988),
                            borderRadius: BorderRadius.circular(4),
                          ),
                          child: Center(
                            child: Text(
                              confirmText,
                              style: const TextStyle(
                                fontSize: 16, // 버튼 글자 크기
                                fontWeight: FontWeight.w600,
                                color: Colors.white,
                              ),
                            ),
                          ),
                        ),
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );
    return result ?? false;
  }

  /// 주소 찾기 다이얼로그
  static Future<KakaoAddress?> showAddressSearchDialog({
    required BuildContext context,
  }) async {
    bool isPopped = false; // 다이얼로그가 닫혔는지 확인하는 플래그

    return await showDialog<KakaoAddress>(
      context: context,
      builder: (context) {
        return Dialog(
          backgroundColor: Colors.white,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(8),
          ),
          child: Container(
            width: 480,
            height: 640,
            padding: EdgeInsets.all(16),
            child: Column(
              children: [
                Row(
                  mainAxisAlignment: MainAxisAlignment.spaceBetween,
                  children: [
                    Text(
                      "주소찾기",
                      style: TextStyle(
                        fontSize: 20,
                        fontWeight: FontWeight.w700,
                        color: Colors.black,
                      ),
                    ),
                    IconButton(
                      onPressed: () {
                        if (!isPopped) {
                          isPopped = true;
                          Navigator.of(context).pop(); // 다이얼로그 닫기
                        }
                      },
                      icon: Icon(
                        Icons.close,
                        size: 32,
                        color: Colors.black,
                      ),
                    ),
                  ],
                ),
                SizedBox(height: 8),
                Expanded(
                  child: Stack(
                    children: [
                      Center(
                        child: RotatingHouseIndicator(),
                      ),
                      SingleChildScrollView(
                        child: CustomKakaoAddressWidget(
                          onComplete: (KakaoAddress kakaoAddress) {
                            if (!isPopped) {
                              Navigator.of(context).pop(kakaoAddress); // 주소 데이터를 반환하며 다이얼로그 닫기
                              isPopped = true;
                            }
                          },
                          onClose: () {
                            if (!isPopped) {
                              Navigator.of(context).pop(); // 다이얼로그 닫기
                              isPopped = true;
                            }
                          },
                        ),
                      ),
                    ],
                  ),
                ),
              ],
            ),
          ),
        );
      },
    );
  }
}