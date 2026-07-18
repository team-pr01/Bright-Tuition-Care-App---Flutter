import 'package:btcclient/features/auth/data/auth_repository.dart';
import 'package:btcclient/features/auth/presentation/provider/auth_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final profileProvider =
    StateNotifierProvider<ProfileNotifier, dynamic>((ref) {

  final repo =
      ref.read(authRepositoryProvider);

  return ProfileNotifier(repo);
});

class ProfileNotifier
    extends StateNotifier<dynamic> {

  final AuthRepository repo;

  ProfileNotifier(this.repo)
      : super(null);

  bool isLoading = false;

  String? error;

  /// ================= FETCH =================

  Future<void> fetchProfile() async {

    try {

      isLoading = true;

      error = null;

      state = null;

      final profile =
          await repo.getProfile();

      state = profile;

    } catch (e) {

      print(
        "❌ PROFILE ERROR => $e",
      );

      error = e.toString();

    } finally {

      isLoading = false;
    }
  }

  /// ================= REFRESH =================

  Future<void> refreshProfile() async {

    await fetchProfile();
  }

  /// ================= CLEAR =================

  void clearProfile() {

    state = null;

    error = null;

    isLoading = false;
  }
}