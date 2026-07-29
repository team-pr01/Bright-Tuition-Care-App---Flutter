// LeadCard widget - updated to accept isInitiallyExpanded parameter

import 'package:btcclient/core/config/theme.dart';
import 'package:btcclient/core/utils/date_formatter.dart';
import 'package:btcclient/core/widgets/button/app_button.dart';
import 'package:btcclient/features/refer/data/models/lead_model.dart';
import 'package:flutter/material.dart';

class LeadCard extends StatefulWidget {
  final LeadModel lead;
  final VoidCallback? onEdit;
  final VoidCallback? onPayment;
  final bool isInitiallyExpanded;

  const LeadCard({
    super.key,
    required this.lead,
    this.onEdit,
    this.onPayment,
    this.isInitiallyExpanded = false,
  });

  @override
  State<LeadCard> createState() => _LeadCardState();
}

class _LeadCardState extends State<LeadCard> {
  late bool _isExpanded;

  @override
  void initState() {
    super.initState();
    _isExpanded = widget.isInitiallyExpanded;
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      margin: const EdgeInsets.symmetric(vertical: 6),
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
        children: [
          /// ========== HEADER (Always Visible) ==========
          InkWell(
            onTap: () {
              setState(() {
                _isExpanded = !_isExpanded;
              });
            },
            borderRadius: BorderRadius.circular(AppRadius.medium),
            child: Padding(
              padding: const EdgeInsets.all(AppSpacing.md),
              child: Row(
                children: [
                  /// Lead ID & Status
                  Expanded(
                    child: Row(
                      children: [
                        Container(
                          padding: const EdgeInsets.symmetric(
                            horizontal: 10,
                            vertical: 4,
                          ),
                          decoration: BoxDecoration(
                            color: AppColors.primary03,
                            borderRadius: BorderRadius.circular(6),
                          ),
                          child: Text(
                            "#${widget.lead.leadId}",
                            style: AppTextStyles.labelSmall.copyWith(
                              color: AppColors.primary01,
                              fontWeight: FontWeight.w700,
                            ),
                          ),
                        ),
                        const SizedBox(width: 10),
                        _statusChip(),
                      ],
                    ),
                  ),

                  const SizedBox(width: 12),

                  /// Phone Number
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary03.withOpacity(0.3),
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Row(
                      mainAxisSize: MainAxisSize.min,
                      children: [
                        const Icon(
                          Icons.phone_outlined,
                          size: 16,
                          color: AppColors.primary01,
                        ),
                        const SizedBox(width: 6),
                        Text(
                          widget.lead.guardianPhoneNumber,
                          style: AppTextStyles.labelMedium.copyWith(
                            fontWeight: FontWeight.w600,
                            color: AppColors.primary01,
                          ),
                        ),
                      ],
                    ),
                  ),

                  const SizedBox(width: 12),

                  /// Expand/Collapse Icon
                  AnimatedRotation(
                    duration: const Duration(milliseconds: 300),
                    turns: _isExpanded ? 0.5 : 0.0,
                    child: Icon(
                      Icons.keyboard_arrow_down_rounded,
                      color: AppColors.neutrals06,
                      size: 28,
                    ),
                  ),
                ],
              ),
            ),
          ),

          /// ========== EXPANDED CONTENT ==========
          AnimatedCrossFade(
            duration: const Duration(milliseconds: 350),
            crossFadeState:
                _isExpanded
                    ? CrossFadeState.showFirst
                    : CrossFadeState.showSecond,
            firstChild: Padding(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.md,
                0,
                AppSpacing.md,
                AppSpacing.md,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  const Divider(height: 1, color: AppColors.neutrals04),

                  const SizedBox(height: AppSpacing.md),

                  /// Info Grid (2 columns)
                  Row(
                    children: [
                      Expanded(
                        child: _infoTile(
                          Icons.school_outlined,
                          "Class",
                          widget.lead.classes,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: _infoTile(
                          Icons.calendar_today_outlined,
                          "Added On",
                          DateFormatter.formattedDate(widget.lead.createdAt),
                        ),
                      ),
                    ],
                  ),

                  _infoTile(
                    Icons.location_on_outlined,
                    "Address",
                    widget.lead.address,
                  ),

                  _infoTile(
                    Icons.description_outlined,
                    "Details",
                    widget.lead.details,
                  ),

                  _paymentTile(),

                  const SizedBox(height: AppSpacing.md),

                  /// Action Buttons
                  Row(
                    children: [
                      Expanded(
                        child: AppButton(
                          label: "Edit Lead",
                          onPressed: widget.onEdit,
                          variant: AppButtonVariant.outlineGray,
                          textColor: AppColors.primary01,
                          height: 40,
                          icon: Icons.edit_outlined,
                        ),
                      ),
                      const SizedBox(width: 12),
                      Expanded(
                        child: AppButton(
                          label: "Payment",
                          onPressed: widget.onPayment,
                          variant: AppButtonVariant.primary,
                          height: 40,
                          icon: Icons.payment_outlined,
                        ),
                      ),
                    ],
                  ),
                ],
              ),
            ),
            secondChild: const SizedBox.shrink(),
          ),
        ],
      ),
    );
  }

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
        widget.lead.paymentMethod != null &&
        widget.lead.paymentAccountNumber != null;

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
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: 12,
                      vertical: 6,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primary03.withOpacity(0.15),
                      borderRadius: BorderRadius.circular(8),
                    ),
                    child: Column(
                      crossAxisAlignment: CrossAxisAlignment.start,
                      children: [
                        Text(
                          widget.lead.paymentMethod!,
                          style: AppTextStyles.bodyMedium.copyWith(
                            fontWeight: FontWeight.w600,
                          ),
                        ),
                        Text(
                          widget.lead.paymentAccountNumber!,
                          style: AppTextStyles.bodySmall.copyWith(
                            color: AppColors.neutrals06,
                          ),
                        ),
                      ],
                    ),
                  )
                else
                  InkWell(
                    onTap: widget.onPayment,
                    borderRadius: BorderRadius.circular(8),
                    child: Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 12,
                        vertical: 8,
                      ),
                      decoration: BoxDecoration(
                        color: AppColors.primary03.withOpacity(0.2),
                        borderRadius: BorderRadius.circular(8),
                        border: Border.all(
                          color: AppColors.primary01.withOpacity(0.3),
                        ),
                      ),
                      child: Row(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.add_circle_outline,
                            size: 18,
                            color: AppColors.primary01,
                          ),
                          const SizedBox(width: 6),
                          Text(
                            "Add Payment Method",
                            style: AppTextStyles.bodyMedium.copyWith(
                              color: AppColors.primary01,
                              fontWeight: FontWeight.w600,
                            ),
                          ),
                        ],
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

    switch (widget.lead.status.toLowerCase()) {
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
      padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 4),
      decoration: BoxDecoration(
        color: bg,
        borderRadius: BorderRadius.circular(30),
      ),
      child: Text(
        widget.lead.status,
        style: AppTextStyles.labelSmall.copyWith(
          color: text,
          fontWeight: FontWeight.w600,
        ),
      ),
    );
  }
}