import 'package:btcclient/core/network/api_error_handler.dart';
import 'package:btcclient/core/network/api_exception.dart';
import 'package:btcclient/core/network/dio_client.dart';
import 'package:btcclient/features/profile/data/requests/update_personal_info_request.dart';
import 'package:dio/dio.dart';

Future<void> updatePersonalInfo(
  UpdatePersonalInfoRequest request,
) async {
  try {
   await DioClient.dio.patch(
  "/user/update-profile",
  data: request.toJson(),
);
  } on DioException catch (e) {
    throw ApiException(
      ApiErrorHandler.getMessage(e),
    );
  } catch (e) {
    throw ApiException(
      ApiErrorHandler.getMessage(e),
    );
  }
}