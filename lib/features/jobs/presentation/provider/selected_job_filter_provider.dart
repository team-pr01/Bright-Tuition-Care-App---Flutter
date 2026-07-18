import 'package:btcclient/features/jobs/data/models/job_filter.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final selectedJobFilterProvider =
    StateProvider<JobFilter?>((ref) => null);