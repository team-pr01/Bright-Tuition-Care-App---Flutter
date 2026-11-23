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

  late final bool _isEdit = widget.education != null;

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

  // 👈 Helper to check strictly for School Levels (Secondary & Higher Secondary)
  bool get _isSchoolLevel {
    return _levelController.text == "Secondary" ||
        _levelController.text == "Higher Secondary";
  }

  // 👈 Helper to check strictly for Higher Ed Levels (Diploma, Bachelor, Master, Doctoral)
  bool get _isHigherEdLevel {
    return _levelController.text == "Diploma" ||
        _levelController.text == "Bachelor" ||
        _levelController.text == "Masters" ||
        _levelController.text == "Honors" ||
        _levelController.text == "Doctoral";
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
        // 👈 Only send group/board if it's School Level
        group: _isSchoolLevel ? _groupController.text.trim() : null,
        board: _isSchoolLevel ? _boardController.text.trim() : null,
        // 👈 Only send department/semester if it's Higher Ed Level
        department: _isHigherEdLevel ? _departmentController.text.trim() : null,
        semester: _isHigherEdLevel ? _semesterController.text.trim() : null,
        result: _resultController.text.trim(),
        passingYear: _currentInstitute
            ? null
            : _passingYearController.text.trim(),
        isCurrentInstitute: _currentInstitute,
      );

      bool success;

      if (_isEdit) {
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
        AppSnackbar.show(
          context,
          _isEdit ? "Failed to update education" : "Failed to add education",
          SnackType.error,
        );
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
      appBar: const CommonAppBar(title: "Edit Education"),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              /// SCROLLABLE FIELDS
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Educational Information",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 16),

                      AppInputField(
                        label: "Level of Education",
                        type: AppInputType.dropdown2,
                        value: _levelController.text.isEmpty
                            ? null
                            : _levelController.text,
                        dropdownItems: levelOfEducationOptions,
                        onChanged: (value) {
                          final v = value ?? "";

                          setState(() {
                            _levelController.text = v;
                            
                            // 👈 Clear out fields when switching to avoid ghost data
                            if (v == "O Level" || v == "A Level") {
                              _groupController.clear();
                              _boardController.clear();
                              _departmentController.clear();
                              _semesterController.clear();
                            } else if (v == "Secondary" || v == "Higher Secondary") {
                              _departmentController.clear();
                              _semesterController.clear();
                            } else if (v == "Diploma" || v == "Bachelor" || v == "Masters" || v == "Honors" || v == "Doctoral") {
                              _groupController.clear();
                              _boardController.clear();
                            }
                          });
                        },
                      ),

                      AppInputField(
                        controller: _instituteController,
                        label: "Institute Name",
                        hint: "Enter institute name",
                      ),

                      AppInputField(
                        label: "Curriculum",
                        type: AppInputType.dropdown2,
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

                      AppInputField(
                        label: "Exam / Degree Title",
                        type: AppInputType.dropdown2,
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

                      // 👈 Show Group & Board ONLY for Secondary & Higher Secondary
                      if (_isSchoolLevel) ...[
                        AppInputField(
                          label: "Group",
                          type: AppInputType.dropdown2,
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

                        AppInputField(
                          label: "Board",
                          type: AppInputType.dropdown2,
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
                      ],

                      // 👈 Show Department & Year ONLY for Diploma, Bachelor, Master, Doctoral
                      if (_isHigherEdLevel) ...[
                        AppInputField(
                          label: "Department / Subject",
                          type: AppInputType.dropdown2,
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

                        AppInputField(
                          controller: _semesterController,
                          label: "Year / Semester",
                          hint: "e.g., 5th semester, 3rd year",
                        ),
                      ],

                      AppInputField(
                        controller: _resultController,
                        label: "Result",
                        hint: "e.g., 3.75 GPA/CGPA",
                      ),

                      if (!_currentInstitute) ...[
                        AppInputField(
                          controller: _passingYearController,
                          label: "Passing Year",
                          hint: "e.g., 2023",
                          keyboardType: TextInputType.number,
                        ),
                      ],

                      Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          SizedBox(
                            width: 24,
                            height: 24,
                            child: Checkbox(
                              value: _currentInstitute,
                              materialTapTargetSize:
                                  MaterialTapTargetSize.shrinkWrap,
                              visualDensity: const VisualDensity(
                                horizontal: -4,
                                vertical: -4,
                              ),
                              onChanged: (value) {
                                setState(() {
                                  _currentInstitute = value ?? false;
                                  if (_currentInstitute) {
                                    _passingYearController.clear();
                                  }
                                });
                                _formKey.currentState?.validate();
                              },
                            ),
                          ),
                          const SizedBox(width: 6),
                          const Text(
                            "Currently studying here",
                            style: TextStyle(fontSize: 14),
                          ),
                        ],
                      ),

                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),

              /// STICKY BUTTON
              Container(
                padding: const EdgeInsets.fromLTRB(20, 12, 20, 16),
                decoration: BoxDecoration(
                  color: Theme.of(context).scaffoldBackgroundColor,
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.06),
                      blurRadius: 12,
                      offset: const Offset(0, -4),
                    ),
                  ],
                ),
                child: SafeArea(
                  top: false,
                  child: AppButton(
                    label: _isEdit ? "Update Education" : "Add Education",
                    loading: _saving,
                    onPressed: _save,
                  ),
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}