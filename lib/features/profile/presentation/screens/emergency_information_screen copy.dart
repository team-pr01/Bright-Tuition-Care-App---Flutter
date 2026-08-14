import 'package:btcclient/core/widgets/button/app_button.dart';
import 'package:btcclient/core/widgets/input/app_input_field.dart';
import 'package:btcclient/core/widgets/navbar/common_appbar.dart';
import 'package:btcclient/features/auth/data/models/guardian_model.dart';
import 'package:btcclient/features/auth/presentation/provider/profile_notifier.dart';
import 'package:btcclient/features/jobs/data/constant/filter_data.dart';
import 'package:btcclient/features/profile/data/requests/update_personal_info_request.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EditGuardianPersonalInformationScreen extends ConsumerStatefulWidget {
  const EditGuardianPersonalInformationScreen({super.key});

  @override
  ConsumerState<EditGuardianPersonalInformationScreen> createState() =>
      _EditGuardianPersonalInformationScreenState();
}

class _EditGuardianPersonalInformationScreenState
    extends ConsumerState<EditGuardianPersonalInformationScreen> {
  final _formKey = GlobalKey<FormState>();

  bool _saving = false;

  late final TextEditingController _emergencyNameController;
  late final TextEditingController _emergencyPhoneController;
  late final TextEditingController _emergencyAddressController;
  late final TextEditingController _emergencyRelationController;

  List<String> _areaOptions = [];

  GuardianProfileModel get profile =>
      ref.read(profileProvider) as GuardianProfileModel;

  @override
  void initState() {
    super.initState();

    final p = profile;

    // =========================================================
    // EMERGENCY INFORMATION
    // =========================================================

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

  @override
  void dispose() {
    _emergencyNameController.dispose();
    _emergencyPhoneController.dispose();
    _emergencyAddressController.dispose();
    _emergencyRelationController.dispose();

    super.dispose();
  }

  // =============================================================
  // CITY → AREA
  // =============================================================

  List<String> _getAreaOptions(String city) {
    for (final item in filterData["cityCorporationWithLocation"]) {
      if (item["name"] == city) {
        return List<String>.from(item["locations"]);
      }
    }

    return [];
  }

  // =============================================================
  // SAVE
  // =============================================================

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) {
      return;
    }

    setState(() {
      _saving = true;
    });

    try {
      final request = UpdatePersonalInfoRequest(
        // =====================================================
        // PERSONAL INFORMATION
        // =====================================================
        personalInformation: PersonalInformationRequest(
          fatherName: "",
          fatherPhoneNumber: "",
          motherName: "",
          motherPhoneNumber: "",

          overview: "",

          // IMPORTANT:
          // Guardian emergency information is handled
          // separately below if your request model supports it.
          emergencyContactNumber: _emergencyPhoneController.text.trim(),
        ),

        // =====================================================
        // SOCIAL MEDIA
        // =====================================================
      );

      final success = await ref
          .read(profileProvider.notifier)
          .updatePersonalInfo(request);

      if (!mounted) return;

      setState(() {
        _saving = false;
      });

      if (success) {
        Navigator.pop(context, true);
      }
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _saving = false;
      });

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text("Failed to update profile: $e")));
    }
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppBar(title: "Edit Profile"),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                const SizedBox(height: 12),

                // =================================================
                // EMERGENCY INFORMATION
                // =================================================
                const Text(
                  "Emergency Information",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 16),

                AppInputField(
                  controller: _emergencyNameController,
                  label: "Emergency Contact Person Name",
                  hint: "Enter your Emergency Contact Person Name ",
                ),

                AppInputField(
                  controller: _emergencyPhoneController,
                  label: "Emergency Phone Number",
                  type: AppInputType.phone,
                  hint: "eg: 01xxxxxxxxx",
                ),

                AppInputField(
                  controller: _emergencyAddressController,
                  label: "Emergency Address",
                  type: AppInputType.multiline,
                  maxLines: 3,
                   hint:"Enter your Emergency Address",
                ),

                AppInputField(
                  controller: _emergencyRelationController,
                  label: "Relation",
                  hint:" Enter your Relation with Emergency Content"
                ),

                const SizedBox(height: 32),

                // =================================================
                // SOCIAL MEDIA
                // =================================================
                const Text(
                  "Social Media",
                  style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
                ),

                const SizedBox(height: 40),

                // =================================================
                // SAVE
                // =================================================
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
