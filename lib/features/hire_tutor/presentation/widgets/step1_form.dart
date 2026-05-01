import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:btcclient/core/widgets/input/app_input_field.dart';
import 'package:btcclient/features/hire_tutor/presentation/provider/post_job_provider.dart';
import 'package:btcclient/features/jobs/data/constant/filter_data.dart';

class Step1Form extends ConsumerStatefulWidget {
  const Step1Form({super.key});

  @override
  ConsumerState<Step1Form> createState() => _Step1FormState();
}

class _Step1FormState extends ConsumerState<Step1Form> {
  late TextEditingController timeController;
  late TextEditingController salaryController;

  @override
void initState() {
  super.initState();

  final data = ref.read(postJobProvider).data;
  final notifier = ref.read(postJobProvider.notifier);

  timeController = TextEditingController(
    text: data.tutoringTime ?? "",
  );

  salaryController = TextEditingController(
    text: data.salary ?? "",
  );

  /// 🔥 FORCE UPDATE FROM CONTROLLER
  timeController.addListener(() {
    notifier.update((d) => d.tutoringTime = timeController.text);
  });

  salaryController.addListener(() {
    notifier.update((d) => d.salary = salaryController.text);
  });
}

  @override
  void dispose() {
    timeController.dispose();
    salaryController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(postJobProvider);
    final data = state.data;
    final notifier = ref.read(postJobProvider.notifier);

    /// 🔥 CATEGORY → CLASSES
    List<Map<String, dynamic>> getClasses() {
      final catalog = List<Map<String, dynamic>>.from(
        filterData["tutoringCatalog"] ?? [],
      );

      final filtered = catalog.where((e) => e["category"] == data.category);

      if (filtered.isEmpty) return [];

      return List<Map<String, dynamic>>.from(filtered.first["classes"] ?? []);
    }

    /// 🔥 CLASSES → SUBJECTS
    List<String> getSubjects() {
      final classes = getClasses();

      final selectedClasses = classes.where(
        (c) => data.classes.contains(c["name"]),
      );

      return selectedClasses
          .expand((c) => List<String>.from(c["subjects"] ?? []))
          .toSet()
          .toList();
    }

    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          /// 🔥 TUITION TYPE
          AppInputField(
            label: "Tuition Type",
            type: AppInputType.dropdown,
            dropdownItems: List<String>.from(filterData["tuitionType"] ?? []),
            value: data.tuitionType,
            onChanged: (v) {
              notifier.update((d) => d.tuitionType = v);
            },
          ),

          

          /// 🔥 CATEGORY
          AppInputField(
            label: "Category",
            type: AppInputType.dropdown,
            dropdownItems: List<String>.from(filterData["category"] ?? []),
            value: data.category,
            onChanged: (v) {
              notifier.update((d) {
                d.category = v;
                d.classes = [];
                d.subjects = [];
                d.curriculum = null;
              });
            },
          ),

          

          /// 🔥 CURRICULUM (ONLY FOR ENGLISH MEDIUM)
          if ((data.category ?? "").toLowerCase() == "english medium")
            AppInputField(
              label: "Curriculum",
              type: AppInputType.dropdown,
              dropdownItems: curriculumTypes,
              value: data.curriculum,
              onChanged: (v) {
                notifier.update((d) => d.curriculum = v);
              },
            ),

          

          /// 🔥 CLASS
          AppInputField(
            label: "Class",
            type: AppInputType.dropdown,
            multiSelect: true,
            dropdownItems:
                getClasses().map((e) => e["name"] as String).toList(),
            selectedValues: data.classes,
            onMultiChanged: (v) {
              notifier.update((d) {
                d.classes = v;
                d.subjects = [];
              });
            },
          ),

          

          /// 🔥 SUBJECTS
          AppInputField(
            label: "Subjects",
            type: AppInputType.dropdown,
            multiSelect: true,
            dropdownItems: getSubjects(),
            selectedValues: data.subjects,
            onMultiChanged: (v) {
              notifier.update((d) => d.subjects = v);
            },
          ),

          

          /// 🔥 TUTORING DAYS
          AppInputField(
            label: "Tutoring Days",
            type: AppInputType.dropdown,
            dropdownItems:
                List<String>.from(filterData["daysPerWeek"] ?? []),
            value: data.tutoringDays,
            onChanged: (v) {
              notifier.update((d) => d.tutoringDays = v);
            },
          ),

          

          /// 🔥 TUTORING TIME (FIXED)
          AppInputField(
            label: "Tutoring Time",
            type: AppInputType.text,
            hint: "5:00 - 6:00",
            controller: timeController,
            onChanged: (v) {
    ref.read(postJobProvider.notifier)
        .update((d) => d.tutoringTime = v);
  },
          ),
          

          

          /// 🔥 SALARY (FIXED)
          AppInputField(
            label: "Salary",
            type: AppInputType.text,
            keyboardType: TextInputType.number,
              hint: "eg:5000",
            controller: salaryController,
            // onChanged: (v) {
            //   notifier.update((d) => d.salary = v);
            // },
          ),
        ],
      ),
    );
  }
}