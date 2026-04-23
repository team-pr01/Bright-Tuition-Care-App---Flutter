import 'package:btcclient/features/auth/data/auth_repository.dart';
import 'package:btcclient/features/auth/presentation/provider/auth_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final profileProvider =
    StateNotifierProvider<ProfileNotifier, dynamic>((ref) {
  final repo = ref.read(authRepositoryProvider);
  return ProfileNotifier(repo);
});

class ProfileNotifier extends StateNotifier<dynamic> {
  final AuthRepository repo;

  ProfileNotifier(this.repo) : super(null);

  bool isLoading = false;
  String? error;

  Future<void> fetchProfile() async {
    try {
      isLoading = true;
      error = null;

      final profile = await repo.getProfile(); // 🔥 /user/me

      state = profile;
    } catch (e) {
      error = e.toString();
    } finally {
      isLoading = false;
    }
  }
}