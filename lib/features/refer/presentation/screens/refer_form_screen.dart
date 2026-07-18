import 'package:btcclient/core/network/api_error_handler.dart';
import 'package:btcclient/core/widgets/snackbar/app_snackbar.dart';
import 'package:btcclient/features/refer/data/request/add_lead_request.dart';
import 'package:btcclient/features/refer/presentation/provider/refer_provider.dart';
import 'package:btcclient/features/refer/presentation/screens/my_leads_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'package:btcclient/core/widgets/button/app_button.dart';
import 'package:btcclient/core/widgets/navbar/common_appbar.dart';
import 'package:btcclient/core/widgets/input/app_input_field.dart';

class AddLeadScreen extends ConsumerStatefulWidget {
  const AddLeadScreen({super.key});

  @override
  ConsumerState<AddLeadScreen> createState() => _AddLeadScreenState();
}

class _AddLeadScreenState extends ConsumerState<AddLeadScreen> {
  final _formKey = GlobalKey<FormState>();

  final guardianPhoneController = TextEditingController();
  final classController = TextEditingController();
  final addressController = TextEditingController();
  final detailsController = TextEditingController();

  @override
  Widget build(BuildContext context) {
    ref.listen(referProvider, (previous, next) {
      next.whenOrNull(
        data: (response) {
          if (!mounted || response == null) return;

          if (response.success) {
            Navigator.pushReplacement(
              context,
              MaterialPageRoute(builder: (_) => const MyLeadsScreen()),
            );
          } else {
            AppSnackbar.show(context, response.message, SnackType.error);
          }
        },
        error: (error, stack) {
          if (!mounted) return;

          AppSnackbar.show(
            context,
            ApiErrorHandler.getMessage(error),
            SnackType.error,
          );
        },
      );
    });
    final leadState = ref.watch(referProvider);
    return Scaffold(
      appBar: const CommonAppBar(),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(20),

        child: Form(
          key: _formKey,

          child: Column(
            children: [
              /// TITLE
              Text(
                "Add New Lead",
                style: Theme.of(context).textTheme.headlineMedium?.copyWith(
                  fontWeight: FontWeight.w500,
                  color: Colors.black,
                ),
              ),

              const SizedBox(height: 20),

              /// PHONE NUMBER
              AppInputField(
                label: "Class",
                controller: classController,
                required: true,
                hint: "Enter Class",
              ),
              AppInputField(
                label: "Guardian Phone Number",
                controller: guardianPhoneController,
                keyboardType: TextInputType.phone,
                required: true,
                hint: "Enter Guardian Phone Number",
              ),

              /// ADDRESS
              AppInputField(
                label: "Address",
                controller: addressController,
                required: true,
                hint: "Enter Address",
              ),

              /// DETAILS (MULTILINE ✅)
              AppInputField(
                label: "Details",
                controller: detailsController,
                type: AppInputType.multiline,
                maxLines: 4,
                required: false,
                hint:
                    "Enter details of lead including salary expectations , subjects ,etc.",
              ),

              const SizedBox(height: 20),

              /// SUBMIT BUTTON
              AppButton(
                label: "Submit Lead",
                variant: AppButtonVariant.gradient,
                loading: leadState.isLoading,
                onPressed: leadState.isLoading ? null : submitLead,
              ),
            ],
          ),
        ),
      ),
    );
  }

  Future<void> submitLead() async {
    if (!_formKey.currentState!.validate()) return;

    final request = AddLeadRequest(
      classes: classController.text.trim(),
      guardianPhoneNumber: guardianPhoneController.text.trim(),
      address: addressController.text.trim(),
      details: detailsController.text.trim(),
    );

    await ref.read(referProvider.notifier).addLead(request);
  }
}
