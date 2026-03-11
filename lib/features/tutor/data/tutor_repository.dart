import 'tutor_api.dart';

class TutorRepository {

  final TutorApi api;

  TutorRepository(this.api);

  Future<Map<String, dynamic>> getStats() async {
    return await api.getStats();
  }

}