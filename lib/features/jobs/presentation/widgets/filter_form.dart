import 'package:btcclient/features/jobs/data/constant/filter_data.dart';
import 'package:flutter/material.dart';
import '../../data/models/job_filter.dart';
import '../../../../core/widgets/button/app_button.dart';
import '../../../../core/widgets/input/app_input_field.dart';

class FilterSidebar extends StatefulWidget {
  final Function(JobFilter) onApply;

  const FilterSidebar({super.key, required this.onApply});

  @override
  State<FilterSidebar> createState() => _FilterSidebarState();
}

class _FilterSidebarState extends State<FilterSidebar> {
  /// 🔥 MULTI SELECT STATES
  List<String> cities = [];
  List<String> areas = [];
  List<String> categories = [];
  List<String> classes = [];
  List<String> subjects = [];
  List<String> days = [];
  List<String> tuitionTypes = [];
  List<String> tutorGender = [];
  List<String> studentGender = [];

  /// 🔥 OPTIONS
  List<String> areaOptions = [];
  List<String> classOptions = [];
  List<String> subjectOptions = [];

  /// ================= CITY → AREA =================
  void _onCityChanged(List<String> selectedCities) {
    setState(() {
      cities = selectedCities;

      areaOptions = [];

      for (var c in filterData["cityCorporationWithLocation"]) {
        if (cities.contains(c["name"])) {
          areaOptions.addAll(List<String>.from(c["locations"]));
        }
      }

      areas = [];
    });
  }

  /// ================= CATEGORY → CLASS =================
  void _onCategoryChanged(List<String> selectedCategories) {
    setState(() {
      categories = selectedCategories;

      classOptions = [];

      for (var cat in filterData["tutoringCatalog"]) {
        if (categories.contains(cat["category"])) {
          for (var cls in cat["classes"]) {
            classOptions.add(cls["name"]);
          }
        }
      }

      classes = [];
      subjects = [];
      subjectOptions = [];
    });
  }

  /// ================= CLASS → SUBJECT =================
  void _onClassChanged(List<String> selectedClasses) {
    setState(() {
      classes = selectedClasses;

      subjectOptions = [];

      for (var cat in filterData["tutoringCatalog"]) {
        if (categories.contains(cat["category"])) {
          for (var cls in cat["classes"]) {
            if (classes.contains(cls["name"])) {
              subjectOptions.addAll(List<String>.from(cls["subjects"]));
            }
          }
        }
      }

      subjects = [];
    });
  }

  /// ================= APPLY =================
 void _apply() {
  final filter = JobFilter(
    status: "live",
    city: cities,
    area: areas,
    category: categories,
    className: classes,
    tutoringDays: days,
    tuitionType: tuitionTypes,
    subjects: subjects,

    /// 🔥 FIXED
    preferredTutorGender:
        tutorGender.contains("All") ? null : tutorGender,
    studentGender: studentGender,
  );

  widget.onApply(filter);
  Navigator.pop(context);
}
  /// ================= RESET =================
  void _reset() {
  setState(() {
    cities = [];
    areas = [];
    categories = [];
    classes = [];
    subjects = [];
    days = [];
    tuitionTypes = [];
    tutorGender = [];
    studentGender = [];

    areaOptions = [];
    classOptions = [];
    subjectOptions = [];
  });

  widget.onApply(JobFilter(status: "live"));
  Navigator.pop(context);
}
  @override
  Widget build(BuildContext context) {
    return Material(
      child: Container(
        width: double.infinity,
        height: double.infinity,
        padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 24),
        color: Colors.white,
        child: Column(
          children: [
            /// HEADER
            Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                const Text(
                  "Filters",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.w600),
                ),
                IconButton(
                  icon: const Icon(Icons.close),
                  onPressed: () => Navigator.pop(context),
                ),
              ],
            ),

            Expanded(
              child: SingleChildScrollView(
                child: Column(
                  children: [
                    /// CITY (MULTI)
                    AppInputField(
                      label: "City",
                      type: AppInputType.dropdown,
                      multiSelect: true,
                      dropdownItems: List<String>.from(
                        filterData["cityCorporations"],
                      ),
                      selectedValues: cities,
                      onMultiChanged: _onCityChanged,
                    ),

                    /// AREA (MULTI)
                    AppInputField(
                      label: "Area",
                      type: AppInputType.dropdown,
                      multiSelect: true,
                      dropdownItems: areaOptions,
                      selectedValues: areas,
                      onMultiChanged: (v) => setState(() => areas = v),
                    ),

                    /// CATEGORY (MULTI)
                    AppInputField(
                      label: "Category",
                      type: AppInputType.dropdown,
                      multiSelect: true,
                      dropdownItems: List<String>.from(filterData["category"]),
                      selectedValues: categories,
                      onMultiChanged: _onCategoryChanged,
                    ),

                    /// CLASS (MULTI)
                    AppInputField(
                      label: "Class",
                      type: AppInputType.dropdown,
                      multiSelect: true,
                      dropdownItems: classOptions,
                      selectedValues: classes,
                      onMultiChanged: _onClassChanged,
                    ),

                    /// SUBJECT (MULTI)
                    AppInputField(
                      label: "Subjects",
                      type: AppInputType.dropdown,
                      multiSelect: true,
                      dropdownItems: subjectOptions,
                      selectedValues: subjects,
                      onMultiChanged: (v) => setState(() => subjects = v),
                    ),

                    /// DAYS (MULTI)
                    AppInputField(
                      label: "Days Per Week",
                      type: AppInputType.dropdown,
                      multiSelect: true,
                      dropdownItems: List<String>.from(
                        filterData["daysPerWeek"],
                      ),
                      selectedValues: days,
                      onMultiChanged: (v) => setState(() => days = v),
                    ),

                    /// TUITION TYPE (MULTI)
                    AppInputField(
                      label: "Tuition Type",
                      type: AppInputType.dropdown,
                      multiSelect: true,
                      dropdownItems: List<String>.from(
                        filterData["tuitionType"],
                      ),
                      selectedValues: tuitionTypes,
                      onMultiChanged: (v) => setState(() => tuitionTypes = v),
                    ),

                    /// TUTOR GENDER
                    AppInputField(
                      label: "Tutor Gender",
                      type: AppInputType.dropdown,
                      multiSelect: true,
                      dropdownItems: tutorGenderOptions,
                      selectedValues: tutorGender,
                      onMultiChanged: (v) {
                        setState(() {
                          /// 🔥 HANDLE "ALL"
                          if (v.contains("All")) {
                            tutorGender = ["All"];
                          } else {
                            tutorGender = v.where((e) => e != "All").toList();
                          }
                        });
                      },
                    ),

                    /// STUDENT GENDER
                    AppInputField(
                      label: "Student Gender",
                      type: AppInputType.dropdown,
                      multiSelect: true,
                      dropdownItems: studentGenderOptions,
                      selectedValues: studentGender,
                      onMultiChanged: (v) => setState(() => studentGender = v),
                    ),
                  ],
                ),
              ),
            ),

            /// BUTTONS
            Row(
              children: [
                Expanded(
                  child: AppButton(
                    label: "Reset",
                    variant: AppButtonVariant.outlineGray,
                    onPressed: _reset,
                  ),
                ),
                const SizedBox(width: 10),
                Expanded(
                  child: AppButton(
                    label: "Apply",
                    variant: AppButtonVariant.gradient,
                    onPressed: _apply,
                  ),
                ),
              ],
            ),
          ],
        ),
      ),
    );
  }
}
