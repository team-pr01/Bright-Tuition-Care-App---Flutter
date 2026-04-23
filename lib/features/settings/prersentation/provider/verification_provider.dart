import 'package:flutter_riverpod/flutter_riverpod.dart';

class VerificationState {
  final String status;
  final String? addressCode;
  final bool loading;
  final String? error;

  VerificationState({
    required this.status,
    this.addressCode,
    this.loading = false,
    this.error,
  });

  VerificationState copyWith({
    String? status,
    String? addressCode,
    bool? loading,
    String? error,
  }) {
    return VerificationState(
      status: status ?? this.status,
      addressCode: addressCode ?? this.addressCode,
      loading: loading ?? this.loading,
      error: error,
    );
  }
}
final verificationProvider =
    StateNotifierProvider<VerificationNotifier, VerificationState>(
  (ref) => VerificationNotifier(),
);

class VerificationNotifier extends StateNotifier<VerificationState> {
  VerificationNotifier() : super(
    VerificationState(
      status: "pending", // 🔥 default FIRST STEP
    ),
  );

  /// 🔥 FETCH VERIFICATION STATUS
  // Future<void> fetchVerification() async {
  //   try {
  //     state = state.copyWith(loading: true);

  //     /// 🔥 API CALL
  //     final res = await api.getMyVerificationRequest();

  //     final data = res.data["data"];

  //     state = state.copyWith(
  //       status: data["status"] ?? "pending",
  //       addressCode: data["addressVerificationCode"],
  //       loading: false,
  //     );
  //   } catch (e) {
  //     state = state.copyWith(
  //       loading: false,
  //       error: e.toString(),
  //     );
  //   }
  // }

  // /// 🔥 SUBMIT ADDRESS CODE
  // Future<void> submitCode(String code) async {
  //   try {
  //     state = state.copyWith(loading: true);

  //     await api.submitAddressCode({
  //       "addressVerificationCode": code,
  //     });

  //     /// 🔥 REFRESH AFTER SUBMIT
  //     await fetchVerification();
  //   } catch (e) {
  //     state = state.copyWith(
  //       loading: false,
  //       error: e.toString(),
  //     );
  //   }
  // }

  // /// 🔥 SEND VERIFICATION REQUEST
  // Future<void> sendRequest() async {
  //   try {
  //     state = state.copyWith(loading: true);

  //     await api.sendVerificationRequest();

  //     await fetchVerification();
  //   } catch (e) {
  //     state = state.copyWith(
  //       loading: false,
  //       error: e.toString(),
  //     );
  //   }
  // }

}