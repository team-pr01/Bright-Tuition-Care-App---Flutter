import 'dart:io';

import 'package:btcclient/core/network/api_error_handler.dart';
import 'package:btcclient/features/auth/data/auth_repository.dart';
import 'package:btcclient/features/auth/data/requests/education_request.dart';
import 'package:btcclient/features/auth/presentation/provider/auth_notifier.dart';
import 'package:btcclient/features/profile/data/requests/update_personal_info_request.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

final profileProvider = StateNotifierProvider<ProfileNotifier, dynamic>((ref) {
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

      final profile = await repo.getProfile();

      state = profile;
    } catch (e) {
      error = ApiErrorHandler.getMessage(e);
    } finally {
      isLoading = false;
    }
  }

  Future<void> refreshProfile() async {
    await fetchProfile();
  }

  Future<bool> updatePersonalInfo(UpdatePersonalInfoRequest request) async {
    try {
      isLoading = true;
      error = null;

      await repo.updatePersonalInfo(request);

      await fetchProfile();

      return true;
    } catch (e) {
      error = ApiErrorHandler.getMessage(e);
      return false;
    } finally {
      isLoading = false;
    }
  }

  Future<bool> addEducation(EducationRequest request) async {
    try {
      isLoading = true;
      error = null;
      print("===== EDUCATION PAYLOAD =====");
      print("Adding education3: ${request.toJson()}");
      print("=============================");
      await repo.addEducation(request);

      await fetchProfile();

      return true;
    } catch (e) {
      error = ApiErrorHandler.getMessage(e);
      return false;
    } finally {
      isLoading = false;
    }
  }

  Future<bool> updateEducation({
    required String id,
    required EducationRequest request,
  }) async {
    try {
      isLoading = true;
      error = null;

      await repo.updateEducation(id: id, request: request);

      await fetchProfile();

      return true;
    } catch (e) {
      error = ApiErrorHandler.getMessage(e);
      return false;
    } finally {
      isLoading = false;
    }
  }

  Future<bool> deleteEducation(String id) async {
    try {
      isLoading = true;
      error = null;

      await repo.deleteEducation(id);

      await fetchProfile();

      return true;
    } catch (e) {
      error = ApiErrorHandler.getMessage(e);
      return false;
    } finally {
      isLoading = false;
    }
  }

  Future<bool> updateProfileImage(File image) async {
    try {
      isLoading = true;
      error = null;

      await repo.updateProfileImage(image);

      await fetchProfile();

      return true;
    } catch (e) {
      error = ApiErrorHandler.getMessage(e);
      return false;
    } finally {
      isLoading = false;
    }
  }

  Future<bool> updateTuitionRelatedInfo({
    required Map<String, dynamic> tuitionPreference,
    required String totalExperience,
  }) async {
    try {
      isLoading = true;
      error = null;

      final payload = {
        "tuitionPreference": tuitionPreference,
        "experience": {"totalExperience": totalExperience},
      };

      await repo.updateProfile(payload);

      await fetchProfile();

      return true;
    } catch (e) {
      error = ApiErrorHandler.getMessage(e);
      return false;
    } finally {
      isLoading = false;
    }
  }

  void clearProfile() {
    state = null;
    error = null;
    isLoading = false;
  }
}
