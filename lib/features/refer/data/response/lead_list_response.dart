import '../models/lead_model.dart';

class LeadListResponse {
  final bool success;
  final String message;
  final List<LeadModel> leads;
  final LeadPagination pagination;

  const LeadListResponse({
    required this.success,
    required this.message,
    required this.leads,
    required this.pagination,
  });

  factory LeadListResponse.fromJson(Map<String, dynamic> json) {
    final data = json["data"] ?? {};

    return LeadListResponse(
      success: json["success"] ?? false,
      message: json["message"] ?? "",
      leads: (data["leads"] as List? ?? [])
          .map((e) => LeadModel.fromJson(e))
          .toList(),
      pagination: LeadPagination.fromJson(data["meta"] ?? {}),
    );
  }
}

class LeadPagination {
  final int total;
  final int page;
  final int limit;
  final int totalPages;

  const LeadPagination({
    required this.total,
    required this.page,
    required this.limit,
    required this.totalPages,
  });

  factory LeadPagination.fromJson(Map<String, dynamic> json) {
    return LeadPagination(
      total: json["total"] ?? 0,
      page: json["page"] ?? 1,
      limit: json["limit"] ?? 10,
      totalPages: json["totalPages"] ?? 1,
    );
  }

  bool get hasMore => page < totalPages;
}