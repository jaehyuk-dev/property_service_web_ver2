import 'package:flutter/material.dart';
import 'package:flutter_secure_storage/flutter_secure_storage.dart';
import 'package:property_service_web_ver2/core/utils/dialog_utils.dart';
import 'package:property_service_web_ver2/screens/main/main_view.dart';

import '../../core/constants/app_colors.dart';
import '../../models/auth/login_request.dart';
import '../../service/auth_service.dart';
import '../../widgets/common/rotating_house_indicator.dart';

class LoginView extends StatefulWidget {
  const LoginView({super.key});

  @override
  State<LoginView> createState() => _LoginViewState();
}

class _LoginViewState extends State<LoginView> {
  bool _isLoading = false;
  bool _autoLogin = false;
  bool _isCheckingAutoLogin = true; // 자동 로그인 체크 중인지 표시

  final TextEditingController _email = TextEditingController();
  final TextEditingController _password = TextEditingController();
  final AuthService _authService = AuthService();

  @override
  void initState() {
    super.initState();
    _initializeLogin();
  }

// 기존 LoginView의 _initializeLogin 메서드 수정
  Future<void> _initializeLogin() async {
    // 기존 자동 로그인 설정 불러오기
    final autoLoginEnabled = await _authService.isAutoLoginEnabled();
    setState(() {
      _autoLogin = autoLoginEnabled;
    });

    // 저장된 이메일 불러오기
    final savedEmail = await _authService.getSavedEmail();
    if (savedEmail != null && savedEmail.isNotEmpty) {
      _email.text = savedEmail;
    }

    // 자동 로그인 체크
    await _checkAutoLogin();

    setState(() {
      _isCheckingAutoLogin = false;
    });
  }

  // 자동 로그인 체크
  Future<void> _checkAutoLogin() async {
    try {
      final isLoggedIn = await _authService.checkAutoLogin();
      if (isLoggedIn && mounted) {
        // 자동 로그인 성공 시 메인 화면으로 이동
        Navigator.pushReplacement(
            context,
            MaterialPageRoute(builder: (context) => MainView())
        );
      }
    } catch (e) {
      print('자동 로그인 체크 실패: $e');
    }
  }

  // 로그인 요청 처리
  Future<void> signIn() async {
    // 입력 값 검증
    if (_email.text.trim().isEmpty) {
      DialogUtils.showAlertDialog(
          context: context,
          title: "입력 오류",
          content: "이메일을 입력해 주세요."
      );
      return;
    }

    if (_password.text.trim().isEmpty) {
      DialogUtils.showAlertDialog(
          context: context,
          title: "입력 오류",
          content: "비밀번호를 입력해 주세요."
      );
      return;
    }

    setState(() => _isLoading = true);

    try {
      final loginRequest = LoginRequest(
        email: _email.text.trim(),
        password: _password.text.trim(),
      );

      final loginResponse = await _authService.login(loginRequest);

      if (loginResponse != null) {
        // 자동 로그인 설정 저장
        await _authService.setAutoLogin(_autoLogin);

        setState(() => _isLoading = false);

        // 로그인 성공 시 홈 화면으로 이동
        if (mounted) {
          Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (context) => MainView())
          );
        }
      } else {
        setState(() => _isLoading = false);
        // 로그인 실패 시 알림 표시
        DialogUtils.showAlertDialog(
            context: context,
            title: "로그인 실패",
            content: "이메일과 비밀번호를 정확히 입력해 주세요."
        );
      }
    } catch (e) {
      setState(() => _isLoading = false);
      DialogUtils.showAlertDialog(
          context: context,
          title: "오류",
          content: "로그인 중 오류가 발생했습니다. 다시 시도해 주세요."
      );
    }
  }

  @override
  Widget build(BuildContext context) {
    Size size = MediaQuery.of(context).size;

    // 자동 로그인 체크 중일 때 로딩 화면 표시
    if (_isCheckingAutoLogin) {
      return Scaffold(
        body: Container(
          width: size.width,
          height: size.height,
          decoration: const BoxDecoration(
            image: DecorationImage(
              image: AssetImage('assets/silhouette-skyline-illustration/78786.jpg'),
              fit: BoxFit.cover,
            ),
          ),
          child: Center(
            child: Container(
              padding: const EdgeInsets.all(40),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(12),
                boxShadow: [
                  BoxShadow(
                    color: Colors.black.withAlpha(32),
                    blurRadius: 10,
                    spreadRadius: 2,
                    offset: const Offset(0, 5),
                  ),
                ],
              ),
              child: Column(
                mainAxisSize: MainAxisSize.min,
                children: [
                  RotatingHouseIndicator(),
                  SizedBox(height: 20),
                  Text(
                    "로그인 확인 중...",
                    style: TextStyle(
                      fontSize: 16,
                      color: Color(0xFF4B5563),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      );
    }

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
                    color: Colors.black.withAlpha(32),
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
                    keyboardType: TextInputType.emailAddress,
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
                    onSubmitted: (_) => signIn(), // 엔터키로 로그인
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
                        onPressed: () {
                          DialogUtils.showAlertDialog(
                              context: context,
                              title: "서비스 준비 중",
                              content: "서비스 준비 중입니다."
                          );
                        },
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
                      onPressed: _isLoading ? null : signIn,
                      style: ElevatedButton.styleFrom(
                        backgroundColor: Colors.black,
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(8),
                        ),
                      ),
                      child: _isLoading
                          ? SizedBox(
                        width: 20,
                        height: 20,
                        child: CircularProgressIndicator(
                          color: Colors.white,
                          strokeWidth: 2,
                        ),
                      )
                          : const Text("로그인", style: TextStyle(fontSize: 16, color: Colors.white)),
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
                        onPressed: () {
                          DialogUtils.showAlertDialog(
                              context: context,
                              title: "서비스 준비 중",
                              content: "서비스 준비 중입니다."
                          );
                        },
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
                  color: Colors.black.withOpacity(0.5),
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

  @override
  void dispose() {
    _email.dispose();
    _password.dispose();
    super.dispose();
  }
}