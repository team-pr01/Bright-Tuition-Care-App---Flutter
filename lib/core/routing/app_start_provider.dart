import 'package:flutter_riverpod/flutter_riverpod.dart';
import '../storage/local_storage.dart';

enum AppStartState { loading, welcome,  authenticated }

final appStartProvider =
    StateNotifierProvider<AppStartNotifier, AppStartState>((ref) {
  return AppStartNotifier();
});

class AppStartNotifier extends StateNotifier<AppStartState> {
  AppStartNotifier() : super(AppStartState.loading) {
    _init();
  }

  Future<void> _init() async {
    final seen = await LocalStorage.isWelcomeSeen();
    final token = await LocalStorage.getToken();
 
    if (!seen || token == null) {
      state = AppStartState.welcome;
    }
    else{
      state = AppStartState.authenticated ;
    }
  }

  void goToDashboard() => state = AppStartState.authenticated;
}
