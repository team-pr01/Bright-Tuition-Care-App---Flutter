import 'package:flutter/material.dart';
import 'package:btcclient/core/widgets/button/app_button.dart';

class AppSaveBottomBar extends StatelessWidget {
  final VoidCallback? onSave;
  final VoidCallback? onCancel;
  final bool loading;
  final String saveText;
  final String cancelText;
  final bool showCancel;

  const AppSaveBottomBar({
    super.key,
    required this.onSave,
    this.onCancel,
    this.loading = false,
    this.saveText = "Save Changes",
    this.cancelText = "Cancel",
    this.showCancel = true,
  });

  @override
  Widget build(BuildContext context) {
    return SafeArea(
      top: false,
      child: Container(
        padding: const EdgeInsets.fromLTRB(16, 12, 16, 16),
        decoration: BoxDecoration(
          color: Colors.white,
          border: Border(
            top: BorderSide(
              color: Colors.grey.shade200,
            ),
          ),
          boxShadow: [
            BoxShadow(
              color: Colors.black.withOpacity(.05),
              blurRadius: 10,
              offset: const Offset(0, -2),
            ),
          ],
        ),
        child: Row(
          children: [
            if (showCancel) ...[
              Expanded(
                child: AppButton(
                  label: cancelText,
                  variant: AppButtonVariant.outline,
                  onPressed:
                      onCancel ?? () => Navigator.of(context).pop(),
                ),
              ),
              const SizedBox(width: 12),
            ],
            Expanded(
              flex: 2,
              child: AppButton(
                label: saveText,
                variant: AppButtonVariant.gradient,
                loading: loading,
                onPressed: loading ? null : onSave,
              ),
            ),
          ],
        ),
      ),
    );
  }
}