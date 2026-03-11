import 'package:btcclient/core/network/dio_client.dart';

class TutorApi {

  Future<Map<String, dynamic>> getStats() async {

    final response = await DioClient.dio.get(
      "/tutor/stats",
    );

    print("RAW API RESPONSE: ${response.data}");

    return response.data;
  }

}