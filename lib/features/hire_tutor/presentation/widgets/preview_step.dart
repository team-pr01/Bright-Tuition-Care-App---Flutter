import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:btcclient/core/config/theme.dart';
import 'package:btcclient/features/hire_tutor/presentation/provider/post_job_provider.dart';

class PreviewStep extends ConsumerWidget {
  const PreviewStep({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(postJobProvider);
    final data = state.data;
    final notifier = ref.read(postJobProvider.notifier);
    print(" final print ${data.address}");

    /// 🔥 SECTION WIDGET
    Widget section(String title, List<Widget> children, int stepIndex) {
      return Container(
        margin: const EdgeInsets.only(bottom: 16),
        padding: const EdgeInsets.all(14),
        decoration: BoxDecoration(
          color: Colors.white,
          borderRadius: BorderRadius.circular(10),
          boxShadow: [
            BoxShadow(blurRadius: 6, color: Colors.black.withOpacity(0.05)),
          ],
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// 🔥 HEADER
            Row(
  children: [
    Expanded(
      child: Row(
        children: [
          Container(
            width: 4,
            height: 18,
            decoration: BoxDecoration(
              color: AppColors.primary01,
              borderRadius: BorderRadius.circular(2),
            ),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Text(
              title,
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    fontWeight: FontWeight.w600,
                    color: AppColors.neutrals02,
                  ),
            ),
          ),
        ],
      ),
    ),
    TextButton(
      onPressed: () {
        notifier.goToStep(stepIndex);
      },
      child: Text(
        "Edit",
        style: TextStyle(color: AppColors.primary01),
      ),
    ),
  ],
),

const SizedBox(height: 12),

            ...children,
          ],
        ),
      );
    }

    Widget row(String label, dynamic value) {
      final displayValue = (value == null || value.toString().isEmpty)
          ? "-"
          : value.toString();

      return Padding(
        padding: const EdgeInsets.only(bottom: 10),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// LABEL
            Expanded(
              flex: 3,
              child: Text(label, style: Theme.of(context).textTheme.bodySmall),
            ),

            /// VALUE
            Expanded(
              flex: 5,
              child: Text(
                displayValue,
                softWrap: true, // 🔥 IMPORTANT
                overflow: TextOverflow.visible, // 🔥 IMPORTANT
                style: Theme.of(context).textTheme.bodyMedium,
              ),
            ),
          ],
        ),
      );
    }

    /// 🔥 ROW WIDGET
    /// 🔥 LIST FORMATTER
    String listToString(List<String>? list) {
      if (list == null || list.isEmpty) return "-";
      return list.join(", ");
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          /// 🔥 JOB DETAILS (STEP 1)
          section("Job Details", [
            row("Tuition Type", data.tuitionType),
            row("Category", data.category),
            row("Curriculum", data.curriculum),
            row("Classes", listToString(data.classes)),
            row("Subjects", listToString(data.subjects)),
            row("Tutoring Days", data.tutoringDays),
            row("Tutoring Time", data.tutoringTime),
            row("Salary", data.salary),
          ], 0),

          /// 🔥 STUDENT INFO (STEP 2)
          section("Student Preferences", [
            row("Student Gender", data.studentGender),
            row("Preferred Tutor", data.preferredTutorGender),
            row("Number of Students", data.numberOfStudents),
            row("Institute Name", data.instituteName),
            row("Other Requirements", data.otherRequirements),
          ], 1),

          /// 🔥 LOCATION (STEP 3)
          section("Location Details", [
            row("City", data.city),
            row("Area", data.area),
            row("Address", data.address),
          ], 2),
        ],
      ),
    );
  }
}
