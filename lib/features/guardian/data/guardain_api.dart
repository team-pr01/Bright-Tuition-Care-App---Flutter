import 'package:btcclient/core/network/dio_client.dart';

class GuardianApi {

  Future<Map<String, dynamic>> getStats() async {

    final response = await DioClient.dio.get(
      "/guardian/stats",
    );
print(response.data);
     return response.data;
  }

}