import 'package:btcclient/core/widgets/button/app_button.dart';
import 'package:btcclient/core/widgets/input/app_input_field.dart';
import 'package:btcclient/core/widgets/navbar/common_appbar.dart';
import 'package:btcclient/features/auth/data/models/tutor_model.dart';
import 'package:btcclient/features/auth/presentation/provider/profile_notifier.dart';
import 'package:btcclient/features/profile/data/requests/update_personal_info_request.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class EditPersonalInformationScreen extends ConsumerStatefulWidget {
  const EditPersonalInformationScreen({super.key});

  @override
  ConsumerState<EditPersonalInformationScreen> createState() =>
      _EditPersonalInformationScreenState();
}

class _EditPersonalInformationScreenState
    extends ConsumerState<EditPersonalInformationScreen> {
  final _formKey = GlobalKey<FormState>();

  bool _saving = false;

  String? _imagePath;

  late final TextEditingController _nameController;
  late final TextEditingController _emailController;
  late final TextEditingController _phoneController;
  late final TextEditingController _genderController;
  late final TextEditingController _cityController;
  late final TextEditingController _areaController;

  late final TextEditingController _additionalPhoneController;
  late final TextEditingController _dobController;
  late final TextEditingController _addressController;
  late final TextEditingController _religionController;
  late final TextEditingController _nationalityController;

  late final TextEditingController _fatherNameController;
  late final TextEditingController _fatherPhoneController;
  late final TextEditingController _motherNameController;
  late final TextEditingController _motherPhoneController;
  late final TextEditingController _emergencyPhoneController;

  late final TextEditingController _facebookController;
  late final TextEditingController _overviewController;

TutorProfileModel get profile =>
    ref.read(profileProvider) as TutorProfileModel;

  @override
  void initState() {
    super.initState();

    final p = profile;

    _nameController = TextEditingController(text: p.name);
    _emailController = TextEditingController(text: p.email);
    _phoneController = TextEditingController(text: p.phoneNumber);
    _genderController = TextEditingController(text: p.gender);
    _cityController = TextEditingController(text: p.city);
    _areaController = TextEditingController(text: p.area);

    _additionalPhoneController = TextEditingController(
      text: p.personalInfo.additionalPhone ?? "",
    );

    _dobController = TextEditingController(
      text: p.personalInfo.dateOfBirth ?? "",
    );

    _addressController = TextEditingController(
      text: p.personalInfo.address ?? "",
    );

    _religionController = TextEditingController(
      text: p.personalInfo.religion ?? "",
    );

    _nationalityController = TextEditingController();

    _fatherNameController = TextEditingController(
      text: p.personalInfo.fatherName ?? "",
    );

    _fatherPhoneController = TextEditingController(
      text: p.personalInfo.fatherPhoneNumber ?? "",
    );

    _motherNameController = TextEditingController(
      text: p.personalInfo.motherName ?? "",
    );

    _motherPhoneController = TextEditingController(
      text: p.personalInfo.motherPhoneNumber ?? "",
    );

    _emergencyPhoneController = TextEditingController(
      text: p.personalInfo.emergencyContactNumber ?? "",
    );

    _facebookController = TextEditingController(
      text: p.socialMedia.facebook ?? "",
    );

    _overviewController = TextEditingController(
      text: p.personalInfo.overview ?? "",
    );
  }

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

    _fatherNameController.dispose();
    _fatherPhoneController.dispose();
    _motherNameController.dispose();
    _motherPhoneController.dispose();
    _emergencyPhoneController.dispose();

    _facebookController.dispose();
    _overviewController.dispose();

    super.dispose();
  }

  Future<void> _save() async {
    if (!_formKey.currentState!.validate()) return;

    setState(() {
      _saving = true;
    });

    final request = UpdatePersonalInfoRequest(
      name: _nameController.text.trim(),
      email: _emailController.text.trim(),
      phoneNumber: _phoneController.text.trim(),
      gender: _genderController.text.trim(),
      city: _cityController.text.trim(),
      area: _areaController.text.trim(),
      personalInformation: PersonalInformationRequest(
        additionalPhoneNumber: _additionalPhoneController.text.trim(),
        dateOfBirth: _dobController.text.trim(),
        address: _addressController.text.trim(),
        religion: _religionController.text.trim(),
        nationality: _nationalityController.text.trim(),
        fatherName: _fatherNameController.text.trim(),
        fatherPhoneNumber: _fatherPhoneController.text.trim(),
        motherName: _motherNameController.text.trim(),
        motherPhoneNumber: _motherPhoneController.text.trim(),
        overview: _overviewController.text.trim(),
        emergencyContactNumber: _emergencyPhoneController.text.trim(),
      ),
      socialMediaInformation: SocialMediaInformationRequest(
        facebook: _facebookController.text.trim(),
      ),
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
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppBar( 
        title: "Personal Information",
      ),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            padding: const EdgeInsets.all(20),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [


                const SizedBox(height: 12),

                const Text(
                  "Basic Information",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 18),

                AppInputField(
                  controller: _nameController,
                  label: "Full Name",
                ),

                const SizedBox(height: 16),

                AppInputField(
                  controller: _emailController,
                  label: "Email",
                ),

                const SizedBox(height: 16),

                AppInputField(
                  controller: _phoneController,
                  label: "Phone Number",
                ),

                const SizedBox(height: 16),

                AppInputField(
                  controller: _genderController,
                  label: "Gender",
                ),

                const SizedBox(height: 16),

                AppInputField(
                  controller: _cityController,
                  label: "City",
                ),

                const SizedBox(height: 16),

                AppInputField(
                  controller: _areaController,
                  label: "Area",
                ),

                const SizedBox(height: 30),                const Text(
                  "Personal Information",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 18),

                AppInputField(
                  controller: _additionalPhoneController,
                  label: "Additional Phone Number",
                  type: AppInputType.phone,
                ),

                const SizedBox(height: 16),

                AppInputField(
                  controller: _dobController,
                  label: "Date of Birth",
                  type: AppInputType.date,
                ),

                const SizedBox(height: 16),

                AppInputField(
                  controller: _addressController,
                  label: "Address",
                  type: AppInputType.multiline,
                  maxLines: 3,
                ),

                const SizedBox(height: 16),

                AppInputField(
                  controller: _religionController,
                  label: "Religion",
                ),

                const SizedBox(height: 16),

                AppInputField(
                  controller: _nationalityController,
                  label: "Nationality",
                ),

                const SizedBox(height: 32),

                const Text(
                  "Family Information",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 18),

                AppInputField(
                  controller: _fatherNameController,
                  label: "Father Name",
                ),

                const SizedBox(height: 16),

                AppInputField(
                  controller: _fatherPhoneController,
                  label: "Father Phone Number",
                  type: AppInputType.phone,
                ),

                const SizedBox(height: 16),

                AppInputField(
                  controller: _motherNameController,
                  label: "Mother Name",
                ),

                const SizedBox(height: 16),

                AppInputField(
                  controller: _motherPhoneController,
                  label: "Mother Phone Number",
                  type: AppInputType.phone,
                ),

                const SizedBox(height: 16),

                AppInputField(
                  controller: _emergencyPhoneController,
                  label: "Emergency Contact Number",
                  type: AppInputType.phone,
                ),

                const SizedBox(height: 32),

                const Text(
                  "Social Media",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 18),

                AppInputField(
                  controller: _facebookController,
                  label: "Facebook Profile",
                ),

                const SizedBox(height: 32),

                const Text(
                  "Overview",
                  style: TextStyle(
                    fontSize: 18,
                    fontWeight: FontWeight.bold,
                  ),
                ),

                const SizedBox(height: 18),

                AppInputField(
                  controller: _overviewController,
                  label: "Write something about yourself",
                  type: AppInputType.multiline,
                  maxLines: 6,
                ),

                const SizedBox(height: 40),

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