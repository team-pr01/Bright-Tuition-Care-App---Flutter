import 'package:btcclient/core/widgets/button/app_button.dart';
import 'package:btcclient/features/hire_tutor/presentation/provider/post_job_provider.dart';
import 'package:btcclient/features/hire_tutor/presentation/widgets/preview_step.dart';
import 'package:btcclient/features/hire_tutor/presentation/widgets/step1_form.dart';
import 'package:btcclient/features/hire_tutor/presentation/widgets/step2_form.dart';
import 'package:btcclient/features/hire_tutor/presentation/widgets/step3_form.dart';
import 'package:btcclient/features/hire_tutor/presentation/widgets/step_indicator.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class PostJobPage extends ConsumerWidget {
  final Function(int, {String? status}) changeTab;
  const PostJobPage({super.key, required this.changeTab});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final state = ref.watch(postJobProvider);
    final notifier = ref.read(postJobProvider.notifier);

    return Scaffold(
      body: Column(
        children: [
          StepIndicator(currentStep: state.step),
          Expanded(
            child: IndexedStack(
              index: state.step,
              children: [Step1Form(), Step2Form(), Step3Form(), PreviewStep()],
            ),
          ),

          /// BUTTONS
          Padding(
            padding: const EdgeInsets.all(16),
            child: Row(
              children: [
                /// 🔥 PREVIEW MODE
                if (state.step == 3) ...[
                  Expanded(
                    child: AppButton(
                      variant: AppButtonVariant.outlineGray,
                      onPressed: () {
                        notifier.goToStep(0); // 👈 jump to step 1
                      },
                      label: "Edit",
                    ),
                  ),
                  const SizedBox(width: 10),
                ]
                /// 🔥 NORMAL STEPS
                else if (state.step > 0) ...[
                  Expanded(
                    child: AppButton(
                      variant: AppButtonVariant.outlineGray,
                      onPressed: notifier.back,
                      label: "Previous",
                    ),
                  ),
                  const SizedBox(width: 10),
                ],

                /// 🔥 NEXT / SUBMIT
                Expanded(
                  child: AppButton(
                    variant: AppButtonVariant.gradient,
                    loading: state.isLoading,

                    onPressed: state.isLoading
                        ? () {} // 🔥 disables button
                        : () {
                            if (state.step == 3) {
                              notifier.submit(context, changeTab);
                            } else {
                              notifier.next();
                            }
                          },
                    label: state.step == 3 ? "Submit" : "Next",
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
