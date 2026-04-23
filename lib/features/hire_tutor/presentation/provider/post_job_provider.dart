import 'package:btcclient/features/hire_tutor/presentation/notifier/post_job_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final postJobProvider =
    StateNotifierProvider<PostJobNotifier, PostJobState>((ref) {
  return PostJobNotifier(ref); // 🔥 PASS REF HERE
});