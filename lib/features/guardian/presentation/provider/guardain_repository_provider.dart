import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../../data/guardain_api.dart';
import '../../data/guardain_repository.dart';

final guardianRepositoryProvider = Provider<GuardianRepository>((ref) {

  final api = GuardianApi();

  return GuardianRepository(api);

});