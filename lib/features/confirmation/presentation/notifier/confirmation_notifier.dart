import 'package:btcclient/core/network/api_error_handler.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../data/confirmation_repository.dart';
import '../../data/models/confirmation_letter_model.dart';

class ConfirmationState {
  final bool isLoading;
  final List<ConfirmationLetterModel> letters;
  final ConfirmationLetterModel? selectedLetter;
  final String? error;

  const ConfirmationState({
    this.isLoading = false,
    this.letters = const [],
    this.selectedLetter,
    this.error,
  });

  ConfirmationState copyWith({
    bool? isLoading,
    List<ConfirmationLetterModel>? letters,
    ConfirmationLetterModel? selectedLetter,
    String? error,
    bool clearSelectedLetter = false,
  }) {
    return ConfirmationState(
      isLoading: isLoading ?? this.isLoading,
      letters: letters ?? this.letters,
      selectedLetter: clearSelectedLetter
          ? null
          : (selectedLetter ?? this.selectedLetter),
      error: error,
    );
  }
}

class ConfirmationNotifier extends StateNotifier<ConfirmationState> {
  final ConfirmationRepository repository;

  ConfirmationNotifier(this.repository)
      : super(const ConfirmationState());

  /// ================= GET MY LETTERS =================

  Future<void> fetchLetters({
    required String role,
  }) async {
    try {
      state = state.copyWith(
        isLoading: true,
        error: null,
      );

      final letters = role == "tutor"
          ? await repository.getTutorConfirmationLetters()
          : await repository.getGuardianConfirmationLetters();

      state = state.copyWith(
        isLoading: false,
        letters: letters,
        error: null,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: ApiErrorHandler.getMessage(e),
      );
    }
  }

  /// ================= REFRESH =================

  Future<void> refresh(String role) async {
    await fetchLetters(role: role);
  }

  /// ================= GET SINGLE LETTER =================

  Future<void> fetchSingleLetter(String id) async {
    try {
      state = state.copyWith(
        isLoading: true,
        error: null,
      );

      final letter = await repository.getConfirmationLetterById(id);

      state = state.copyWith(
        isLoading: false,
        selectedLetter: letter,
      );
    } catch (e) {
      state = state.copyWith(
        isLoading: false,
        error: ApiErrorHandler.getMessage(e),
      );
    }
  }

  /// ================= SIGN AS TUTOR =================

  Future<bool> signTutor({
    required String id,
    required String signature,
  }) async {
    try {
      await repository.signTutorLetter(
        id: id,
        signature: signature,
      );

      await fetchSingleLetter(id);

      return true;
    } catch (e) {
      state = state.copyWith(
        error: ApiErrorHandler.getMessage(e),
      );

      return false;
    }
  }

  /// ================= SIGN AS GUARDIAN =================

  Future<bool> signGuardian({
    required String id,
    required String signature,
  }) async {
    try {
      await repository.signGuardianLetter(
        id: id,
        signature: signature,
      );

      await fetchSingleLetter(id);

      return true;
    } catch (e) {
      state = state.copyWith(
        error: ApiErrorHandler.getMessage(e),
      );

      return false;
    }
  }

  /// ================= CLEAR SELECTED LETTER =================

  void clearSelectedLetter() {
    state = state.copyWith(
      clearSelectedLetter: true,
    );
  }

  /// ================= CLEAR EVERYTHING =================

  void clear() {
    state = const ConfirmationState();
  }
}