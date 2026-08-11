import 'dart:io';

import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:btcclient/core/config/theme.dart';
import 'package:btcclient/core/utils/file_picker_utils.dart';
import 'package:btcclient/core/widgets/button/app_button.dart';
import 'package:btcclient/core/widgets/input/app_input_field.dart';
import 'package:btcclient/core/widgets/navbar/common_appbar.dart';
import 'package:btcclient/features/auth/presentation/provider/profile_notifier.dart';

class AddCredentialScreen extends ConsumerStatefulWidget {
  const AddCredentialScreen({
    super.key,
  });

  @override
  ConsumerState<AddCredentialScreen> createState() =>
      _AddCredentialScreenState();
}

class _AddCredentialScreenState
    extends ConsumerState<AddCredentialScreen> {
  String? _selectedFileType;

  File? _selectedFile;

  String? _selectedFileName;

  String? _error;

  bool _isSubmitting = false;

  static const List<String> _credentialTypes = [
    "SSC / Dakhil / O Level - Mark Sheet / Certificate",
    "HSC / Alim / A Level - Mark Sheet / Certificate",
    "NID / Passport / Birth Certificate",
    "Admission Pay Slip / University ID Card / Certificate",
    "Others",
  ];

  // ============================================================
  // PICK FILE
  // ============================================================

  Future<void> _pickFile() async {
    setState(() {
      _error = null;
    });

    final file = await FilePickerUtils.pickSingleFile(
      allowedExtensions: [
        "png",
        "jpg",
        "jpeg",
      ],
    );

    if (file == null) {
      return;
    }

    final extension =
        file.path.split('.').last.toLowerCase();

    if (!["png", "jpg", "jpeg"].contains(extension)) {
      setState(() {
        _error =
            "Only PNG, JPG and JPEG files are allowed.";
      });
      return;
    }

    final fileSize = await file.length();

    const maxSize = 5 * 1024 * 1024;

    if (fileSize > maxSize) {
      setState(() {
        _error = "File size must not exceed 5 MB.";
      });
      return;
    }

    setState(() {
      _selectedFile = file;
      _selectedFileName =
          file.path.split(Platform.pathSeparator).last;
      _error = null;
    });
  }

  // ============================================================
  // REMOVE FILE
  // ============================================================

  void _removeSelectedFile() {
    setState(() {
      _selectedFile = null;
      _selectedFileName = null;
      _error = null;
    });
  }

  // ============================================================
  // SUBMIT
  // ============================================================

  Future<void> _submit() async {
    if (_selectedFileType == null ||
        _selectedFileType!.trim().isEmpty) {
      setState(() {
        _error = "Please select a credential type.";
      });
      return;
    }

    if (_selectedFile == null) {
      setState(() {
        _error = "Please upload a credential document.";
      });
      return;
    }

    setState(() {
      _isSubmitting = true;
      _error = null;
    });

    try {
      final success = await ref
          .read(profileProvider.notifier)
          .updateIdentityInfo(
            fileType: _selectedFileType!,
            file: _selectedFile!,
          );

      if (!mounted) return;

      if (!success) {
        setState(() {
          _error =
              ref.read(profileProvider.notifier).error ??
                  "Failed to add credential.";
        });

        return;
      }

      Navigator.pop(context, true);
    } catch (e) {
      if (!mounted) return;

      setState(() {
        _error = e.toString();
      });
    } finally {
      if (mounted) {
        setState(() {
          _isSubmitting = false;
        });
      }
    }
  }

  // ============================================================
  // BUILD
  // ============================================================

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.neutrals01,

      appBar: const CommonAppBar(
        title: "Add Credential",
      ),

      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(
            AppSpacing.lg,
          ),
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,
            children: [
              const Text(
                "Add Credential Information",
                style: TextStyle(
                  fontSize: 22,
                  fontWeight: FontWeight.w700,
                ),
              ),

              const SizedBox(height: 8),

              Text(
                "Upload a valid credential document to "
                "complete your profile.",
                style: TextStyle(
                  fontSize: 14,
                  height: 1.5,
                  color: AppColors.neutrals03,
                ),
              ),

              const SizedBox(height: 28),

              // ==================================================
              // CREDENTIAL TYPE
              // ==================================================

              AppInputField(
                label: "Credential Type",
                hint: "Select credential type",
                type: AppInputType.dropdown,
                required: true,
                value: _selectedFileType,
                dropdownItems: _credentialTypes,
                enabled: !_isSubmitting,
                onChanged: (value) {
                  setState(() {
                    _selectedFileType = value;
                    _error = null;
                  });
                },
              ),

              const SizedBox(height: 8),

              // ==================================================
              // DOCUMENT
              // ==================================================

              const Text(
                "Credential Document",
                style: TextStyle(
                  fontSize: 14,
                  fontWeight: FontWeight.w600,
                  color: AppColors.neutrals02,
                ),
              ),

              const SizedBox(height: 8),

              if (_selectedFile == null)
                _uploadWidget()
              else
                _selectedFileWidget(),

              // ==================================================
              // ERROR
              // ==================================================

              if (_error != null) ...[
                const SizedBox(height: 14),
                _errorWidget(),
              ],

              const SizedBox(height: 20),

              // ==================================================
              // REQUIREMENTS
              // ==================================================

              _requirementsWidget(),

              const SizedBox(height: 28),

              // ==================================================
              // BUTTONS
              // ==================================================

              Row(
                children: [
                  Expanded(
                    child: AppButton(
                      label: "Cancel",
                      variant:
                          AppButtonVariant.outlineGray,
                      height: 48,
                      onPressed: _isSubmitting
                          ? null
                          : () {
                              Navigator.pop(context);
                            },
                    ),
                  ),

                  const SizedBox(width: 12),

                  Expanded(
                    child: AppButton(
                      label: "Add Credential",
                      variant:
                          AppButtonVariant.primary,
                      height: 48,
                      loading: _isSubmitting,
                      onPressed: _isSubmitting
                          ? null
                          : _submit,
                    ),
                  ),
                ],
              ),

              const SizedBox(height: 20),
            ],
          ),
        ),
      ),
    );
  }

  // ============================================================
  // UPLOAD BOX
  // ============================================================

  Widget _uploadWidget() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(24),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color:
              AppColors.primary01.withOpacity(0.25),
        ),
      ),
      child: Column(
        children: [
          Container(
            width: 60,
            height: 60,
            decoration: BoxDecoration(
              color: AppColors.primary02,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.cloud_upload_outlined,
              size: 30,
              color: AppColors.primary01,
            ),
          ),

          const SizedBox(height: 14),

          const Text(
            "Upload Credential Document",
            style: TextStyle(
              fontSize: 16,
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: 6),

          Text(
            "Select a clear image of your document",
            textAlign: TextAlign.center,
            style: TextStyle(
              fontSize: 13,
              color: AppColors.neutrals03,
            ),
          ),

          const SizedBox(height: 16),

          AppButton(
            label: "Browse Files",
            icon: Icons.folder_open_outlined,
            variant: AppButtonVariant.outline,
            width: 170,
            height: 42,
            onPressed: _isSubmitting
                ? null
                : _pickFile,
          ),
        ],
      ),
    );
  }

  // ============================================================
  // SELECTED FILE
  // ============================================================

  Widget _selectedFileWidget() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: Colors.white,
        borderRadius: BorderRadius.circular(10),
        border: Border.all(
          color: Colors.green.shade200,
        ),
      ),
      child: Row(
        children: [
          Container(
            width: 48,
            height: 48,
            decoration: BoxDecoration(
              color: Colors.green.shade50,
              borderRadius:
                  BorderRadius.circular(8),
            ),
            child: Icon(
              Icons.image_outlined,
              color: Colors.green.shade700,
            ),
          ),

          const SizedBox(width: 12),

          Expanded(
            child: Text(
              _selectedFileName ??
                  "Selected document",
              maxLines: 2,
              overflow: TextOverflow.ellipsis,
              style: const TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w500,
              ),
            ),
          ),

          IconButton(
            onPressed: _isSubmitting
                ? null
                : _removeSelectedFile,
            icon: const Icon(
              Icons.close,
              color: AppColors.error,
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // ERROR
  // ============================================================

  Widget _errorWidget() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.red.shade50,
        borderRadius: BorderRadius.circular(8),
        border: Border.all(
          color: Colors.red.shade200,
        ),
      ),
      child: Row(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          Icon(
            Icons.error_outline,
            size: 20,
            color: AppColors.error,
          ),

          const SizedBox(width: 8),

          Expanded(
            child: Text(
              _error!,
              style: TextStyle(
                fontSize: 13,
                color: AppColors.error,
              ),
            ),
          ),
        ],
      ),
    );
  }

  // ============================================================
  // REQUIREMENTS
  // ============================================================

  Widget _requirementsWidget() {
    return Container(
      width: double.infinity,
      padding: const EdgeInsets.all(14),
      decoration: BoxDecoration(
        color: AppColors.primary02,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Column(
        crossAxisAlignment:
            CrossAxisAlignment.start,
        children: [
          const Text(
            "File Requirements",
            style: TextStyle(
              fontWeight: FontWeight.w600,
              color: AppColors.primary01,
            ),
          ),

          const SizedBox(height: 8),

          Text(
            "• PNG, JPG or JPEG only",
            style: TextStyle(
              fontSize: 13,
              color: AppColors.neutrals03,
            ),
          ),

          Text(
            "• Maximum file size: 5 MB",
            style: TextStyle(
              fontSize: 13,
              color: AppColors.neutrals03,
            ),
          ),

          Text(
            "• Document should be clear and readable",
            style: TextStyle(
              fontSize: 13,
              color: AppColors.neutrals03,
            ),
          ),
        ],
      ),
    );
  }
}