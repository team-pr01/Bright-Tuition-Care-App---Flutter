import 'package:btcclient/features/jobs/data/models/application_filter.dart';

class ApplicationRequest {
  final ApplicationFilter filter;

  ApplicationRequest(this.filter);

  Map<String, dynamic> toQuery() {
    return filter.toQuery();
  }
}