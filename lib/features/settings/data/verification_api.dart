import 'package:btcclient/features/settings/data/requests/submit_address_code_request.dart';
import 'package:dio/dio.dart';
import '../../../../core/network/dio_client.dart';

class VerificationApi {
  /// 🔥 SEND REQUEST
  Future<Response> sendRequest() async {
    return await DioClient.dio.post("/profile-verification/send-request");
  }

  /// 🔥 GET MY REQUEST
  Future<Response> getMyRequest() async {
    return await DioClient.dio.get("/profile-verification/my-request");
  }

  Future<Response> submitAddressCode(SubmitAddressCodeRequest request) async {
    return await DioClient.dio.patch(
      "/profile-verification/submit-address-code",

      data: request.toJson(),
    );
  }
}
