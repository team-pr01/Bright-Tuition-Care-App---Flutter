import 'package:btcclient/core/config/theme.dart';
import 'package:btcclient/core/widgets/dashboard/action_card.dart';
import 'package:btcclient/core/widgets/helpline_card/helpline_card.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class GuardianPaymentScreen extends StatelessWidget {
  const GuardianPaymentScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.neutrals01,
      body: SafeArea(
        child: LayoutBuilder(
          builder: (context, constraints) {
            return SingleChildScrollView(
              child: ConstrainedBox(
                constraints: BoxConstraints(
                  minHeight: constraints.maxHeight,
                ),
                child: IntrinsicHeight(
                  child: Padding(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    child: Column(
                      children: [
                        const SizedBox(height: 20),

                        ActionCard(
                          icon: "assets/icons/visual/verification-charge.svg",
                          title: "Verification Charges",
                          description:
                              "A one-time fee of BDT 500 is required to complete the profile verification process, ensuring authenticity and trustworthiness on our platform.",
                          buttonText: "Click Here",
                          onPressed: () {},
                        ),

                        const SizedBox(height: 16),

                       

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