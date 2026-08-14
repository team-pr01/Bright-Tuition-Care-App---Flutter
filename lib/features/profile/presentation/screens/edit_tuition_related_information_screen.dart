import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:btcclient/core/widgets/button/app_button.dart';
import 'package:btcclient/core/widgets/input/app_input_field.dart';
import 'package:btcclient/core/widgets/navbar/common_appbar.dart';

import 'package:btcclient/features/auth/data/models/tutor_model.dart';
import 'package:btcclient/features/auth/presentation/provider/profile_notifier.dart';
import 'package:btcclient/features/jobs/data/constant/filter_data.dart';

class EditTuitionRelatedInformationScreen extends ConsumerStatefulWidget {
  const EditTuitionRelatedInformationScreen({super.key});

  @override
  ConsumerState<EditTuitionRelatedInformationScreen> createState() =>
      _EditTuitionRelatedInformationScreenState();
}

class _EditTuitionRelatedInformationScreenState
    extends ConsumerState<EditTuitionRelatedInformationScreen> {
  final _formKey = GlobalKey<FormState>();

  bool _saving = false;

  late final TextEditingController _tutoringMethodController;
  late final TextEditingController _expectedSalaryController;
  late final TextEditingController _totalExperienceController;

  List<String> _selectedTutoringStyles = [];
  List<String> _selectedCategories = [];
  List<String> _selectedClasses = [];
  List<String> _selectedSubjects = [];
  List<String> _selectedPlacesOfTuition = [];
  List<String> _selectedCities = [];
  List<String> _selectedLocations = [];

  List<String> _classOptions = [];
  List<String> _subjectOptions = [];
  List<String> _locationOptions = [];

  TutorProfileModel get profile {
    return ref.read(profileProvider) as TutorProfileModel;
  }

  @override
  void initState() {
    super.initState();

    final tuition = profile.tuitionPreference;

    // ----------------------------------------------------------
    // TEXT VALUES
    // ----------------------------------------------------------

    _tutoringMethodController = TextEditingController(
      text: tuition.tutoringMethod ?? '',
    );

    _expectedSalaryController = TextEditingController(
      text: tuition.expectedSalary?.toString() ?? '',
    );

    _totalExperienceController = TextEditingController(
  text: profile.experience.totalExperience ?? '',
);

    // ----------------------------------------------------------
    // MULTI SELECT VALUES
    // ----------------------------------------------------------

    _selectedTutoringStyles = List<String>.from(tuition.tuitionStyle);

    _selectedCategories = List<String>.from(tuition.preferredCategories);

    _selectedClasses = List<String>.from(tuition.preferredClasses);

    _selectedSubjects = List<String>.from(tuition.preferredSubjects);

    _selectedPlacesOfTuition = List<String>.from(tuition.placeOfTuition);

    _selectedCities = List<String>.from(tuition.preferredCities);

    _selectedLocations = List<String>.from(tuition.preferredLocations);

    // Build dependent options AFTER values are loaded.
    _buildClassOptions();
    _buildSubjectOptions();
    _buildLocationOptions();
  }

  @override
  void dispose() {
    _tutoringMethodController.dispose();
    _expectedSalaryController.dispose();
    _totalExperienceController.dispose();

    super.dispose();
  }

  // ============================================================
  // CATEGORY → CLASS OPTIONS
  // ============================================================

  void _buildClassOptions() {
    final classes = <String>[];

    for (final category in filterData["tutoringCatalog"]) {
      final categoryName = category["category"]?.toString();

      if (!_selectedCategories.contains(categoryName)) {
        continue;
      }

      for (final cls in category["classes"]) {
        final className = cls["name"]?.toString();

        if (className != null && className.isNotEmpty) {
          classes.add(className);
        }
      }
    }

    final uniqueClasses = classes.toSet().toList();

    _classOptions = uniqueClasses;

    // Remove classes which don't belong to selected categories.
    _selectedClasses = _selectedClasses.where(_classOptions.contains).toList();
  }

  // ============================================================
  // CLASS → SUBJECT OPTIONS
  // ============================================================

  void _buildSubjectOptions() {
    final subjects = <String>[];

    for (final category in filterData["tutoringCatalog"]) {
      final categoryName = category["category"]?.toString();

      if (!_selectedCategories.contains(categoryName)) {
        continue;
      }

      for (final cls in category["classes"]) {
        final className = cls["name"]?.toString();

        if (!_selectedClasses.contains(className)) {
          continue;
        }

        final classSubjects = List<String>.from(cls["subjects"] ?? []);

        subjects.addAll(classSubjects);
      }
    }

    _subjectOptions = subjects.toSet().toList();

    // Remove subjects which don't belong to selected classes.
    _selectedSubjects = _selectedSubjects
        .where(_subjectOptions.contains)
        .toList();
  }

  // ============================================================
  // CITY → LOCATION OPTIONS
  // ============================================================

  void _buildLocationOptions() {
    final locations = <String>[];

    for (final city in filterData["cityCorporationWithLocation"]) {
      final cityName = city["name"]?.toString();

      if (!_selectedCities.contains(cityName)) {
        continue;
      }

      final cityLocations = List<String>.from(city["locations"] ?? []);

      locations.addAll(cityLocations);
    }

    _locationOptions = locations.toSet().toList();

    // Remove locations which don't belong to selected cities.
    _selectedLocations = _selectedLocations
        .where(_locationOptions.contains)
        .toList();
  }

  // ============================================================
  // SAVE
  // ============================================================

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _saving = true;
    });

    final tuitionPreference = {
      "tutoringMethod": _tutoringMethodController.text.trim(),

      "tuitionStyle": _selectedTutoringStyles,

      "preferredCategories": _selectedCategories,

      "preferredClasses": _selectedClasses,

      "preferredSubjects": _selectedSubjects,

      "placeOfTuition": _selectedPlacesOfTuition,

      "preferredCities": _selectedCities,

      "preferredLocations": _selectedLocations,

      "expectedSalary": _expectedSalaryController.text.trim(),
    };

    debugPrint("========== TUITION UPDATE ==========");
    debugPrint("Payload: $tuitionPreference");
    debugPrint("Experience: ${_totalExperienceController.text.trim()}");
    debugPrint("====================================");

    final success = await ref
        .read(profileProvider.notifier)
        .updateTuitionRelatedInfo(
          tuitionPreference: tuitionPreference,
          totalExperience: _totalExperienceController.text.trim(),
        );

    if (!mounted) {
      return;
    }

    setState(() {
      _saving = false;
    });

    if (success) {
      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text("Tuition information updated successfully"),
        ),
      );

      Navigator.pop(context, true);
    } else {
      final error = ref.read(profileProvider.notifier).error;

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(error ?? "Failed to update tuition information"),
        ),
      );
    }
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppBar(title: "Edit Tuition Information"),

      body: SafeArea(
        child: Form(
          key: _formKey,

          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),

            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,

              children: [
                const SizedBox(height: 12),

                // ==================================================
                // TUTORING INFORMATION
                // ==================================================
                const Text(
                  "Tutoring Information",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 16),

                AppInputField(
                  controller: _tutoringMethodController,
                  label: "Tutoring Method",
                  type: AppInputType.multiline,
                  maxLines: 4,
                  hint: "Explain your Tutoring Method ",
                ),

                // --------------------------------------------------
                // TUTORING STYLE
                // --------------------------------------------------
                AppInputField(
                  label: "Tutoring Styles",
                  type: AppInputType.dropdown,

                  dropdownItems: List<String>.from(
                    filterData["tutoringStyles"] ?? [],
                  ),

                  multiSelect: true,

                  selectedValues: _selectedTutoringStyles,

                  onMultiChanged: (values) {
                    setState(() {
                      _selectedTutoringStyles = List<String>.from(values);
                    });
                  },
                ),

                const SizedBox(height: 16),

                // ==================================================
                // TUITION PREFERENCES
                // ==================================================
                const Text(
                  "Tuition Preferences",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 16),

                // --------------------------------------------------
                // CATEGORY
                // --------------------------------------------------
                AppInputField(
                  label: "Preferred Categories",
                  type: AppInputType.dropdown,

                  dropdownItems: List<String>.from(
                    filterData["category"] ?? [],
                  ),

                  multiSelect: true,

                  selectedValues: _selectedCategories,

                  onMultiChanged: (values) {
                    setState(() {
                      _selectedCategories = List<String>.from(values);

                      _buildClassOptions();

                      _selectedSubjects = [];

                      _buildSubjectOptions();
                    });
                  },
                ),

                // --------------------------------------------------
                // CLASSES
                // --------------------------------------------------
                AppInputField(
                  label: "Preferred Classes",
                  type: AppInputType.dropdown,

                  hint: _selectedCategories.isEmpty
                      ? "Select category first"
                      : "Select Classes",

                  enabled: _selectedCategories.isNotEmpty,

                  dropdownItems: _classOptions,

                  multiSelect: true,

                  selectedValues: _selectedClasses,

                  onMultiChanged: (values) {
                    setState(() {
                      _selectedClasses = List<String>.from(values);

                      _buildSubjectOptions();
                    });
                  },
                ),

                // --------------------------------------------------
                // SUBJECTS
                // --------------------------------------------------
                AppInputField(
                  label: "Preferred Subjects",
                  type: AppInputType.dropdown,

                  hint: _selectedClasses.isEmpty
                      ? "Select class first"
                      : "Select Subjects",

                  enabled: _selectedClasses.isNotEmpty,

                  dropdownItems: _subjectOptions,

                  multiSelect: true,

                  selectedValues: _selectedSubjects,

                  onMultiChanged: (values) {
                    setState(() {
                      _selectedSubjects = List<String>.from(values);
                    });
                  },
                ),

                // --------------------------------------------------
                // PLACE OF TUITION
                // --------------------------------------------------
                AppInputField(
                  label: "Place of Tuition",
                  type: AppInputType.dropdown,

                  dropdownItems: List<String>.from(
                    filterData["placeOfTuition"] ?? [],
                  ),

                  multiSelect: true,

                  selectedValues: _selectedPlacesOfTuition,

                  onMultiChanged: (values) {
                    setState(() {
                      _selectedPlacesOfTuition = List<String>.from(values);
                    });
                  },
                ),

                const SizedBox(height: 16),

                // ==================================================
                // LOCATION
                // ==================================================
                const Text(
                  "Preferred Location",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 16),

                // --------------------------------------------------
                // CITIES
                // --------------------------------------------------
                AppInputField(
                  label: "Preferred Cities",
                  type: AppInputType.dropdown,

                  dropdownItems: List<String>.from(
                    filterData["cityCorporations"] ?? [],
                  ),

                  multiSelect: true,

                  selectedValues: _selectedCities,

                  onMultiChanged: (values) {
                    setState(() {
                      _selectedCities = List<String>.from(values);

                      _buildLocationOptions();
                    });
                  },
                ),

                // --------------------------------------------------
                // LOCATIONS
                // --------------------------------------------------
                AppInputField(
                  label: "Preferred Locations",
                  type: AppInputType.dropdown,

                  hint: _selectedCities.isEmpty
                      ? "Select city first"
                      : "Select Locations",

                  enabled: _selectedCities.isNotEmpty,

                  dropdownItems: _locationOptions,

                  multiSelect: true,

                  selectedValues: _selectedLocations,

                  onMultiChanged: (values) {
                    setState(() {
                      _selectedLocations = List<String>.from(values);
                    });
                  },
                ),

                const SizedBox(height: 16),

                // ==================================================
                // EXPERIENCE & SALARY
                // ==================================================
                const Text(
                  "Experience & Salary",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 16),

                AppInputField(
                  controller: _expectedSalaryController,
                  label: "Expected Salary",
                  hint:"eg: 6000"
                ),

                AppInputField(
                  controller: _totalExperienceController,
                  label: "Total Experience",
                  hint: "eg: 5 Years"
                ),

                const SizedBox(height: 30),

                // ==================================================
                // SAVE
                // ==================================================
                AppButton(
                  label: "Save Changes",
                  loading: _saving,
                  onPressed: _saving ? null : _save,
                ),

                const SizedBox(height: 30),
              ],
            ),
          ),
        ),
      ),
    );
  }
}
