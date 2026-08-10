import 'package:btcclient/core/widgets/button/app_button.dart';
import 'package:btcclient/core/widgets/input/app_input_field.dart';
import 'package:btcclient/core/widgets/navbar/common_appbar.dart';
import 'package:btcclient/core/widgets/snackbar/app_snackbar.dart';
import 'package:btcclient/features/auth/data/models/tutor_model.dart';
import 'package:btcclient/features/auth/data/requests/education_request.dart';
import 'package:btcclient/features/auth/presentation/provider/profile_notifier.dart';
import 'package:btcclient/features/jobs/data/constant/filter_data.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EditEducationScreen extends ConsumerStatefulWidget {
  final Education? education;

  const EditEducationScreen({super.key, this.education});

  bool get isEdit => education != null;

  @override
  ConsumerState<EditEducationScreen> createState() =>
      _EditEducationScreenState();
}

class _EditEducationScreenState extends ConsumerState<EditEducationScreen> {
  final _formKey = GlobalKey<FormState>();

  bool _saving = false;

  bool _currentInstitute = false;

  late final TextEditingController _levelController;
  late final TextEditingController _degreeController;
  late final TextEditingController _instituteController;
  late final TextEditingController _curriculumController;

  late final TextEditingController _groupController;
  late final TextEditingController _boardController;

  late final TextEditingController _departmentController;
  late final TextEditingController _semesterController;

  late final TextEditingController _resultController;
  late final TextEditingController _passingYearController;

  @override
  void initState() {
    super.initState();

    final e = widget.education;

    _currentInstitute = e?.isCurrentInstitute ?? false;

    _levelController = TextEditingController(text: e?.level ?? "");

    _degreeController = TextEditingController(text: e?.degree ?? "");

    _instituteController = TextEditingController(text: e?.institute ?? "");

    _curriculumController = TextEditingController(text: e?.curriculum ?? "");

    _groupController = TextEditingController(text: e?.group ?? "");

    _boardController = TextEditingController(text: e?.board ?? "");

    _departmentController = TextEditingController(text: e?.department ?? "");

    _semesterController = TextEditingController(text: e?.semester ?? "");

    _resultController = TextEditingController(text: e?.result ?? "");

    _passingYearController = TextEditingController(text: e?.passingYear ?? "");
  }

  @override
  void dispose() {
    _levelController.dispose();
    _degreeController.dispose();
    _instituteController.dispose();
    _curriculumController.dispose();

    _groupController.dispose();
    _boardController.dispose();

    _departmentController.dispose();
    _semesterController.dispose();

    _resultController.dispose();
    _passingYearController.dispose();

    super.dispose();
  }

  bool get shouldShowSchoolLevelFields {
    return _levelController.text == "Secondary" ||
        _levelController.text == "Higher Secondary" ||
        _levelController.text == "O Level" ||
        _levelController.text == "A Level";
  }
  bool get shouldShowHigherEducationFields { 
    return _levelController.text == "Secondary" &&
        _levelController.text == "Higher Secondary" &&
        _levelController.text == "O Level" &&
        _levelController.text == "A Level";
  } 
 
  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _saving = true;
    });

    try {
      final request = EducationRequest(
        levelOfEducation: _levelController.text.trim(),
        instituteName: _instituteController.text.trim(),
        curriculum: _curriculumController.text.trim(), 
        degree: _degreeController.text.trim(),
        group: shouldShowSchoolLevelFields ? _groupController.text.trim() : null,
        board: shouldShowSchoolLevelFields ? _boardController.text.trim() : null,
        department: !shouldShowSchoolLevelFields ? _departmentController.text.trim() : null,
        semester: !shouldShowSchoolLevelFields ? _semesterController.text.trim() : null,
        result: _resultController.text.trim(),
        passingYear: _currentInstitute
            ? null
            : _passingYearController.text.trim(),
        isCurrentInstitute: _currentInstitute,
      );

      bool success;

      if (widget.isEdit) {
        success = await ref
            .read(profileProvider.notifier)
            .updateEducation(id: widget.education!.id, request: request);
      } else {
        success = await ref
            .read(profileProvider.notifier)
            .addEducation(request);
      }

      if (!mounted) return;

      if (success) {
        Navigator.pop(context, true);
      } else {
         AppSnackbar.show(context, "Failed to send OTP", SnackType.error);
      }
    } catch (e) {
      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text(e.toString())));
    } finally {
      if (mounted) {
        setState(() {
          _saving = false;
        });
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppBar( 
        title: "Edit Education",
      ),

      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const Text(
                  "Educational Information",
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 16),
                AppInputField(
                  label: "Level of Education",
                  type: AppInputType.dropdown,
                  value: _levelController.text.isEmpty
                      ? null
                      : _levelController.text,
                  dropdownItems: levelOfEducationOptions,
                  onChanged: (value) {
                    setState(() {
                      _levelController.text = value ?? "";
                    });
                  },
                ),

                const SizedBox(height: 2),
                AppInputField(
                  controller: _instituteController,
                  label: "Institute Name",
                  hint: "Enter institute name",
                ),

                AppInputField(
                  label: "Curriculum",
                  type: AppInputType.dropdown,
                  value: _curriculumController.text.isEmpty
                      ? null
                      : _curriculumController.text,
                  dropdownItems: curriculumTypes,
                  onChanged: (value) {
                    setState(() {
                      _curriculumController.text = value ?? "";
                    });
                  },
                ),

                const SizedBox(height: 2),
                AppInputField(
                  label: "Exam / Degree Title",
                  type: AppInputType.dropdown,
                  value: _degreeController.text.isEmpty
                      ? null
                      : _degreeController.text,
                  dropdownItems: degreeOptions,
                  onChanged: (value) {
                    setState(() {
                      _degreeController.text = value ?? "";
                    });
                  },
                ),
                const SizedBox(height: 16),
                Text(
                  shouldShowSchoolLevelFields ? "School Information" : "Higher Education",
                  style: const TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 16),
                if (shouldShowSchoolLevelFields) ...[
                  AppInputField(
                    label: "Group",
                    type: AppInputType.dropdown,
                    value: _groupController.text.isEmpty
                        ? null
                        : _groupController.text,
                    dropdownItems: academicGroups,
                    onChanged: (value) {
                      setState(() {
                        _groupController.text = value ?? "";
                      });
                    },
                  ),

                  const SizedBox(height: 2),

                  AppInputField(
                    label: "Board",
                    type: AppInputType.dropdown,
                    value: _boardController.text.isEmpty
                        ? null
                        : _boardController.text,
                    dropdownItems: educationBoards,
                    onChanged: (value) {
                      setState(() {
                        _boardController.text = value ?? "";
                      });
                    },
                  ),

                  const SizedBox(height: 2),
                ],
                if (shouldShowHigherEducationFields) ...[
                  AppInputField(
                    label: "Department / Subject",
                    type: AppInputType.dropdown,
                    value: _departmentController.text.isEmpty
                        ? null
                        : _departmentController.text,
                    dropdownItems: departmentsOrSubjects,
                    onChanged: (value) {
                      setState(() {
                        _departmentController.text = value ?? "";
                      });
                    },
                  ),

                  const SizedBox(height: 2),

                  AppInputField(
                    controller: _semesterController,
                    label: "Year / Semester",
                    hint: "e.g., 5th semester, 3rd year",
                  ),

                  const SizedBox(height: 2),
                ],
                AppInputField(
                  controller: _resultController,
                  label: "Result",
                  hint: "e.g., 3.75 GPA/CGPA",
                ),

                const SizedBox(height: 2),
                if (!_currentInstitute) ...[
                  AppInputField(
                    controller: _passingYearController,
                    label: "Passing Year",
                    hint: "e.g., 2023",
                    keyboardType: TextInputType.number,
                  ),

                  const SizedBox(height: 2),
                ],
                CheckboxListTile(
                  value: _currentInstitute,
                  contentPadding: EdgeInsets.zero,
                  controlAffinity: ListTileControlAffinity.leading,
                  title: const Text("Currently studying here"),
                  onChanged: (value) {
                    setState(() {
                      _currentInstitute = value ?? false;

                      if (_currentInstitute) {
                        _passingYearController.clear();
                      }
                    });
                  },
                ),
                AppButton(
                  label: widget.isEdit ? "Update Education" : "Add Education",
                  loading: _saving,
                   onPressed: _save,
                ),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
