import 'package:btcclient/core/network/api_error_handler.dart';
import 'package:btcclient/features/refer/data/models/lead_model.dart';
import 'package:btcclient/features/refer/data/refer_repository.dart';
import 'package:btcclient/features/refer/presentation/provider/my_leads_state.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class MyLeadsNotifier extends StateNotifier<MyLeadsState> {
  final ReferRepository repository;

  MyLeadsNotifier(this.repository) : super(const MyLeadsState());

  static const int _limit = 10;

  /// ----------------------------
  /// Initial Fetch
  /// ----------------------------
  Future<void> fetchLeads({String? keyword}) async {
    state = state.copyWith(
      loading: true,
      error: null,
    );

    try {
      final response = await repository.getMyLeads(
        page: 1,
        limit: _limit,
        keyword: keyword,
      );

      state = state.copyWith(
        loading: false,
        leads: response.leads,
        currentPage: 1,
        hasMore: response.pagination.hasMore,
      );
    } catch (e) {
      state = state.copyWith(
        loading: false,
        error: ApiErrorHandler.getMessage(e),
      );
    }
  }

  /// ----------------------------
  /// Pull To Refresh
  /// ----------------------------
  Future<void> refresh({String? keyword}) async {
    state = state.copyWith(
      refreshing: true,
    );

    try {
      final response = await repository.getMyLeads(
        page: 1,
        limit: _limit,
        keyword: keyword,
      );

      state = state.copyWith(
        refreshing: false,
        leads: response.leads,
        currentPage: 1,
        hasMore: response.pagination.hasMore,
      );
    } catch (e) {
      state = state.copyWith(
        refreshing: false,
        error: ApiErrorHandler.getMessage(e),
      );
    }
  }

  /// ----------------------------
  /// Load More
  /// ----------------------------
  Future<void> loadMore({String? keyword}) async {
    if (state.loadingMore ||
        state.loading ||
        !state.hasMore) {
      return;
    }

    state = state.copyWith(
      loadingMore: true,
    );

    try {
      final nextPage = state.currentPage + 1;

      final response = await repository.getMyLeads(
        page: nextPage,
        limit: _limit,
        keyword: keyword,
      );

      state = state.copyWith(
        loadingMore: false,
        currentPage: nextPage,
        hasMore: response.pagination.hasMore,
        leads: [
          ...state.leads,
          ...response.leads,
        ],
      );
    } catch (e) {
      state = state.copyWith(
        loadingMore: false,
        error: ApiErrorHandler.getMessage(e),
      );
    }
  }

  /// ----------------------------
  /// Update one Lead locally
  /// ----------------------------
  void updateLead(LeadModel lead) {
    final index = state.leads.indexWhere(
      (e) => e.id == lead.id,
    );

    if (index == -1) return;

    final updated = [...state.leads];
    updated[index] = lead;

    state = state.copyWith(
      leads: updated,
    );
  }

  /// ----------------------------
  /// Clear Error
  /// ----------------------------
  void clearError() {
    state = state.copyWith(
      error: null,
    );
  }
}