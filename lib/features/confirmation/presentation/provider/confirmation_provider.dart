import 'package:btcclient/core/network/dio_client.dart';
import 'package:btcclient/features/confirmation/data/confirmation_api.dart';
import 'package:btcclient/features/confirmation/data/confirmation_repository.dart';
import 'package:btcclient/features/confirmation/presentation/notifier/confirmation_notifier.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

/// ================= API =================
final confirmationApiProvider = Provider<ConfirmationApi>((ref) {
  return ConfirmationApi(DioClient.dio);
});

/// ================= REPOSITORY =================
final confirmationRepositoryProvider =
    Provider<ConfirmationRepository>((ref) {
  return ConfirmationRepository(
    ref.read(confirmationApiProvider),
  );
});

/// ================= NOTIFIER =================
final confirmationProvider =
    StateNotifierProvider<
        ConfirmationNotifier,
        ConfirmationState>((ref) {
  return ConfirmationNotifier(
    ref.read(confirmationRepositoryProvider),
  );
});