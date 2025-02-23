import 'package:dio/dio.dart';
import 'package:logger/logger.dart';

class ApiUtils {
  static final ApiUtils _instance = ApiUtils._internal();
  factory ApiUtils() => _instance;

  late Dio _dio;

  Dio get dio => _dio;

  ApiUtils._internal() {
    _dio = Dio(
      BaseOptions(
        baseUrl: 'http://localhost:8080/api',
        connectTimeout: const Duration(seconds: 30),
        receiveTimeout: const Duration(seconds: 30),
        headers: {
          'Content-Type': 'application/json',
          'Accept': 'application/json',
        },
      ),
    );

    // Logger 인터셉터 추가
    _dio.interceptors.add(DioLoggerInterceptor());
  }

  // 토큰 설정 (예: 로그인 후 저장)
  void setToken(String token) {
    _dio.options.headers['Authorization'] = token;
  }

  // GET 요청
  Future<Response> get(String endpoint, {Map<String, dynamic>? params}) async {
    try {
      return await _dio.get(endpoint, queryParameters: params);
    } catch (e) {
      return _handleError(e);
    }
  }

  // POST 요청
  Future<Response> post(String endpoint, {dynamic data}) async {
    try {
      return await _dio.post(endpoint, data: data);
    } catch (e) {
      return _handleError(e);
    }
  }

  // PUT 요청
  Future<Response> put(String endpoint, {dynamic data}) async {
    try {
      return await _dio.put(endpoint, data: data);
    } catch (e) {
      return _handleError(e);
    }
  }

  // DELETE 요청
  Future<Response> delete(String endpoint, {dynamic data}) async {
    try {
      return await _dio.delete(endpoint, data: data);
    } catch (e) {
      return _handleError(e);
    }
  }

  // 오류 처리
  Response _handleError(dynamic error) {
    if (error is DioException) {
      switch (error.type) {
        case DioExceptionType.connectionTimeout:
          throw Exception("Connection timeout");
        case DioExceptionType.receiveTimeout:
          throw Exception("Receive timeout");
        case DioExceptionType.sendTimeout:
          throw Exception("Send timeout");
        case DioExceptionType.badResponse:
          throw Exception("Bad response: ${error.response?.statusCode}");
        case DioExceptionType.cancel:
          throw Exception("Request cancelled");
        case DioExceptionType.unknown:
        default:
          throw Exception("Unknown error: ${error.message}");
      }
    } else {
      throw Exception("Unexpected error: $error");
    }
  }
}


class DioLoggerInterceptor extends Interceptor {
  final Logger logger = Logger(
    printer: PrettyPrinter(
      methodCount: 2, // 호출 스택 깊이
      errorMethodCount: 5, // 오류 발생 시 호출 스택 깊이
      lineLength: 80, // 한 줄에 출력할 최대 길이
      colors: true, // 색상 활성화
      printEmojis: true, // 이모지 포함 여부
      printTime: false, // 타임스탬프 포함 여부
    ),
  );

  @override
  void onRequest(RequestOptions options, RequestInterceptorHandler handler) {
    logger.i(
      "📤 [REQUEST] ${options.method} ${options.uri}\n"
          "Headers: ${options.headers}\n"
          "Data: ${options.data}",
    );
    super.onRequest(options, handler);
  }

  @override
  void onResponse(Response response, ResponseInterceptorHandler handler) {
    logger.i(
      "📥 [RESPONSE] ${response.requestOptions.method} ${response.requestOptions.uri}\n"
          "Status: ${response.statusCode}\n"
          "Data: ${response.data}",
    );
    super.onResponse(response, handler);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) {
    logger.e(
      "⚠️ [ERROR] ${err.requestOptions.method} ${err.requestOptions.uri}\n"
          "Message: ${err.message}\n"
          "StackTrace: ${err.stackTrace}",
    );
    super.onError(err, handler);
  }
}
