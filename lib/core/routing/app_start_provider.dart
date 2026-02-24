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

  final role = await LocalStorage.getRole();

  if (!seen) {
    state = AppStartState.welcome;
    return;
  }

  if (token != null && role != null) {
    state = AppStartState.authenticated;
    return;
  }

  state = AppStartState.welcome;

}

  void goToDashboard() => state = AppStartState.authenticated;
}
