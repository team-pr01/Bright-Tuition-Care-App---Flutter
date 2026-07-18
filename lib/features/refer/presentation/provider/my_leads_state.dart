import '../../data/models/lead_model.dart';

class MyLeadsState {
  final List<LeadModel> leads;

  final bool loading;

  final bool loadingMore;

  final bool refreshing;

  final bool hasMore;

  final int currentPage;

  final String? error;

  const MyLeadsState({
    this.leads = const [],
    this.loading = false,
    this.loadingMore = false,
    this.refreshing = false,
    this.hasMore = true,
    this.currentPage = 1,
    this.error,
  });

  MyLeadsState copyWith({
    List<LeadModel>? leads,
    bool? loading,
    bool? loadingMore,
    bool? refreshing,
    bool? hasMore,
    int? currentPage,
    String? error,
  }) {
    return MyLeadsState(
      leads: leads ?? this.leads,
      loading: loading ?? this.loading,
      loadingMore: loadingMore ?? this.loadingMore,
      refreshing: refreshing ?? this.refreshing,
      hasMore: hasMore ?? this.hasMore,
      currentPage: currentPage ?? this.currentPage,
      error: error,
    );
  }
}