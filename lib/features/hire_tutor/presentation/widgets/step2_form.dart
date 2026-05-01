import 'package:btcclient/core/widgets/input/field.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:btcclient/core/widgets/input/app_input_field.dart';
import 'package:btcclient/features/hire_tutor/presentation/provider/post_job_provider.dart';
import 'package:btcclient/features/jobs/data/constant/filter_data.dart';

class Step2Form extends ConsumerWidget {
  const Step2Form({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(postJobProvider);
    final data = state.data;
    final notifier = ref.read(postJobProvider.notifier);

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          FormHelpers.field(
            AppInputField(
              label: "Student Gender",
              required: true,
              type: AppInputType.dropdown,
              dropdownItems: List<String>.from(studentGenderOptions),
              value: data.studentGender,
              onChanged: (v) {
                notifier.update((d) => d.studentGender = v);
              },
            ),
          ),

          FormHelpers.field(
            AppInputField(
              label: "Preferred Tutor",
              required: true,
              type: AppInputType.dropdown,
              dropdownItems: List<String>.from(tutorGenderOptions),
              value: data.preferredTutorGender,
              onChanged: (v) {
                notifier.update((d) => d.preferredTutorGender = v);
              },
            ),
          ),

          FormHelpers.field(
            AppInputField(
              label: "Number of Students",
              hint: "e.g. 1, 2, 3",
              type: AppInputType.text,
              keyboardType: TextInputType.number,
              value: data.numberOfStudents.toString(),
              onChanged: (v) {
                notifier.update((d) => d.numberOfStudents = v);
              },
            ),
          ),

          FormHelpers.field(
            AppInputField(
              label: "Institute Name",
              hint: "e.g. ABC School, XYZ Coaching",
              type: AppInputType.text,
              value: data.instituteName.toString(),
              onChanged: (v) {
                notifier.update((d) => d.instituteName = v);
              },
            ),
          ),

          FormHelpers.field(
            AppInputField(
              label: "Other Requirements",
              hint: "Please specify any additional requirements",
              type: AppInputType.text,
              maxLines: 4,
              value: data.otherRequirements.toString(),
              onChanged: (v) {
                notifier.update((d) => d.otherRequirements = v);
              },
            ),
          ),
        ],
      ),
    );
  }
}
