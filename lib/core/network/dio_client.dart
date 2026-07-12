import 'package:dio/dio.dart';
import '../config/env.dart';
import '../storage/local_storage.dart';

class DioClient {
  static final Dio dio = Dio(
    BaseOptions(
      baseUrl: Env.baseUrl,
      connectTimeout: const Duration(seconds: 20),
      receiveTimeout: const Duration(seconds: 20),
      headers: {'Content-Type': 'application/json'},
      // ADD THIS
      validateStatus: (status) => status != null && status < 500,
    ),
  )..interceptors.add(AuthInterceptor());
}

class AuthInterceptor extends Interceptor {
  bool _isRefreshing = false;

  Future<String?>? _refreshFuture;
  @override
  void onRequest(
    RequestOptions options,
    RequestInterceptorHandler handler,
  ) async {
    final token = await LocalStorage.getToken();
    if (token != null && token.isNotEmpty) {
      options.headers["Authorization"] = token;
    }
    handler.next(options);
  }

  @override
  void onError(DioException err, ErrorInterceptorHandler handler) async {
    if (err.response?.statusCode != 401) {
      return handler.next(err);
    }

    try {
      final options = err.requestOptions;

      // Prevent infinite retry
      if (options.extra["retry"] == true) {
        await LocalStorage.clearSession();
        return handler.next(err);
      }

      String? newToken;

      if (_isRefreshing) {
        newToken = await _refreshFuture;
      } else {
        _isRefreshing = true;
        _refreshFuture = _refreshToken();

        newToken = await _refreshFuture;

        _isRefreshing = false;
      }

      if (newToken == null) {
        await LocalStorage.clearSession();
        return handler.next(err);
      }

      options.headers["Authorization"] = newToken;

      options.extra["retry"] = true;

      final response = await DioClient.dio.fetch(options);

      return handler.resolve(response);
    } catch (_) {
      _isRefreshing = false;

      await LocalStorage.clearSession();

      return handler.next(err);
    }
  }

  Future<String?> _refreshToken() async {
    final refreshToken = await LocalStorage.getRefreshToken();

    if (refreshToken == null) {
      return null;
    }

    try {
      final dio = Dio(
        BaseOptions(
          baseUrl: Env.baseUrl,
          headers: {"Content-Type": "application/json"},
        ),
      );

      final response = await dio.post(
        "/auth/refresh-token",
        data: {"refreshToken": refreshToken},
      );

      final responseData = response.data;

      if (responseData["success"] != true) {
        return null;
      }

      final data = responseData["data"];

      if (data == null) {
        return null;
      }

      final accessToken = data["accessToken"];

      if (accessToken == null) {
        return null;
      }

      await LocalStorage.saveToken(accessToken);

      return accessToken;
    } catch (_) {
      return null;
    }
  }
}
