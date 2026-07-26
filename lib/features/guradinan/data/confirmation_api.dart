import 'package:btcclient/core/network/api_error_handler.dart';
import 'package:btcclient/core/network/api_exception.dart';
import 'package:dio/dio.dart';
import 'package:flutter/foundation.dart';

class ConfirmationApi {
  final Dio dio;

  ConfirmationApi(this.dio);

  /// ================= GET TUTOR LETTERS =================
  Future<Response> getTutorConfirmationLetter() async {
    try {
      return await dio.get(
        "/confirmation-letter/tutor/my",
      );
    } on DioException catch (e) {
      throw ApiException(ApiErrorHandler.getMessage(e));
    }
  }

  /// ================= GET GUARDIAN LETTERS =================
  Future<Response> getGuardianConfirmationLetter() async {
    try {
      return await dio.get(
        "/confirmation-letter/guardian/my",
      );
    } on DioException catch (e) {
      throw ApiException(ApiErrorHandler.getMessage(e));
    }
  }

  /// ================= GET SINGLE LETTER =================
  Future<Response> getConfirmationLetterById(String id) async {
    try {
      return await dio.get(
        "/confirmation-letter/$id",
      );
    } on DioException catch (e) {
      throw ApiException(ApiErrorHandler.getMessage(e));
    }
  }

  /// ================= SIGN TUTOR LETTER =================
  Future<Response> signTutorConfirmationLetter({
    required String id,
    required String signature,
  }) async {
    try {
      final response = await dio.patch(
        "/confirmation-letter/sign/tutor/$id",
        data: {
          "signature": signature,
        },
      );

      debugPrint("✅ Tutor signed confirmation letter");
      debugPrint(response.data.toString());

      return response;
    } on DioException catch (e) {
      debugPrint("❌ Tutor Sign Error");
      debugPrint(e.response?.data.toString());

      throw ApiException(ApiErrorHandler.getMessage(e));
    }
  }

  /// ================= SIGN GUARDIAN LETTER =================
  Future<Response> signGuardianConfirmationLetter({
    required String id,
    required String signature,
  }) async {
    try {
      final response = await dio.patch(
        "/confirmation-letter/sign/guardian/$id",
        data: {
          "signature": signature,
        },
      );

      debugPrint("✅ Guardian signed confirmation letter");
      debugPrint(response.data.toString());

      return response;
    } on DioException catch (e) {
      debugPrint("❌ Guardian Sign Error");
      debugPrint(e.response?.data.toString());

      throw ApiException(ApiErrorHandler.getMessage(e));
    }
  }
}