import 'package:btcclient/core/config/theme.dart';
import 'package:btcclient/features/refer/data/models/lead_model.dart';
import 'package:flutter/material.dart';

class LeadCard extends StatelessWidget {
  final Lead lead;
  final bool isOpen;
  final VoidCallback onTap;

  const LeadCard({
    required this.lead,
    required this.isOpen,
    required this.onTap,
  });

  @override
  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(
        horizontal: AppSpacing.md,
        vertical: AppSpacing.sm,
      ),
      decoration: BoxDecoration(
        color: AppColors.neutrals01,
        borderRadius: BorderRadius.circular(AppRadius.medium),
        border: Border.all(color: AppColors.neutrals04),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, 0.04),
            blurRadius: 8,
            offset: Offset(0, 2),
          ),
        ],
      ),
      child: Column(
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(AppRadius.medium),
            onTap: onTap,
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Row(
                children: [
                  Container(
                    width: 44,
                    height: 44,
                    decoration: BoxDecoration(
                      color: AppColors.primary03,
                      borderRadius: BorderRadius.circular(AppRadius.small),
                    ),
                    child: const Icon(
                      Icons.person_outline,
                      color: AppColors.primary01,
                    ),
                  ),

                  const SizedBox(width: AppSpacing.md),

                  Expanded(
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          lead.phone,
                          style: AppTextStyles.titleLarge.copyWith(
                            color: AppColors.neutrals02,
                          ),
                        ),

                        const SizedBox(height: 4),

                        Text(
                          "Class ${lead.className}",
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.neutrals03,
                          ),
                        ),
                      ],
                    ),
                  ),

                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 10,
                      vertical: 4,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary03,
                      borderRadius: BorderRadius.circular(
                        AppRadius.full.toDouble(),
                      ),
                    ),
                    child: Text(
                      lead.status,
                      style: AppTextStyles.labelSmall.copyWith(
                        color: AppColors.primary01,
                      ),
                    ),
                  ),

                  const SizedBox(width: 8),

                  Icon(
                    isOpen
                        ? Icons.keyboard_arrow_up
                        : Icons.keyboard_arrow_down,
                    color: AppColors.neutrals03,
                  ),
                ],
              ),
            ),
          ),

          if (isOpen)
            Container(
              width: double.infinity,
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.md,
                0,
                AppSpacing.md,
                AppSpacing.md,
              ),
              child: Column(
                children: [
                  const Divider(color: AppColors.neutrals04),

                  _row("Address", lead.address),
                  _row("Details", lead.details),
                  _row("Date", lead.date),

                  const SizedBox(height: AppSpacing.md),

                  Row(
                    mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                    children: [
                      _actionButton(
                        icon: Icons.edit_outlined,
                        color: AppColors.primary01,
                        onTap: () {},
                      ),
                      _actionButton(
                        icon: Icons.payment_outlined,
                        color: AppColors.success,
                        onTap: () {},
                      ),
                      _actionButton(
                        icon: Icons.delete_outline,
                        color: AppColors.error,
                        onTap: () {},
                      ),
                    ],
                  ),
                ],
              ),
            ),
        ],
      ),
    );
  }

  Widget _actionButton({
    required IconData icon,
    required Color color,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      borderRadius: BorderRadius.circular(AppRadius.small),
      child: Container(
        padding: const EdgeInsets.all(10),
        decoration: BoxDecoration(
          color: color.withOpacity(0.08),
          borderRadius: BorderRadius.circular(AppRadius.small),
        ),
        child: Icon(icon, color: color, size: 22),
      ),
    );
  }

  Widget _row(String label, String value) {
    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.sm),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          SizedBox(
            width: 70,
            child: Text(
              label,
              style: AppTextStyles.labelMedium.copyWith(
                color: AppColors.neutrals06,
                fontWeight: FontWeight.w500
              ),
            ),
          ),

          Expanded(
            child: Text(
              value,
              style: AppTextStyles.bodyMedium.copyWith(
                color: AppColors.neutrals02,
              ),
            ),
          ),
        ],
      ),
    );
  }
}
