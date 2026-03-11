import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/tutor_api.dart';
import '../../data/tutor_repository.dart';

final tutorRepositoryProvider = Provider<TutorRepository>((ref) {

  final api = TutorApi();

  return TutorRepository(api);

});