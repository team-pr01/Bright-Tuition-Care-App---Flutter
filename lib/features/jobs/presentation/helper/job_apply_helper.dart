import 'package:btcclient/features/jobs/presentation/widgets/apply_job_dialog.dart';
import 'package:flutter/material.dart';

Future<void> showApplyConfirmation({
  required BuildContext context,
  required Future<void> Function(BuildContext dialogContext) onApply,
}) {
  return showDialog(
    context: context,
    barrierDismissible: false,
    builder: (dialogContext) {
      return ApplyJobDialog(
        onApply: () => onApply(dialogContext),
      );
    },
  );
}