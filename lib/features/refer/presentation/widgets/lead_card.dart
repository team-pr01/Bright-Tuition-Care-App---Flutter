import 'package:btcclient/core/config/theme.dart';
import 'package:btcclient/core/utils/date_formatter.dart';
import 'package:btcclient/core/widgets/button/app_button.dart';
import 'package:btcclient/features/refer/data/models/lead_model.dart';
import 'package:flutter/material.dart';

class LeadCard extends StatelessWidget {
  final LeadModel lead;
  final VoidCallback? onEdit;
  final VoidCallback? onPayment;

  const LeadCard({
    super.key,
    required this.lead,
    this.onEdit,
    this.onPayment,
  });
  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(AppSpacing.md),
      decoration: BoxDecoration(
        color: AppColors.neutrals01,
        borderRadius: BorderRadius.circular(AppRadius.medium),
        border: Border.all(color: AppColors.neutrals04),
        boxShadow: const [
          BoxShadow(
            color: Color.fromRGBO(0, 0, 0, .05),
            blurRadius: 10,
            offset: Offset(0, 4),
          ),
        ],
      ),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Header
          Row(
            children: [
              Text(
                "Lead #${lead.leadId}",
                style: AppTextStyles.titleMedium.copyWith(
                  fontWeight: FontWeight.w700,
                ),
              ),

              const Spacer(),

              _statusChip(),
            ],
          ),

          const SizedBox(height: AppSpacing.md),

          /// Phone
          Row(
            children: [
              const Icon(Icons.phone_outlined, size: 18),
              const SizedBox(width: 8),

              Text(lead.guardianPhoneNumber, style: AppTextStyles.titleLarge),
            ],
          ),

          const SizedBox(height: AppSpacing.md),

          /// ================= DAYS + SALARY =================
          Row(
            children: [
              Expanded(
                child: _infoTile(Icons.school_outlined, "Class", lead.classes),
              ),
              Expanded(
                child: _infoTile(
                  Icons.calendar_today_outlined,
                  "Added On",
                  DateFormatter.formattedDate(lead.createdAt),
                ),
              ),
            ],
          ),

          _infoTile(Icons.location_on_outlined, "Address", lead.address),

          _infoTile(Icons.description_outlined, "Details", lead.details),

          _paymentTile(),

          const SizedBox(height: AppSpacing.lg),
          AppButton(
            label: "Edit Lead",
            onPressed: onEdit,
            variant: AppButtonVariant.outline,
            textColor: AppColors.primary01,
            height: 40,
            icon: (Icons.edit_outlined),
          ),
        ],
      ),
    );
  }

  @override
  Widget _infoTile(
    IconData icon,
    String title,
    String value, {
    Color? valueColor,
  }) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 14),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          Icon(icon, size: 18, color: AppColors.primary01),

          const SizedBox(width: 10),

          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  title,
                  style: AppTextStyles.labelMedium.copyWith(
                    color: AppColors.neutrals06,
                  ),
                ),

                const SizedBox(height: 3),

                Text(
                  value,
                  style: AppTextStyles.bodyMedium.copyWith(
                    color: valueColor ?? AppColors.neutrals02,
                  ),
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

Widget _paymentTile() {
  final hasPayment =
      lead.paymentMethod != null &&
      lead.paymentAccountNumber != null;

  return Padding(
    padding: const EdgeInsets.only(bottom: 14),
    child: Row(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Icon(
          Icons.account_balance_wallet_outlined,
          size: 18,
          color: AppColors.primary01,
        ),

        const SizedBox(width: 10),

        Expanded(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                "Payment",
                style: AppTextStyles.labelMedium.copyWith(
                  color: AppColors.neutrals06,
                ),
              ),

              const SizedBox(height: 4),

              if (hasPayment)
                Text(
                  "${lead.paymentMethod}\n${lead.paymentAccountNumber}",
                  style: AppTextStyles.bodyMedium,
                )
              else
                InkWell(
                  onTap: onPayment,
                  child: Text(
                    "Add Payment Method",
                    style: AppTextStyles.bodyMedium.copyWith(
                      color: AppColors.primary01,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                ),
            ],
          ),
        ),
      ],
    ),
  );
}

  Widget _statusChip() {
    Color bg;
    Color text;

    switch (lead.status.toLowerCase()) {
      case "accepted":
      case "confirmed":
        bg = const Color(0xffE8F7EF);
        text = const Color(0xff1F9254);
        break;

      case "pending":
        bg = const Color(0xffFFF4E5);
        text = const Color(0xffF59E0B);
        break;

      case "rejected":
        bg = const Color(0xffFDECEC);
        text = const Color(0xffDC2626);
        break;

      default:
        bg = AppColors.primary03;
        text = AppColors.primary01;
    }

    return Container(
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Text(
        lead.status,
        style: AppTextStyles.labelSmall.copyWith(
          color: text,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}
