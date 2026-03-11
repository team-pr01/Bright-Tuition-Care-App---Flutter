import 'guardain_api.dart';

class GuardianRepository {

  final GuardianApi api;

  GuardianRepository(this.api);

  Future<Map<String, dynamic>> getStats() async {
    return await api.getStats();
  }

}