import 'package:btcclient/features/settings/data/verification_api.dart';
import 'package:dio/dio.dart';

class VerificationRepository {
  final _api = VerificationApi();

  Future<bool> sendRequest() async {
    try {
      final res = await _api.sendRequest();

      print("✅ VERIFY SUCCESS => ${res.data}");
      return true;

    } catch (e) {
      if (e is DioException) {
        print("❌ VERIFY ERROR => ${e.response?.data}");
      } else {
        print("❌ UNKNOWN ERROR => $e");
      }
      return false;
    }
  }

  Future<Map<String, dynamic>?> getMyRequest() async {
    try {
      final res = await _api.getMyRequest();

      print("📦 MY REQUEST => ${res.data}");
      return res.data;

    } catch (e) {
      print("❌ FETCH ERROR => $e");
      return null;
    }
  }
}