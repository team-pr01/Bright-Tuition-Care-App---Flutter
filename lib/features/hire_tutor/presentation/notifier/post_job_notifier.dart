import 'package:btcclient/core/widgets/reusable_bottom_sheet/reusable_bottom_sheet.dart';
import 'package:btcclient/features/auth/presentation/provider/auth_notifier.dart';
import 'package:btcclient/features/hire_tutor/presentation/widgets/success_modal.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:btcclient/features/hire_tutor/data/models/job_form_model.dart';
import 'package:btcclient/features/hire_tutor/data/post_job_repository.dart';

class PostJobState {
  final int step;
  final JobFormModel data;
  final bool isLoading; // 🔥 ADD
  final bool isEdit; // 🔥
  final String? jobId;

  PostJobState({
    required this.step,
    required this.data,
    this.isLoading = false,
    this.isEdit = false,
    this.jobId,
  });

  factory PostJobState.initial() {
    return PostJobState(
      step: 0,
      data: JobFormModel(),
      isLoading: false,
      isEdit: false,
      jobId: null,
    );
  }

  PostJobState copyWith({
    int? step,
    JobFormModel? data,
    bool? isLoading,
    bool? isEdit,
    String? jobId,
  }) {
    return PostJobState(
      step: step ?? this.step,
      data: data ?? this.data,
      isLoading: isLoading ?? this.isLoading,
      isEdit: isEdit ?? this.isEdit,
      jobId: jobId ?? this.jobId,
    );
  }
}

class PostJobNotifier extends StateNotifier<PostJobState> {
  final Ref ref;

  PostJobNotifier(this.ref) : super(PostJobState.initial());

  final _repo = PostJobRepository();

  /// 🔥 SUBMIT API
  Future<void> submit(
    BuildContext context,
    Function(int, {String? status}) changeTab,
  ) async {
    if (state.isLoading) return;

    final user = ref.read(authProvider).user;
    final data = state.data;

    final payload = {
      "tuitionType": data.tuitionType,
      "category": data.category,
      "class": data.classes,
      "subjects": data.subjects,
      "tutoringDays": data.tutoringDays,
      "tutoringTime": data.tutoringTime,

      "salary": data.salary.toString(),
      "numberOfStudents": data.numberOfStudents,

      "studentGender": data.studentGender?.toLowerCase(),
      "preferredTutorGender": data.preferredTutorGender?.toLowerCase(),
      "studentsInstituteName": data.instituteName,
      "otherRequirements": data.otherRequirements,

      "city": data.city,
      "area": data.area,
      "address": data.address,

      "guardianName": user?.name,
      "guardianPhoneNumber": user?.phoneNumber,

      "postedBy": user?.id,
      "postedByModel": user?.role == "guardian" ? "Guardian" : "User",
    };

    payload.removeWhere((key, value) => value == null);

    print("🚀 FINAL PAYLOAD => $payload");

    state = state.copyWith(isLoading: true);

    try {
      bool success;

      /// 🔥 THIS IS THE FIX
      if (state.isEdit) {
        print("✏️ CALLING UPDATE API: ${state.jobId}");
        success = await _repo.updateJob(state.jobId!, payload);
      } else {
        print("➕ CALLING CREATE API");
        success = await _repo.postJob(payload);
      }

      if (success) {
        state = PostJobState.initial();

        showModalBottomSheet(
          context: context,
          isScrollControlled: true,
          backgroundColor: Colors.transparent,
          builder: (_) {
            return ReusableBottomSheet(
              child: SuccessBottomSheet(
                role: user?.role ?? "",
                changeTab: changeTab,
              ),
            );
          },
        );
      } else {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              state.isEdit ? "Failed to update job" : "Failed to post job",
            ),
          ),
        );
      }
    } catch (e) {
      print("❌ SUBMIT ERROR => $e");

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Error: $e")));
    }

    state = state.copyWith(isLoading: false);
  }

  void next() {
    final d = state.data;

    if (state.step == 0) {
      if (d.tuitionType == null ||
          d.category == null ||
          d.classes.isEmpty ||
          d.subjects.isEmpty ||
          d.tutoringDays == null ||
          (d.tutoringTime == null || d.tutoringTime!.isEmpty) ||
          (d.salary == null || d.salary!.isEmpty)) {
        print("❌ STEP 1 INVALID");
        return;
      }
    }

    if (state.step == 1) {
      if (d.studentGender == null || d.preferredTutorGender == null) {
        print("❌ STEP 2 INVALID");
        return;
      }
    }

    if (state.step == 2) {
      if (d.city == null ||
          d.area == null ||
          (d.address == null || d.address!.isEmpty)) {
        print("❌ STEP 3 INVALID");
        return;
      }
    }

    if (state.step < 3) {
      state = state.copyWith(step: state.step + 1);
    }
  }

  void back() {
    if (state.step > 0) {
      state = state.copyWith(step: state.step - 1);
    }
  }

  void goToStep(int step) {
    state = state.copyWith(step: step);
  }

  /// 🔥 UPDATE FORM DATA (SAFE COPY)
  void update(Function(JobFormModel) cb) {
    final newData = JobFormModel()
      ..tuitionType = state.data.tuitionType
      ..category = state.data.category
      ..curriculum = state.data.curriculum
      ..classes = List.from(state.data.classes)
      ..subjects = List.from(state.data.subjects)
      ..tutoringDays = state.data.tutoringDays
      ..tutoringTime = state.data.tutoringTime
      ..salary = state.data.salary
      ..studentGender = state.data.studentGender
      ..preferredTutorGender = state.data.preferredTutorGender
      ..numberOfStudents = state.data.numberOfStudents
      ..instituteName = state.data.instituteName
      ..otherRequirements = state.data.otherRequirements
      ..city = state.data.city
      ..area = state.data.area
      ..address = state.data.address
      ..locationDirection = state.data.locationDirection
      ..guardianName = state.data.guardianName
      ..guardianPhone = state.data.guardianPhone;

    cb(newData);

    state = state.copyWith(data: newData);

    print("UPDATED DATA => ${newData.toApi()}");
  }

  void setEditData(Map<String, dynamic> job) {
    state = state.copyWith(
      isEdit: true,
      jobId: job["_id"],

      data: JobFormModel()
        ..tuitionType = job["tuitionType"]
        ..category = job["category"]
        ..curriculum = job["curriculum"]
        ..classes = List<String>.from(job["class"] ?? [])
        ..subjects = List<String>.from(job["subjects"] ?? [])
        ..tutoringDays = job["tutoringDays"]
        ..tutoringTime = job["tutoringTime"]
        ..salary = job["salary"]
        ..studentGender = job["studentGender"]
        ..preferredTutorGender = job["preferredTutorGender"]
        ..numberOfStudents = job["numberOfStudents"]
        ..instituteName = job["studentsInstituteName"]
        ..otherRequirements = job["otherRequirements"]
        ..city = (job["city"] != null && job["city"].isNotEmpty)
            ? job["city"][0]
            : null
        ..area = (job["area"] != null && job["area"].isNotEmpty)
            ? job["area"][0]
            : null
        ..address = job["address"],
    );

    print("✏️ EDIT MODE LOADED");
  }
}
