import 'dart:convert';

import 'package:flutter/material.dart';
import 'package:http/http.dart' as http;

import 'package:btcclient/core/config/theme.dart';
import 'package:btcclient/core/layout/auth_layout.dart';
import 'package:btcclient/core/widgets/button/app_button.dart';
import 'package:btcclient/core/widgets/input/app_input_field.dart';
import 'package:btcclient/core/widgets/snackbar/app_snackbar.dart';

class RequestTutorScreen extends StatefulWidget {
  const RequestTutorScreen({super.key});

  @override
  State<RequestTutorScreen> createState() => _RequestTutorScreenState();
}

class _RequestTutorScreenState extends State<RequestTutorScreen> {
  final _formKey = GlobalKey<FormState>();

  final TextEditingController guardianPhoneController =
      TextEditingController();

  final TextEditingController classController =
      TextEditingController();

  bool _isLoading = false;

  static const String _apiUrl =
      'https://bright-tuition-care-server.onrender.com/api/v1/lead/request-tutor';

  @override
  void dispose() {
    guardianPhoneController.dispose();
    classController.dispose();
    super.dispose();
  }

  // ============================================================
  // REQUEST TUTOR
  // ============================================================

  Future<void> _submitRequest() async {
    FocusScope.of(context).unfocus();

    if (!_formKey.currentState!.validate()) {
      return;
    }

    if (_isLoading) {
      return;
    }

    setState(() {
      _isLoading = true;
    });

    try {
      final payload = {
        "guardianPhoneNumber": guardianPhoneController.text.trim(),
        "class": classController.text.trim(),
        "userId": null,
        "tutorId": null,
      };

      debugPrint("📤 REQUEST TUTOR PAYLOAD");
      debugPrint(jsonEncode(payload));

      final response = await http.post(
        Uri.parse(_apiUrl),
        headers: const {
          "Content-Type": "application/json",
          "Accept": "application/json",
        },
        body: jsonEncode(payload),
      );

      debugPrint(
        "📥 REQUEST TUTOR STATUS: ${response.statusCode}",
      );

      debugPrint(
        "📥 REQUEST TUTOR RESPONSE: ${response.body}",
      );

      Map<String, dynamic>? data;

      try {
        final decoded = jsonDecode(response.body);

        if (decoded is Map<String, dynamic>) {
          data = decoded;
        }
      } catch (e) {
        debugPrint("❌ Response is not valid JSON");
      }

      // ========================================================
      // SUCCESS
      // ========================================================

      if (response.statusCode >= 200 &&
          response.statusCode < 300 &&
          data?["success"] == true) {
        if (!mounted) return;

        AppSnackbar.show(
          context,
          data?["message"]?.toString() ??
              "Tutor request submitted successfully.",
          SnackType.success,
        );

        guardianPhoneController.clear();
        classController.clear();

        // Go back after successful request.
        Future.delayed(const Duration(milliseconds: 500), () {
          if (mounted) {
            Navigator.pop(context);
          }
        });

        return;
      }

      // ========================================================
      // API ERROR
      // ========================================================

      String message = "Unable to submit tutor request.";

      if (data?["message"] != null) {
        message = data!["message"].toString();
      }

      if (!mounted) return;

      AppSnackbar.show(
        context,
        message,
        SnackType.error,
      );
    } catch (e, stackTrace) {
      debugPrint("❌ REQUEST TUTOR ERROR: $e");
      debugPrintStack(stackTrace: stackTrace);

      if (!mounted) return;

      AppSnackbar.show(
        context,
        "Something went wrong. Please try again.",
        SnackType.error,
      );
    } finally {
      if (mounted) {
        setState(() {
          _isLoading = false;
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
      body: AuthLayout(
        title: "Request a Tutor",
        subtitle:
            "Tell us what you need and we will help you find the right tutor.",
        child: Form(
          key: _formKey,
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.stretch,
            children: [
              // ==================================================
              // GUARDIAN PHONE
              // ==================================================

              AppInputField(
                label: "Guardian Phone Number",
                hint: "Enter guardian phone number",
                controller: guardianPhoneController,
                type: AppInputType.phone,
                required: true,
                validator: (value) {
                  final phone = value?.trim() ?? "";

                  if (phone.isEmpty) {
                    return "Guardian phone number is required";
                  }

                  if (phone.length < 10) {
                    return "Enter a valid phone number";
                  }

                  return null;
                },
              ),

              // ==================================================
              // CLASS
              // ==================================================

              AppInputField(
                label: "Class",
                hint: "Enter class",
                controller: classController,
                required: true,
                validator: (value) {
                  final className = value?.trim() ?? "";

                  if (className.isEmpty) {
                    return "Class is required";
                  }

                  return null;
                },
              ),

              const SizedBox(height: 24),

              // ==================================================
              // SUBMIT
              // ==================================================

              AppButton(
                label: "Request Tutor",
                variant: AppButtonVariant.gradient,
                loading: _isLoading,
                onPressed: _isLoading ? null : _submitRequest,
              ),

              const SizedBox(height: 12),

              // ==================================================
              // CANCEL
              // ==================================================

              AppButton(
                label: "Cancel",
                variant: AppButtonVariant.outlineGray,
                fontSize: 16,
                textColor: AppColors.primary01,
                onPressed: _isLoading
                    ? null
                    : () {
                        Navigator.pop(context);
                      },
              ),
            ],
          ),
        ),
      ),
    );
  }
}