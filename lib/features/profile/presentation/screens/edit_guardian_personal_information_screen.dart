import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:btcclient/core/config/theme.dart';
import 'package:btcclient/core/widgets/button/app_button.dart';
import 'package:btcclient/core/widgets/input/app_input_field.dart';
import 'package:btcclient/core/widgets/navbar/common_appbar.dart';

import 'package:btcclient/features/auth/data/models/guardian_model.dart';
import 'package:btcclient/features/auth/presentation/provider/profile_notifier.dart';

import 'package:btcclient/features/jobs/data/constant/filter_data.dart';

import 'package:btcclient/features/profile/data/requests/update_personal_info_request.dart';

class EditGuardianPersonalInformationScreen
    extends ConsumerStatefulWidget {
  const EditGuardianPersonalInformationScreen({
    super.key,
  });

  @override
  ConsumerState<EditGuardianPersonalInformationScreen> createState() =>
      _EditGuardianPersonalInformationScreenState();
}

class _EditGuardianPersonalInformationScreenState
    extends ConsumerState<EditGuardianPersonalInformationScreen> {
  final GlobalKey<FormState> _formKey = GlobalKey<FormState>();

  bool _saving = false;

  // ============================================================
  // BASIC INFORMATION
  // ============================================================

  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  late final TextEditingController _genderController;
  late final TextEditingController _cityController;
  late final TextEditingController _areaController;

  // ============================================================
  // PERSONAL INFORMATION
  // ============================================================

  late final TextEditingController _additionalPhoneController;
  late final TextEditingController _dobController;
  late final TextEditingController _addressController;
  late final TextEditingController _religionController;
  late final TextEditingController _nationalityController;

  // ============================================================
  // SOCIAL MEDIA
  // ============================================================

  late final TextEditingController _facebookController;

  // ============================================================
  // EMERGENCY INFORMATION
  // ============================================================

  late final TextEditingController _emergencyNameController;
  late final TextEditingController _emergencyPhoneController;
  late final TextEditingController _emergencyAddressController;
  late final TextEditingController _emergencyRelationController;

  // ============================================================
  // DROPDOWN
  // ============================================================

  List<String> _areaOptions = [];

  // ============================================================
  // PROFILE
  // ============================================================

  GuardianProfileModel get profile {
    final value = ref.read(profileProvider);

    if (value == null) {
      throw Exception("Guardian profile not available");
    }

    if (value is! GuardianProfileModel) {
      throw Exception("Current profile is not a guardian profile");
    }

    return value;
  }

  // ============================================================
  // INIT
  // ============================================================

  @override
  void initState() {
    super.initState();

    final p = profile;

    // ============================================================
    // BASIC INFORMATION
    // ============================================================

    _nameController = TextEditingController(
      text: p.name,
    );

    _emailController = TextEditingController(
      text: p.email,
    );

    _phoneController = TextEditingController(
      text: p.phoneNumber,
    );

    _genderController = TextEditingController(
      text: p.gender,
    );

    _cityController = TextEditingController(
      text: p.city,
    );

    _areaController = TextEditingController(
      text: p.area,
    );

    // Existing city -> load areas.
    if (_cityController.text.trim().isNotEmpty) {
      _areaOptions = _getAreaOptions(
        _cityController.text.trim(),
      );
    }

    // ============================================================
    // PERSONAL INFORMATION
    // ============================================================

    _additionalPhoneController = TextEditingController(
      text: p.additionalPhone ?? "",
    );

    _dobController = TextEditingController(
      text: _formatDateForInput(
        p.dateOfBirth,
      ),
    );

    _addressController = TextEditingController(
      text: p.address ?? "",
    );

    _religionController = TextEditingController(
      text: p.religion ?? "",
    );

    _nationalityController = TextEditingController(
      text: p.nationality ?? "",
    );

    // ============================================================
    // SOCIAL
    // ============================================================

    _facebookController = TextEditingController(
      text: p.facebook ?? "",
    );

    // ============================================================
    // EMERGENCY
    // ============================================================

    _emergencyNameController = TextEditingController(
      text: p.emergencyName ?? "",
    );

    _emergencyPhoneController = TextEditingController(
      text: p.emergencyPhone ?? "",
    );

    _emergencyAddressController = TextEditingController(
      text: p.emergencyAddress ?? "",
    );

    _emergencyRelationController = TextEditingController(
      text: p.emergencyRelation ?? "",
    );
  }

  // ============================================================
  // DATE FORMAT
  // ============================================================

  String _formatDateForInput(String? date) {
    if (date == null || date.trim().isEmpty) {
      return "";
    }

    final value = date.trim();

    // Already DD/MM/YYYY
    if (RegExp(
      r'^\d{2}/\d{2}/\d{4}$',
    ).hasMatch(value)) {
      return value;
    }

    // ISO date
    try {
      final parsed = DateTime.parse(value);

      final day = parsed.day
          .toString()
          .padLeft(2, "0");

      final month = parsed.month
          .toString()
          .padLeft(2, "0");

      final year = parsed.year.toString();

      return "$day/$month/$year";
    } catch (_) {
      return value;
    }
  }

  // ============================================================
  // CITY -> AREA
  // ============================================================

  List<String> _getAreaOptions(String city) {
    try {
      final data =
          filterData["cityCorporationWithLocation"];

      if (data is! List) {
        return [];
      }

      for (final item in data) {
        if (item is Map &&
            item["name"]?.toString() == city) {
          final locations = item["locations"];

          if (locations is List) {
            return locations
                .map((e) => e.toString())
                .where((e) => e.trim().isNotEmpty)
                .toList();
          }
        }
      }
    } catch (e) {
      debugPrint(
        "Error loading area options: $e",
      );
    }

    return [];
  }

  // ============================================================
  // CITY OPTIONS
  // ============================================================

  List<String> _getCityOptions() {
    try {
      final data =
          filterData["cityCorporationWithLocation"];

      if (data is! List) {
        return [];
      }

      return data
          .whereType<Map>()
          .map(
            (item) =>
                item["name"]?.toString() ?? "",
          )
          .where(
            (name) => name.trim().isNotEmpty,
          )
          .toList();
    } catch (e) {
      debugPrint(
        "Error loading city options: $e",
      );

      return [];
    }
  }

  // ============================================================
  // SAVE
  // ============================================================

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_saving) {
      return;
    }

    setState(() {
      _saving = true;
    });

    try {
      final request = UpdatePersonalInfoRequest(
        // ========================================================
        // BASIC INFORMATION
        // ========================================================

        name: _nameController.text.trim(),

        email: _emailController.text.trim(),

        phoneNumber: _phoneController.text.trim(),

        gender: _genderController.text.trim(),

        city: _cityController.text.trim(),

        area: _areaController.text.trim(),

        // ========================================================
        // PERSONAL INFORMATION
        // ========================================================

        personalInformation:
            PersonalInformationRequest(
          additionalPhoneNumber:
              _additionalPhoneController
                  .text
                  .trim(),

          dateOfBirth:
              _dobController.text.trim(),

          address:
              _addressController.text.trim(),

          religion:
              _religionController.text.trim(),

          nationality:
              _nationalityController.text.trim(),

          // Guardian does not use tutor family fields.
          fatherName: "",

          fatherPhoneNumber: "",

          motherName: "",

          motherPhoneNumber: "",

          // Guardian does not have tutor overview.
          overview: "",

          // ======================================================
          // EMERGENCY PHONE
          // ======================================================

          emergencyContactNumber:
              _emergencyPhoneController
                  .text
                  .trim(),
        ),

        // ========================================================
        // SOCIAL MEDIA
        // ========================================================

        socialMediaInformation:
            SocialMediaInformationRequest(
          facebook:
              _facebookController.text.trim(),
        ),
      );

      debugPrint(
        "========================================",
      );

      debugPrint(
        "GUARDIAN PROFILE UPDATE",
      );

      debugPrint(
        "========================================",
      );

      debugPrint(
        "Name: ${_nameController.text.trim()}",
      );

      debugPrint(
        "Email: ${_emailController.text.trim()}",
      );

      debugPrint(
        "Phone: ${_phoneController.text.trim()}",
      );

      debugPrint(
        "Gender: ${_genderController.text.trim()}",
      );

      debugPrint(
        "City: ${_cityController.text.trim()}",
      );

      debugPrint(
        "Area: ${_areaController.text.trim()}",
      );

      debugPrint(
        "Additional Phone: "
        "${_additionalPhoneController.text.trim()}",
      );

      debugPrint(
        "DOB: ${_dobController.text.trim()}",
      );

      debugPrint(
        "Address: ${_addressController.text.trim()}",
      );

      debugPrint(
        "Religion: ${_religionController.text.trim()}",
      );

      debugPrint(
        "Nationality: "
        "${_nationalityController.text.trim()}",
      );

      debugPrint(
        "Facebook: "
        "${_facebookController.text.trim()}",
      );

      debugPrint(
        "Emergency Name: "
        "${_emergencyNameController.text.trim()}",
      );

      debugPrint(
        "Emergency Phone: "
        "${_emergencyPhoneController.text.trim()}",
      );

      debugPrint(
        "Emergency Address: "
        "${_emergencyAddressController.text.trim()}",
      );

      debugPrint(
        "Emergency Relation: "
        "${_emergencyRelationController.text.trim()}",
      );

      debugPrint(
        "REQUEST JSON: ${request.toJson()}",
      );

      debugPrint(
        "========================================",
      );

      final success = await ref
          .read(profileProvider.notifier)
          .updatePersonalInfo(request);

      if (!mounted) {
        return;
      }

      if (!success) {
        setState(() {
          _saving = false;
        });

        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              ref.read(profileProvider.notifier).error ??
                  "Failed to update profile.",
            ),
          ),
        );

        return;
      }

      // Refresh profile after successful update.
      await ref
          .read(profileProvider.notifier)
          .refreshProfile();

      if (!mounted) {
        return;
      }

      setState(() {
        _saving = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(
          content: Text(
            "Profile updated successfully.",
          ),
        ),
      );

      Navigator.pop(context, true);
    } catch (e, stackTrace) {
      debugPrint(
        "Guardian profile update failed: $e",
      );

      debugPrintStack(
        stackTrace: stackTrace,
      );

      if (!mounted) {
        return;
      }

      setState(() {
        _saving = false;
      });

      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text(
            "Failed to update profile: $e",
          ),
        ),
      );
    }
  }

  // ============================================================
  // SECTION TITLE
  // ============================================================

  Widget _sectionTitle(String title) {
    return Padding(
      padding: const EdgeInsets.only(
        bottom: 16,
      ),
      child: Text(
        title,
        style: const TextStyle(
          fontSize: 18,
          fontWeight: FontWeight.w700,
        ),
      ),
    );
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    final cityOptions = _getCityOptions();

    return Scaffold(
      backgroundColor: AppColors.neutrals01,

      appBar: const CommonAppBar(
        title: "Edit Profile",
      ),

      body: SafeArea(
        child: Form(
          key: _formKey,

          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),

            child: Column(
              crossAxisAlignment:
                  CrossAxisAlignment.start,

              children: [
                // ==================================================
                // BASIC INFORMATION
                // ==================================================

                _sectionTitle(
                  "Basic Information",
                ),

                AppInputField(
                  controller: _nameController,
                  label: "Full Name",
                  enabled: !_saving,
                ),

               

                AppInputField(
                  controller: _emailController,
                  label: "Email",
                  enabled: !_saving,
                ),

               

                AppInputField(
                  controller: _phoneController,
                  label: "Phone Number",
                  type: AppInputType.phone,
                  enabled: !_saving,
                ),

               

                AppInputField(
                  controller: _genderController,
                  label: "Gender",
                  type: AppInputType.dropdown,
                  value: _genderController.text,
                  dropdownItems: const [
                    "male",
                    "female",
                    "other",
                  ],
                  enabled: !_saving,
                  onChanged: (value) {
                    setState(() {
                      _genderController.text =
                          value ?? "";
                    });
                  },
                ),

               

                // ==================================================
                // CITY
                // ==================================================

                AppInputField(
                  label: "City",
                  type: AppInputType.dropdown,
                  value: _cityController.text,
                  hint: "Select City",
                  dropdownItems: cityOptions,
                  enabled: !_saving,
                  onChanged: (value) {
                    final city =
                        value ?? "";

                    setState(() {
                      _cityController.text =
                          city;

                      _areaController.clear();

                      _areaOptions =
                          _getAreaOptions(
                        city,
                      );
                    });
                  },
                ),

               

                // ==================================================
                // AREA
                // ==================================================

                AppInputField(
                  label: "Area",
                  type: AppInputType.dropdown,
                  value: _areaController.text,
                  hint: _cityController.text
                          .trim()
                          .isEmpty
                      ? "Select city first"
                      : "Select Area",
                  enabled:
                      !_saving &&
                      _cityController.text
                          .trim()
                          .isNotEmpty &&
                      _areaOptions.isNotEmpty,
                  dropdownItems:
                      _areaOptions,
                  onChanged: (value) {
                    setState(() {
                      _areaController.text =
                          value ?? "";
                    });
                  },
                ),

                const SizedBox(height: 32),

                // ==================================================
                // PERSONAL INFORMATION
                // ==================================================

                _sectionTitle(
                  "Personal Information",
                ),

                AppInputField(
                  controller:
                      _additionalPhoneController,
                  label:
                      "Additional Phone Number",
                  type: AppInputType.phone,
                  enabled: !_saving,
                ),

               

                AppInputField(
                  controller:
                      _dobController,
                  label: "Date of Birth",
                  type: AppInputType.date,
                  enabled: !_saving,
                ),

               

                AppInputField(
                  controller:
                      _addressController,
                  label: "Address",
                  type: AppInputType.multiline,
                  maxLines: 3,
                  enabled: !_saving,
                ),

               

                AppInputField(
                  controller:
                      _religionController,
                  label: "Religion",
                  enabled: !_saving,
                ),

               

                AppInputField(
                  controller:
                      _nationalityController,
                  label: "Nationality",
                  enabled: !_saving,
                ),

                const SizedBox(height: 32),

                // ==================================================
                // SOCIAL MEDIA
                // ==================================================

                _sectionTitle(
                  "Social Media",
                ),

                AppInputField(
                  controller:
                      _facebookController,
                  label: "Facebook Profile",
                  enabled: !_saving,
                ),

                const SizedBox(height: 32),

                // ==================================================
                // EMERGENCY INFORMATION
                // ==================================================

                _sectionTitle(
                  "Emergency Information",
                ),

                AppInputField(
                  controller:
                      _emergencyNameController,
                  label:
                      "Emergency Contact Person",
                  enabled: !_saving,
                ),

               

                AppInputField(
                  controller:
                      _emergencyPhoneController,
                  label:
                      "Emergency Phone Number",
                  type: AppInputType.phone,
                  enabled: !_saving,
                ),

               

                AppInputField(
                  controller:
                      _emergencyRelationController,
                  label: "Relation",
                  enabled: !_saving,
                ),

               

                AppInputField(
                  controller:
                      _emergencyAddressController,
                  label:
                      "Emergency Address",
                  type: AppInputType.multiline,
                  maxLines: 3,
                  enabled: !_saving,
                ),

                const SizedBox(height: 32),

                // ==================================================
                // SAVE BUTTON
                // ==================================================

                SizedBox(
                  width: double.infinity,
                  child: AppButton(
                    label: _saving
                        ? "Saving..."
                        : "Save Changes",
                    variant:
                        AppButtonVariant.gradient,
                    height: 48,
                    onPressed:
                        _saving ? null : _save,
                  ),
                ),

                const SizedBox(height: 20),
              ],
            ),
          ),
        ),
      ),
    );
  }

  // ============================================================
  // DISPOSE
  // ============================================================

  @override
  void dispose() {
    _nameController.dispose();
    _emailController.dispose();
    _phoneController.dispose();
    _genderController.dispose();
    _cityController.dispose();
    _areaController.dispose();

    _additionalPhoneController.dispose();
    _dobController.dispose();
    _addressController.dispose();
    _religionController.dispose();
    _nationalityController.dispose();

    _facebookController.dispose();

    _emergencyNameController.dispose();
    _emergencyPhoneController.dispose();
    _emergencyAddressController.dispose();
    _emergencyRelationController.dispose();

    super.dispose();
  }
}