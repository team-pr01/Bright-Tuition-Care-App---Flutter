import 'package:btcclient/core/widgets/button/app_button.dart';
import 'package:btcclient/core/widgets/input/app_input_field.dart';
import 'package:btcclient/core/widgets/navbar/common_appbar.dart';
import 'package:btcclient/features/auth/data/models/tutor_model.dart';
import 'package:btcclient/features/auth/presentation/provider/profile_notifier.dart';
import 'package:btcclient/features/jobs/data/constant/filter_data.dart';
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
  late final TextEditingController _homeDistrictController;
  late final TextEditingController _bloodGroupController;

  late final TextEditingController _fatherNameController;
  late final TextEditingController _fatherPhoneController;
  late final TextEditingController _motherNameController;
  late final TextEditingController _motherPhoneController;
  late final TextEditingController _emergencyPhoneController;

  late final TextEditingController _facebookController;
  late final TextEditingController _overviewController;

  List<String> _areaOptions = [];

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

    _homeDistrictController = TextEditingController(
      text: p.personalInfo.homeDistrict ?? "",
    );
    _bloodGroupController = TextEditingController(
      text: p.personalInfo.bloodGroup ?? "",
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
    _homeDistrictController.dispose();
    _bloodGroupController.dispose();

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
        homeDistrict: _homeDistrictController.text.trim(),
        bloodGroup: _bloodGroupController.text.trim(),
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

  List<String> _getAreaOptions(String city) {
    for (final item in filterData["cityCorporationWithLocation"]) {
      if (item["name"] == city) {
        return List<String>.from(item["locations"]);
      }
    }

    return [];
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppBar(title: "Edit Profile"),
      body: SafeArea(
        child: Form(
          key: _formKey,
          child: Column(
            children: [
              /// SCROLLABLE CONTENT
              Expanded(
                child: SingleChildScrollView(
                  padding: const EdgeInsets.all(20),
                  child: Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                      const Text(
                        "Basic Information",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 16),

                      AppInputField(
                        controller: _nameController,
                        label: "Full Name",
                        hint: "Enter your Name",
                      ),

                      AppInputField(
                        controller: _emailController,
                        label: "Email",
                        hint: "youremail.com",
                      ),

                      AppInputField(
                        controller: _phoneController,
                        label: "Phone Number",
                        type: AppInputType.phone,
                        hint: "eg: 01xxxxxxxxx",
                      ),

                      AppInputField(
                        controller: _genderController,
                        label: "Gender",
                        type: AppInputType.dropdown2,
                        dropdownItems: List<String>.from(studentGenderOptions),
                      ),

                      AppInputField(
                        label: "City",
                        type: AppInputType.dropdown2,
                        value: _cityController.text,
                        hint: "Select City",
                        dropdownItems: List<String>.from(
                          filterData["cityCorporations"],
                        ),
                        onChanged: (value) {
                          setState(() {
                            _cityController.text = value ?? "";
                            _areaController.clear();
                            _areaOptions = _getAreaOptions(
                              _cityController.text,
                            );
                          });
                        },
                      ),

                      AppInputField(
                        label: "Location",
                        type: AppInputType.dropdown2,
                        value: _areaController.text,
                        hint: _cityController.text.isEmpty
                            ? "Select city first"
                            : "Select Area",
                        enabled:
                            _cityController.text.isNotEmpty &&
                            _areaOptions.isNotEmpty,
                        dropdownItems: _areaOptions,
                        onChanged: (value) {
                          setState(() {
                            _areaController.text = value ?? "";
                          });
                        },
                      ),

                      AppInputField(
                        controller: _additionalPhoneController,
                        label: "Additional Phone Number",
                        type: AppInputType.phone,
                        hint: "eg: 01xxxxxxxxx",
                      ),

                      AppInputField(
                        controller: _dobController,
                        label: "Date of Birth",
                        type: AppInputType.date,
                        hint: "dd/mm/yyyy",
                      ),

                      AppInputField(
                        controller: _addressController,
                        label: "PresentAddress",
                        type: AppInputType.multiline,
                        maxLines: 3,
                        hint: "Enter your address",
                      ),

                      AppInputField(
                        label: "Home District",
                        type: AppInputType.dropdown2,
                        value: _homeDistrictController.text,
                        hint: "Select Home District",
                        dropdownItems: List<String>.from(
                          filterData["cityCorporations"],
                        ),
                        onChanged: (value) {
                          setState(() {
                            _homeDistrictController.text = value ?? "";
                          });
                        },
                      ),

                      AppInputField(
                        label: "Blood Group",
                        type: AppInputType.dropdown2,
                        value: _bloodGroupController.text,
                        hint: "Select Blood Group",
                        dropdownItems: bloodGroups,
                        onChanged: (value) {
                          setState(() {
                            _bloodGroupController.text = value ?? "";
                          });
                        },
                      ),

                      AppInputField(
                        controller: _religionController,
                        label: "Religion",
                        hint: "Enter your Religion",
                      ),

                      AppInputField(
                        controller: _nationalityController,
                        label: "Nationality",
                        hint: "eg: Bangladesh",
                      ),

                      const SizedBox(height: 4),

                      const Text(
                        "Family Information",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 16),

                      AppInputField(
                        controller: _fatherNameController,
                        label: "Father Name",
                        hint: "Enter your Father Name",
                      ),

                      AppInputField(
                        controller: _fatherPhoneController,
                        label: "Father Phone Number",
                        type: AppInputType.phone,
                        hint: "eg: 01xxxxxxxxx",
                      ),

                      AppInputField(
                        controller: _motherNameController,
                        label: "Mother Name",
                        hint: "Enter your Mother Name",
                      ),

                      AppInputField(
                        controller: _motherPhoneController,
                        label: "Mother Phone Number",
                        type: AppInputType.phone,
                        hint: "eg: 01xxxxxxxxx",
                      ),

                      AppInputField(
                        controller: _emergencyPhoneController,
                        label: "Emergency Contact Number",
                        type: AppInputType.phone,
                        hint: "eg: 01xxxxxxxxx",
                      ),

                      const SizedBox(height: 4),

                      const Text(
                        "Social Media",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 16),

                      AppInputField(
                        controller: _facebookController,
                        label: "Facebook Profile",
                        hint: "Enter Facebook link",
                      ),

                      const SizedBox(height: 4),

                      const Text(
                        "Personal Overview",
                        style: TextStyle(
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),

                      const SizedBox(height: 16),

                      AppInputField(
                        controller: _overviewController,
                        label: "Write something about yourself",
                        type: AppInputType.multiline,
                        maxLines: 6,
                        hint: "describe why should we hire you hired",
                      ),

                      const SizedBox(height: 20),
                    ],
                  ),
                ),
              ),

              /// STICKY SAVE BUTTON
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
                    label: "Save Changes",
                    loading: _saving,
                    onPressed: _saving ? null : _save,
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
