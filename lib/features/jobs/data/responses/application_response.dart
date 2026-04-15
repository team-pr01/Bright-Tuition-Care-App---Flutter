import 'package:btcclient/features/jobs/data/models/application_meta.dart';
import 'package:btcclient/features/jobs/data/models/application_modal.dart';

class ApplicationResponse {
  final List<ApplicationModel> applications;
  final ApplicationMeta meta;

  ApplicationResponse({
    required this.applications,
    required this.meta,
  });

  factory ApplicationResponse.fromJson(Map<String, dynamic> json) {
    final data = json['data'];

    return ApplicationResponse(
      applications: (data['applications'] as List)
          .map((e) => ApplicationModel.fromJson(e))
          .toList(),

      // 🔥 THIS IS WHAT YOU WERE MISSING
      meta: ApplicationMeta.fromJson(data['meta']),
    );
  }
}