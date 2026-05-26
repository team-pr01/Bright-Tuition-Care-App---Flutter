import 'package:btcclient/features/payment/presentation/widgets/selected_payment_method_sheet.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/config/theme.dart';
import '../../../../core/widgets/button/app_button.dart';
import '../../../../core/widgets/reusable_bottom_sheet/reusable_bottom_sheet.dart';

class SelectPaymentMethodSheet extends StatefulWidget {
  final Function(String) onSelected;

  const SelectPaymentMethodSheet({super.key, required this.onSelected});

  @override
  State<SelectPaymentMethodSheet> createState() =>
      _SelectPaymentMethodSheetState();
}

class _SelectPaymentMethodSheetState extends State<SelectPaymentMethodSheet> {
  String selected = "";

  final List<Map<String, dynamic>> methods = [
    {
      "title": "bKash",
      "subtitle": "Transfer through mobile banking",
      "icon": "assets/icons/visual/payment_methods/bkash.svg",
      "value": "bKash",
    },

    {
      "title": "Nagad",
      "subtitle": "Transfer through mobile banking",
      "icon": "assets/icons/visual/payment_methods/nagad.svg",
      "value": "nagad",
    },

    {
      "title": "Rocket",
      "subtitle": "Transfer through mobile banking",
      "icon": "assets/icons/visual/payment_methods/rocket.svg",
      "value": "rocket",
    },

    {
      "title": "Bank Transfer",
      "subtitle": "Transfer through bank account",
      "icon": "assets/icons/visual/payment_methods/bank.svg",
      "value": "bankTransfer",
    },
  ];

  @override
  Widget build(BuildContext context) {
    return ReusableBottomSheet(
      child: Padding(
        padding: const EdgeInsets.all(16),

        child: Column(
          mainAxisSize: MainAxisSize.min,

          children: [
            const Text(
              "Please select a payment method",

              textAlign: TextAlign.center,

              style: TextStyle(fontSize: 20, fontWeight: FontWeight.bold),
            ),

            const SizedBox(height: 24),

            ...methods.map((method) {
              final isSelected = selected == method["value"];

              return GestureDetector(
                onTap: () {
                  setState(() {
                    selected = method["value"];
                  });
                },

                child: AnimatedContainer(
                  duration: const Duration(milliseconds: 250),

                  margin: const EdgeInsets.only(bottom: 14),

                  padding: const EdgeInsets.all(16),

                  decoration: BoxDecoration(
                    color: isSelected ? AppColors.primary01 : Colors.white,

                    borderRadius: BorderRadius.circular(16),

                    border: Border.all(
                      color: isSelected
                          ? AppColors.primary01
                          : Colors.grey.shade300,
                    ),
                  ),

                  child: Row(
                    children: [
                      Container(
                        height: 56,
                        width: 56,

                        // decoration: BoxDecoration(
                        //   color: isSelected
                        //       ? Colors.white.withOpacity(0.2)
                        //       : AppColors.primary01.withOpacity(0.08),

                        //   shape: BoxShape.circle,
                        // ),

                        child: SvgPicture.asset(
                          method["icon"],

                          width: 24,
                          height: 24,
                          fit: BoxFit.contain,
                        ),
                      ),

                      const SizedBox(width: 16),

                      Expanded(
                        child: Column(
                          crossAxisAlignment: CrossAxisAlignment.start,

                          children: [
                            Text(
                              method["title"],

                              style: TextStyle(
                                fontSize: 18,

                                fontWeight: FontWeight.w600,

                                color: isSelected ? Colors.white : Colors.black,
                              ),
                            ),

                            const SizedBox(height: 4),

                            Text(
                              method["subtitle"],

                              style: TextStyle(
                                fontSize: 13,

                                color: isSelected
                                    ? Colors.white70
                                    : Colors.grey,
                              ),
                            ),
                          ],
                        ),
                      ),

                      if (isSelected)
                        const Icon(Icons.check_circle, color: Colors.white),
                    ],
                  ),
                ),
              );
            }),

            const SizedBox(height: 10),

            SizedBox(
              width: double.infinity,

              child: AppButton(
                label: "Next",

                onPressed: selected.isEmpty
                    ? null
                    : () {
                        widget.onSelected(selected);
                      },

                variant: AppButtonVariant.gradient,

                height: 48,
              ),
            ),
            const SizedBox(height: 10),
          ],
        ),
      ),
    );
  }
}
