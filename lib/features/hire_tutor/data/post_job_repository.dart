import 'package:dio/dio.dart';
import 'package:btcclient/features/hire_tutor/data/post_job_api.dart';

class PostJobRepository {
  final PostJobApi _api = PostJobApi();

  Future<bool> postJob(Map<String, dynamic> body) async {
    try {
      final res = await _api.postJob(body: body);

      print("✅ API SUCCESS => ${res.data}");

      return true;
    } catch (e) {
      /// 🔥 PRINT REAL ERROR
      if (e is DioException) {
        print("❌ STATUS CODE => ${e.response?.statusCode}");
        print("❌ BACKEND MESSAGE => ${e.response?.data}");
      } else {
        print("❌ UNKNOWN ERROR => $e");
      }

      return false;
    }
  }
}