import 'package:btcclient/features/settings/data/requests/submit_address_code_request.dart';
import 'package:btcclient/features/settings/data/verification_api.dart';
import 'package:dio/dio.dart';
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
  VerificationNotifier()
    : super(
        VerificationState(
          status: "pending", // 🔥 default FIRST STEP
        ),
      );
  final api = VerificationApi();
  Future<void> fetchVerification() async {
    try {
      state = state.copyWith(loading: true, error: null);

      final res = await api.getMyRequest();
      final data = res.data["data"];
      print("========== VERIFICATION API ==========");
      print(res.data);
      print("STATUS => ${data?["status"]}");
      print("ADDRESS CODE => ${data?["addressVerificationCode"]}");
      print("======================================");
      state = state.copyWith(
        status: data?["status"],
        addressCode: data?["addressVerificationCode"],
        loading: false,
      );
    } catch (e) {
      state = state.copyWith(loading: false, error: e.toString());
    }
  }

  Future<bool> sendRequest() async {
    try {
      state = state.copyWith(loading: true, error: null);

      final res = await api.sendRequest();
      print("✅ VERIFY SUCCESS => ${res.data}");

      state = state.copyWith(loading: false, status: "pending");

      return true;
    } catch (e) {
      if (e is DioException) {
        print("❌ VERIFY ERROR => ${e.response?.data}");
      } else {
        print("❌ ERROR => $e");
      }

      state = state.copyWith(loading: false, error: e.toString());

      return false;
    }
  }

  Future<bool> submitAddressCode(String code) async {
    try {
      state = state.copyWith(loading: true, error: null);

      final request = SubmitAddressCodeRequest(addressVerificationCode: code);

      final response = await api.submitAddressCode(request);

      final success = response.data["success"] == true;

      await fetchVerification();

      state = state.copyWith(loading: false);

      return success;
    } catch (e) {
      String errorMessage = "Something went wrong";

      if (e is DioException) {
        errorMessage = e.response?.data["message"] ?? e.message ?? errorMessage;

        print("❌ ADDRESS CODE ERROR => ${e.response?.data}");
      }

      state = state.copyWith(loading: false, error: errorMessage);

      return false;
    }
  }
}
