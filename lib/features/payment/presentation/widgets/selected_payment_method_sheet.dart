import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../../../../core/config/theme.dart';
import '../../../../core/widgets/button/app_button.dart';
import '../../../../core/widgets/reusable_bottom_sheet/reusable_bottom_sheet.dart';

import 'submit_proof_form.dart';

class SelectedPaymentMethodSheet
    extends StatefulWidget {

  final String selectedPaymentMethod;

  final double amount;

  final String invoiceId;

  final String paidFor;

  const SelectedPaymentMethodSheet({
    super.key,
    required this.selectedPaymentMethod,
    required this.amount,
    required this.invoiceId,
    required this.paidFor,
  });

  @override
  State<SelectedPaymentMethodSheet>
      createState() =>
          _SelectedPaymentMethodSheetState();
}

class _SelectedPaymentMethodSheetState
    extends State<
        SelectedPaymentMethodSheet> {

  bool isAccordionOpen = false;

  String get paymentIcon {

    switch (
        widget.selectedPaymentMethod) {

      case "bankTransfer":
        return
            "assets/icons/visual/payment_methods/bank.svg";

      case "nagad":
        return
            "assets/icons/visual/payment_methods/nagad.svg";

      case "rocket":
        return
            "assets/icons/visual/payment_methods/rocket.svg";

      default:
        return
            "assets/icons/visual/payment_methods/bkash.svg";
    }
  }

  @override
  Widget build(BuildContext context) {

    final isBank =
        widget.selectedPaymentMethod ==
            "bankTransfer";

    final isNagad =
        widget.selectedPaymentMethod ==
            "nagad";

    final isRocket =
        widget.selectedPaymentMethod ==
            "rocket";

    return ReusableBottomSheet(
      child: Padding(
        padding: const EdgeInsets.all(
          AppSpacing.md,
        ),

        child: SingleChildScrollView(
          child: Column(
            crossAxisAlignment:
                CrossAxisAlignment.start,

            children: [

              /// ================= TITLE =================
              Center(
                child: Column(
                  children: [

                    Text(
                      isBank
                          ? "Bank Transfer"
                          : isNagad
                              ? "Nagad (Send Money)"
                              : isRocket
                                  ? "Rocket (Send Money)"
                                  : "bKash (Payment)",

                      textAlign:
                          TextAlign.center,

                      style: AppTextStyles
                          .headlineLarge
                          .copyWith(
                        fontWeight:
                            FontWeight.w700,
                      ),
                    ),

                    const SizedBox(
                      height:
                          AppSpacing.sm,
                    ),

                    Text(
                      "Please complete the payment manually and provide payment proof below",

                      textAlign:
                          TextAlign.center,

                      style: AppTextStyles
                          .bodyMedium
                          .copyWith(
                        color: AppColors
                            .neutrals03,
                      ),
                    ),
                  ],
                ),
              ),

              const SizedBox(
                height: AppSpacing.lg,
              ),

              /// ================= PAYMENT CARD =================
              Container(
                width: double.infinity,

                padding:
                    const EdgeInsets.all(
                  AppSpacing.md,
                ),

                decoration: BoxDecoration(
                  color:
                      AppColors.neutrals01,

                  borderRadius:
                      BorderRadius.circular(
                    AppRadius.large,
                  ),

                  border: Border.all(
                    color: AppColors
                        .primary01
                        .withOpacity(0.12),
                  ),
                ),

                child: Column(
                  children: [

                    /// ================= TOP SECTION =================
                    Row(
                      crossAxisAlignment:
                          CrossAxisAlignment
                              .start,

                      children: [

                        /// ================= ICON =================
                        Container(
                          height: 60,
                          width: 60,

                          padding:
                              const EdgeInsets.all(
                            14,
                          ),

                          decoration:
                              BoxDecoration(
                            shape:
                                BoxShape.circle,

                            color: AppColors
                                .primary02,
                          ),

                          child:
                              SvgPicture.asset(
                            paymentIcon,
                          ),
                        ),

                        const SizedBox(
                          width:
                              AppSpacing.md,
                        ),

                        /// ================= DETAILS =================
                        Expanded(
                          child: Column(
                            crossAxisAlignment:
                                CrossAxisAlignment
                                    .start,

                            children: [

                              Text(
                                isBank
                                    ? "DBBL Bank Account"
                                    : isNagad
                                        ? "Nagad Personal"
                                        : isRocket
                                            ? "Rocket Personal"
                                            : "bKash Payment",

                                style:
                                    AppTextStyles
                                        .headlineSmall
                                        .copyWith(
                                  fontWeight:
                                      FontWeight
                                          .w600,
                                ),
                              ),

                              const SizedBox(
                                height:
                                    AppSpacing
                                        .xs,
                              ),

                              Text(
                                isBank
                                    ? "Shorif Mia"
                                    : isNagad
                                        ? "01610785588"
                                        : isRocket
                                            ? "019886038203"
                                            : "01616012365",

                                style:
                                    AppTextStyles
                                        .headlineMedium
                                        .copyWith(
                                  fontWeight:
                                      FontWeight
                                          .w700,
                                ),
                              ),

                              const SizedBox(
                                height:
                                    AppSpacing
                                        .xs,
                              ),

                              Text(
                                isBank
                                    ? "1481050208725"
                                    : "Bright Tuition Care",

                                style:
                                    AppTextStyles
                                        .bodyMedium
                                        .copyWith(
                                  color: AppColors
                                      .neutrals03,
                                ),
                              ),
                            ],
                          ),
                        ),
                      ],
                    ),

                    /// ================= QR =================
                    if (!isBank &&
                        !isNagad) ...[

                      const SizedBox(
                        height:
                            AppSpacing.lg,
                      ),

                      Container(
                        height: 190,
                        width: 190,

                        padding:
                            const EdgeInsets
                                .all(10),

                        decoration:
                            BoxDecoration(
                          color: Colors.white,

                          borderRadius:
                              BorderRadius.circular(
                            AppRadius.large,
                          ),

                          border:
                              Border.all(
                            color: AppColors
                                .primary01
                                .withOpacity(
                              0.12,
                            ),
                          ),
                        ),

                        child: ClipRRect(
                          borderRadius:
                              BorderRadius.circular(
                            AppRadius.medium,
                          ),

                          child:
                              Image.asset(

                            widget.selectedPaymentMethod ==
                                    "bKash"

                                ? "assets/images/qr/bkash-qr-code.webp"

                                : "assets/images/qr/rocket-qr-code.webp",

                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              const SizedBox(
                height: AppSpacing.lg,
              ),

              /// ================= ACCORDION =================
              Container(
                width: double.infinity,

                padding:
                    const EdgeInsets.all(
                  AppSpacing.md,
                ),

                decoration: BoxDecoration(
                  color:
                      AppColors.neutrals01,

                  borderRadius:
                      BorderRadius.circular(
                    AppRadius.large,
                  ),

                  border: Border.all(
                    color: AppColors
                        .primary01
                        .withOpacity(0.12),
                  ),
                ),

                child: Column(
                  children: [

                    GestureDetector(
                      onTap: () {

                        setState(() {
                          isAccordionOpen =
                              !isAccordionOpen;
                        });
                      },

                      child: Row(
                        children: [

                          Expanded(
                            child: Text(
                              "Submit Payment Proof",

                              style:
                                  AppTextStyles
                                      .headlineSmall
                                      .copyWith(
                                fontWeight:
                                    FontWeight
                                        .w600,
                              ),
                            ),
                          ),

                          AnimatedRotation(
                            turns:
                                isAccordionOpen
                                    ? 0.5
                                    : 0,

                            duration:
                                const Duration(
                              milliseconds:
                                  300,
                            ),

                            child: Icon(
                              Icons
                                  .keyboard_arrow_down,

                              color: AppColors
                                  .primary01,
                            ),
                          ),
                        ],
                      ),
                    ),

                    if (isAccordionOpen) ...[

                      const SizedBox(
                        height:
                            AppSpacing.lg,
                      ),

                      SubmitProofForm(
                        amount:
                            widget.amount,

                        selectedPaymentMethod:
                            widget
                                .selectedPaymentMethod,

                        invoiceId:
                            widget.invoiceId,

                        paidFor:
                            widget.paidFor,
                      ),
                    ],
                  ],
                ),
              ),

              const SizedBox(
                height: AppSpacing.lg,
              ),

              /// ================= CLOSE =================
              SizedBox(
                width: double.infinity,

                child: AppButton(
                  label: "Close",

                  onPressed: () {
                    Navigator.pop(
                      context,
                    );
                  },

                  variant:
                      AppButtonVariant
                          .outlineGray,

                  height: 48,
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}