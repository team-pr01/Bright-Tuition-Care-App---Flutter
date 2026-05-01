import 'package:btcclient/core/config/theme.dart';
import 'package:btcclient/core/widgets/button/app_button.dart';
import 'package:btcclient/features/hire_tutor/presentation/provider/post_job_provider.dart';
import 'package:btcclient/features/hire_tutor/presentation/widgets/preview_step.dart';
import 'package:btcclient/features/hire_tutor/presentation/widgets/step1_form.dart';
import 'package:btcclient/features/hire_tutor/presentation/widgets/step2_form.dart';
import 'package:btcclient/features/hire_tutor/presentation/widgets/step3_form.dart';
import 'package:btcclient/features/hire_tutor/presentation/widgets/step_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PostJobPage extends ConsumerStatefulWidget {
  final Function(int, {String? status}) changeTab;

  const PostJobPage({
    super.key,
    required this.changeTab,
  });

  @override
  ConsumerState<PostJobPage> createState() => _PostJobPageState();
}

class _PostJobPageState extends ConsumerState<PostJobPage> {
  @override
  void initState() {
    super.initState();

    WidgetsBinding.instance.addPostFrameCallback((_) {
      final notifier = ref.read(postJobProvider.notifier);
      final state = ref.read(postJobProvider);

      if (!state.isEdit) {
        notifier.resetForm();
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(postJobProvider);
    final notifier = ref.read(postJobProvider.notifier);

    return Scaffold(
      body: Column(
        children: [
          
          Padding(
            padding: const EdgeInsets.all(16),
            child: Text(
              "Hire a Tutor",
              textAlign: TextAlign.left, 
              style: Theme.of(context).textTheme.titleLarge!.copyWith(
                    color: AppColors.neutrals06,
                    fontWeight: FontWeight.w600,
                      ),
            ),
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 16),
            child: Text(
              "Find expert tutors easily for personalized learning and academic success.",
              style: Theme.of(context).textTheme.bodyMedium,
            ),
          ),  
          !state.isEdit ? StepIndicator(currentStep: state.step) : SizedBox.shrink(),
          Expanded(
            child: IndexedStack(
              index: state.step,
              children: [
                Step1Form(),
                Step2Form(),
                Step3Form(),
                PreviewStep(),
              ],
            ),
          ),

          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                if (state.step == 3) ...[
                  Expanded(
                    child: AppButton(
                      variant: AppButtonVariant.outlineGray,
                      onPressed: () {
                        notifier.goToStep(0);
                      },
                      label: "Edit",
                    ),
                  ),
                  const SizedBox(width: 10),
                ] else if (state.step > 0) ...[
                  Expanded(
                    child: AppButton(
                      variant: AppButtonVariant.outlineGray,
                      onPressed: notifier.back,
                      label: "Previous",
                    ),
                  ),
                  const SizedBox(width: 10),
                ],

                Expanded(
                  child: AppButton(
                    variant: AppButtonVariant.gradient,
                    loading: state.isLoading,
                    onPressed: state.isLoading
                        ? null
                        : () {
                            if (state.step == 3) {
                              notifier.submit(context, widget.changeTab);
                            } else {
                              notifier.next();
                            }
                          },
                    label: state.step == 3
                        ? (state.isEdit ? "Update Job" : "Submit")
                        : "Next",
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}