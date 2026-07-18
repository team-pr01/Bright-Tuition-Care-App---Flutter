import 'package:btcclient/core/config/theme.dart';
import 'package:btcclient/core/widgets/button/app_button.dart';
import 'package:btcclient/core/widgets/reusable_dialog/reusable_dialog.dart';
import 'package:flutter/material.dart';

class ApplyJobDialog extends StatefulWidget {
  final Future<void> Function() onApply;

  const ApplyJobDialog({super.key, required this.onApply});

  @override
  State<ApplyJobDialog> createState() => _ApplyJobDialogState();
}

class _ApplyJobDialogState extends State<ApplyJobDialog> {
  bool _loading = false;

  Future<void> _apply() async {
    setState(() => _loading = true);

    try {
      await widget.onApply();
    } finally {
      if (mounted) {
        setState(() => _loading = false);
      }
    }
  }

  @override
  Widget build(BuildContext context) {
    return ReusableDialog(
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            height: 70,
            width: 70,
            decoration: const BoxDecoration(
              color: AppColors.primary02,
              shape: BoxShape.circle,
            ),
            child: const Icon(
              Icons.work_outline_rounded,
              color: AppColors.primary01,
              size: 36,
            ),
          ),

          const SizedBox(height: 20),

          Text(
            "Apply for this Job?",
            style: Theme.of(context).textTheme.headlineSmall,
            textAlign: TextAlign.center,
          ),

          const SizedBox(height: 12),

          Text(
            "Once you apply, the guardian will be able to review your profile and contact you if shortlisted.",
            textAlign: TextAlign.center,
            style: Theme.of(context).textTheme.bodyMedium!.copyWith(
              color: AppColors.neutrals03,
              height: 1.5,
            ),
          ),

          const SizedBox(height: 28),

          Row(
            children: [
              Expanded(
                child: AppButton(
                  label: "Cancel",
                  variant: AppButtonVariant.outlineGray,
                  loading: false,
                  onPressed: _loading ? null : () => Navigator.pop(context),
                ),
              ),

              const SizedBox(width: 12),

              Expanded(
                child: AppButton(
                  label: "Apply",
                  variant: AppButtonVariant.gradient,
                  icon: Icons.arrow_forward,
                  loading: _loading,
                  onPressed: _loading ? null : _apply,
                ),
              ),
            ],
          ),
        ],
      ),
    );
  }
}
