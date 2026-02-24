import 'package:dio/dio.dart';
import '../config/env.dart';
import '../storage/local_storage.dart';

class DioClient {

  static final Dio dio = Dio(
    BaseOptions(
      baseUrl: Env.baseUrl,
      connectTimeout: const Duration(seconds: 20),
      receiveTimeout: const Duration(seconds: 20),
      headers: {
        'Content-Type': 'application/json',
      },
    ),
  )..interceptors.add(AuthInterceptor());

}

class AuthInterceptor extends Interceptor {

  @override
  void onRequest(
      RequestOptions options,
      RequestInterceptorHandler handler) async {

    final token = await LocalStorage.getToken();

    if (token != null) {
      options.headers["Authorization"] = "Bearer $token";
    }

    handler.next(options);
  }

  @override
  void onError(
      DioException err,
      ErrorInterceptorHandler handler) async {

    if (err.response?.statusCode == 401) {

      try {

        final refreshToken =
            await LocalStorage.getRefreshToken();

        if (refreshToken == null) {
          return handler.next(err);
        }

        final response = await Dio().post(
          "${Env.baseUrl}/auth/refresh-token",
          data: {
            "refreshToken": refreshToken,
          },
        );

        final newAccessToken =
            response.data["data"]["accessToken"];

        await LocalStorage.saveToken(newAccessToken);

        /// retry original request
        final options = err.requestOptions;

        options.headers["Authorization"] =
            "Bearer $newAccessToken";

        final cloneReq =
            await DioClient.dio.fetch(options);

        return handler.resolve(cloneReq);

      } catch (e) {

        await LocalStorage.clear();

        return handler.next(err);

      }

    }

    handler.next(err);
  }

}