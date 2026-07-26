import 'package:btcclient/core/network/api_exception.dart';
import 'package:btcclient/features/confirmation/data/confirmation_api.dart';
import 'package:btcclient/features/confirmation/data/models/confirmation_letter_model.dart';

class ConfirmationRepository {
  final ConfirmationApi api;

  ConfirmationRepository(this.api);

  /// ================= TUTOR LETTERS =================
  Future<List<ConfirmationLetterModel>> getTutorConfirmationLetters() async {
    final response = await api.getTutorConfirmationLetter();

    final responseData = response.data;

    if (responseData["success"] != true) {
      throw ApiException(
        responseData["message"] ?? "Failed to load confirmation letters",
      );
    }

    return (responseData["data"] as List)
        .map((e) => ConfirmationLetterModel.fromJson(e))
        .toList();
  }

  /// ================= GUARDIAN LETTERS =================
  Future<List<ConfirmationLetterModel>> getGuardianConfirmationLetters() async {
    final response = await api.getGuardianConfirmationLetter();

    final responseData = response.data;

    if (responseData["success"] != true) {
      throw ApiException(
        responseData["message"] ?? "Failed to load confirmation letters",
      );
    }

    return (responseData["data"] as List)
        .map((e) => ConfirmationLetterModel.fromJson(e))
        .toList();
  }

  /// ================= SINGLE LETTER =================
  Future<ConfirmationLetterModel> getConfirmationLetterById(
    String id,
  ) async {
    final response = await api.getConfirmationLetterById(id);

    final responseData = response.data;

    if (responseData["success"] != true) {
      throw ApiException(
        responseData["message"] ?? "Failed to load confirmation letter",
      );
    }

    return ConfirmationLetterModel.fromJson(responseData["data"]);
  }

  /// ================= SIGN TUTOR LETTER =================
  Future<void> signTutorLetter({
    required String id,
    required String signature,
  }) async {
    final response = await api.signTutorConfirmationLetter(
      id: id,
      signature: signature,
    );

    final responseData = response.data;

    if (responseData["success"] != true) {
      throw ApiException(
        responseData["message"] ?? "Failed to sign confirmation letter",
      );
    }
  }

  /// ================= SIGN GUARDIAN LETTER =================
  Future<void> signGuardianLetter({
    required String id,
    required String signature,
  }) async {
    final response = await api.signGuardianConfirmationLetter(
      id: id,
      signature: signature,
    );

    final responseData = response.data;

    if (responseData["success"] != true) {
      throw ApiException(
        responseData["message"] ?? "Failed to sign confirmation letter",
      );
    }
  }

  /// ================= REFRESH SINGLE LETTER =================
  Future<ConfirmationLetterModel> refreshLetter(String id) async {
    return await getConfirmationLetterById(id);
  }
}