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

  Future<bool> updateJob(String id, Map<String, dynamic> body) async {
    try {
      final res = await _api.updateJob(jobId: id, body: body);
      print("✏️ UPDATE SUCCESS => ${res.data}");
      return true;
    } catch (e) {
      _handleError(e);
      return false;
    }
  }

  void _handleError(dynamic e) {
    if (e is DioException) {
      print("❌ STATUS => ${e.response?.statusCode}");
      print("❌ BACKEND => ${e.response?.data}");
    } else {
      print("❌ ERROR => $e");
    }
  }
}