import 'package:flutter/material.dart';

import '../constants/app_colors.dart';

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
}