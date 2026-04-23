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

  PostJobState({
    required this.step,
    required this.data,
    this.isLoading = false,
  });

  factory PostJobState.initial() {
    return PostJobState(step: 0, data: JobFormModel(), isLoading: false);
  }

  PostJobState copyWith({int? step, JobFormModel? data, bool? isLoading}) {
    return PostJobState(
      step: step ?? this.step,
      data: data ?? this.data,
      isLoading: isLoading ?? this.isLoading,
    );
  }
}

class PostJobNotifier extends StateNotifier<PostJobState> {
  final Ref ref;

  PostJobNotifier(this.ref) : super(PostJobState.initial());

  final _repo = PostJobRepository();

  /// 🔥 SUBMIT API
  Future<void> submit(BuildContext context , Function(int, {String? status}) changeTab) async {
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

      /// 🔥 FORCE STRING (HARDCODE SAFE)
      "salary": data.salary.toString(),
      "numberOfStudents": data.numberOfStudents.toString(),

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

    /// 🔥 REMOVE NULLS
    payload.removeWhere((key, value) => value == null);

    print("🚀 FINAL PAYLOAD => $payload");

    state = state.copyWith(isLoading: true);

    try {
      final success = await _repo.postJob(payload);
      print("success $success");
      if (success) {
        /// 🔥 RESET FORM FIRST
        state = PostJobState.initial();

        /// 🔥 OPEN SUCCESS BOTTOM SHEET
       showModalBottomSheet(
  context: context,
  isScrollControlled: true,
  backgroundColor: Colors.transparent,
  builder: (_) {
    return ReusableBottomSheet(
      child: SuccessBottomSheet(
        role: ref.read(authProvider).user?.role ?? "",
        changeTab: changeTab, // 🔥 PASS IT
      ),
    );
  },
);
      } else {
        ScaffoldMessenger.of(
          context,
        ).showSnackBar(const SnackBar(content: Text("Failed to post job")));
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
}
