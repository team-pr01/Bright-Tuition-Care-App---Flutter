import 'dart:io';

import 'package:btcclient/core/network/api_exception.dart';
import 'package:dio/dio.dart';

class ApiErrorHandler {
  static String getMessage(Object error) {
    // Custom API Exception
    if (error is ApiException) {
      return error.message;
    }

    // Dio Exception
    if (error is DioException) {
      // Try extracting backend message first
      final responseData = error.response?.data;

      if (responseData is Map<String, dynamic>) {
        final message = responseData["message"];

        if (message != null && message.toString().trim().isNotEmpty) {
          return message.toString();
        }
      }

      switch (error.type) {
        case DioExceptionType.connectionTimeout:
          return "Connection timed out. Please try again.";

        case DioExceptionType.sendTimeout:
          return "Request timed out. Please try again.";

        case DioExceptionType.receiveTimeout:
          return "Server took too long to respond.";

        case DioExceptionType.connectionError:
          final e = error.error;

          if (e is SocketException) {
            return "No internet connection.";
          }

          if (e is HandshakeException) {
            return "Secure connection failed.";
          }

          return "Unable to connect to the server.";

        case DioExceptionType.badCertificate:
          return "Invalid server certificate.";

        case DioExceptionType.cancel:
          return "Request was cancelled.";

        case DioExceptionType.badResponse:
          return _handleStatusCode(error.response?.statusCode);

        case DioExceptionType.unknown:
          final e = error.error;

          if (e is SocketException) {
            return "No internet connection.";
          }

          if (e is HandshakeException) {
            return "Secure connection failed.";
          }

          return "Something went wrong. Please try again.";
      }
    }

    // Any other exception
    return error
        .toString()
        .replaceFirst("Exception: ", "")
        .replaceFirst("Error: ", "");
  }

  static String _handleStatusCode(int? statusCode) {
    switch (statusCode) {
      case 400:
        return "Bad request.";

      case 401:
        return "Unauthorized access.";

      case 403:
        return "You don't have permission to perform this action.";

      case 404:
        return "Requested resource not found.";

      case 408:
        return "Request timeout.";

      case 409:
        return "Conflict occurred.";

      case 422:
        return "Validation failed.";

      case 429:
        return "Too many requests. Please try again later.";

      case 500:
        return "Internal server error.";

      case 502:
        return "Bad gateway.";

      case 503:
        return "Service temporarily unavailable.";

      case 504:
        return "Gateway timeout.";

      default:
        return "Something went wrong.";
    }
  }
}