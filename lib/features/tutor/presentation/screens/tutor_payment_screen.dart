import 'package:btcclient/core/config/theme.dart';
import 'package:btcclient/core/widgets/dashboard/action_card.dart';
import 'package:btcclient/core/widgets/helpline_card/helpline_card.dart';
import 'package:btcclient/features/tutor/presentation/screens/refund_form_screen.dart';
import 'package:btcclient/features/tutor/presentation/widgets/refund_policy_sheet.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class TutorPaymentScreen extends StatelessWidget {
  const TutorPaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.neutrals01,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(minHeight: constraints.maxHeight),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        const SizedBox(height: 20),

                        ActionCard(
                          icon: "assets/icons/visual/platform-charge.svg",
                          title: "Platform Charges",
                          description:
                              "A one-time platform fee is applicable after a tutor successfully confirms a tuition job. This fee is charged separately for each tuition job processed through the platform.",
                          buttonText: "Click Here",
                          onPressed: () {},
                        ),

                        const SizedBox(height: 16),
                        ActionCard(
                          icon: "assets/icons/visual/verification-charge.svg",
                          title: "Verification Charges",
                          description:
                              "A one-time fee of BDT 500 is required to complete the profile verification process, ensuring authenticity and trustworthiness on our platform.",
                          buttonText: "Click Here",
                          onPressed: () {},
                        ),

                        const SizedBox(height: 16),

                        ActionCard(
                          icon: "assets/icons/visual/refund.svg",
                          title: "Refund",
                          description:
                              "If a tutor pays the platform charge in advance but subsequently loses the tuition job for a valid reason, the payment will be refunded in accordance with our ",
                          linkText: "Refund Policy",
                          buttonText: "Apply",
                          onLinkTap: () {
                            showModalBottomSheet(
                              context: context,
                              isScrollControlled: true,
                              backgroundColor: Colors.transparent,
                              builder: (_) => const RefundPolicySheet(),
                            );
                          },
                          onPressed: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (_) => const RefundFormScreen(),
                              ),
                            );
                          },
                        ),

                        /// pushes helpline to bottom
                        const Spacer(),
                        SizedBox(height: 16),
                        HelplineCard(
                          phone: "+880 1616-012 365",
                          timing: "10:00 Am - 10:00 Pm",
                          onTap: () {
                            launchUrl(Uri.parse("tel:+8801616012365"));
                          },
                        ),

                        const SizedBox(height: 20),
                      ],
                    ),
                  ),
                ),
              ),
            );
          },
        ),
      ),
    );
  }
}
