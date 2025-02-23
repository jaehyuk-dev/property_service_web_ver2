import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:property_service_web_ver2/core/utils/dialog_utils.dart';

import '../../core/constants/app_colors.dart';
import '../../repository/auth/auth_repository.dart';
import '../../widgets/common/rotating_house_indicator.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  final AuthRepository _authRepository = AuthRepository();

  bool _isLoading = false;
  bool _autoLogin = false;

  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();

  // 로그인 요청 처리
  Future<void> signIn() async {
    setState(() => _isLoading = true);

    bool success = await _authRepository.signIn(_email.text, _password.text);

    setState(() => _isLoading = false);

    if (success) {
      // 로그인 성공 시 홈 화면으로 이동
      if (mounted) {
        Navigator.pushReplacementNamed(context, '/main',);
      }
    } else {
      // 로그인 실패 시 알림 표시
      DialogUtils.showAlertDialog(context: context, title: "로그인 실패", content: "이메일과 비밀번호를 정확히 입력해 주세요.");
    }
  }

  @override
  void initState() {
    super.initState();
    _checkAutoLogin();
  }

  // 자동 로그인 체크
  Future<void> _checkAutoLogin() async {
    bool isLoggedIn = await _authRepository.checkAutoLogin();
    if (isLoggedIn && mounted) {
      Navigator.pushReplacementNamed(context, '/home');
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    return Scaffold(
      body: Stack(
        children: [
          // 배경 이미지
          Container(
            width: size.width,
            height: size.height,
            decoration: const BoxDecoration(
              image: DecorationImage(
                image: AssetImage('assets/silhouette-skyline-illustration/78786.jpg'),
                fit: BoxFit.cover,
              ),
            ),
          ),
          // 로그인 폼
          Center(
            child: Container(
              width: 400,
              padding: const EdgeInsets.all(24),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(64),
                    blurRadius: 10,
                    spreadRadius: 2,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  const SizedBox(height: 24),
                  const Text(
                    "Property Service",
                    style: TextStyle(
                      fontSize: 30,
                      fontWeight: FontWeight.bold,
                      // color: AppColors.color6,
                      color: Color(0xFF111827),
                    ),
                  ),
                  const SizedBox(height: 16),
                  Text(
                    "부동산 영업 관리 포털에 오신 것을 환영합니다.",
                    style: TextStyle(fontSize: 14, color: Color(0xFF4B5563)),
                  ),
                  const SizedBox(height: 32),

                  // 이메일 입력 필드
                  TextField(
                    controller: _email,
                    decoration: InputDecoration(
                      labelText: "이메일",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: AppColors.color5, width: 2.0),
                      ),
                      labelStyle: TextStyle(color: Colors.grey[800]),
                    ),
                  ),
                  const SizedBox(height: 16),

                  // 비밀번호 입력 필드
                  TextField(
                    controller: _password,
                    obscureText: true,
                    decoration: InputDecoration(
                      labelText: "비밀번호",
                      border: OutlineInputBorder(
                        borderRadius: BorderRadius.circular(8),
                      ),
                      focusedBorder: OutlineInputBorder(
                        borderSide: BorderSide(color: AppColors.color5, width: 2.0),
                      ),
                      labelStyle: TextStyle(color: Colors.grey[800]),
                    ),
                  ),
                  const SizedBox(height: 8),

                  // 자동 로그인 & 비밀번호 찾기
                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      Row(
                        children: [
                          Checkbox(
                            value: _autoLogin,
                            onChanged: (value) {
                              setState(() => _autoLogin = value!);
                            },
                            activeColor: Colors.grey[800],
                            overlayColor: WidgetStateProperty.all(Colors.transparent),
                          ),
                          GestureDetector(
                            onTap: () => setState(() => _autoLogin = !_autoLogin),
                            child: const Text("자동 로그인", style: TextStyle(color: Color(0xFF4B5563))),
                          ),
                        ],
                      ),
                      TextButton(
                        onPressed: () {},
                        style: ButtonStyle(
                          overlayColor: WidgetStateProperty.all(AppColors.color1),
                        ),
                        child: Text("비밀번호 찾기", style: TextStyle(color: Colors.grey[800])),
                      ),
                    ],
                  ),
                  const SizedBox(height: 24),

                  // 로그인 버튼
                  SizedBox(
                    width: double.infinity,
                    height: 50,
                    child: ElevatedButton(
                      onPressed: signIn,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: const Text("로그인", style: TextStyle(fontSize: 16, color: Colors.white)),
                    ),
                  ),

                  const SizedBox(height: 16),

                  // 회원가입 링크
                  Row(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      const Text("아직 회원이 아니신가요?", style: TextStyle(color: Color(0xFF4B5563))),
                      SizedBox(width: 8),
                      TextButton(
                        onPressed: () {}, // 회원가입 기능 추가
                        style: ButtonStyle(
                          overlayColor: WidgetStateProperty.all(AppColors.color1),
                        ),
                        child: Text("회원가입", style: TextStyle(fontWeight: FontWeight.bold, color: Colors.grey[800])),
                      ),
                    ],
                  ),
                ],
              ),
            ),
          ),
          if (_isLoading)
            Positioned.fill(
              child: Container(
                decoration: BoxDecoration(
                  color: Colors.black.withOpacity(0.5), // 반투명 배경
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
}
