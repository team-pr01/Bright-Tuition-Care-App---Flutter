import 'package:btcclient/core/widgets/dashboard/dashboard_cards/dashboard_cards_section.dart';
import 'package:btcclient/core/widgets/dashboard/dashboard_nav_links.dart';
import 'package:btcclient/core/widgets/dashboard/notice_board/notice_section.dart';
import 'package:btcclient/core/widgets/helpline_card/helpline_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';

class TutorHomeScreen extends StatelessWidget {
  const TutorHomeScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      padding: const EdgeInsets.all(16),
      child: Column(
        children: [
          Row(
            mainAxisAlignment: MainAxisAlignment.spaceAround,
            children: [
              DashboardNavLinks(
                icon: SvgPicture.asset(
                  "assets/icons/navigations/applied.svg",
                  width: 24,
                  height: 24,
                  colorFilter: const ColorFilter.mode(
                    Colors.white,
                    BlendMode.srcIn,
                  ),
                ),
                label: "Applied",
              ),

              DashboardNavLinks(
                icon: SvgPicture.asset(
                  "assets/icons/navigations/shortlisted.svg",
                  width: 24,
                  height: 24,
                  colorFilter: const ColorFilter.mode(
                    Colors.white,
                    BlendMode.srcIn,
                  ),
                ),
                label: "Shortlisted",
              ),

              DashboardNavLinks(
                icon: SvgPicture.asset(
                  "assets/icons/navigations/appointed.svg",
                  width: 24,
                  height: 24,
                  colorFilter: const ColorFilter.mode(
                    Colors.white,
                    BlendMode.srcIn,
                  ),
                ),
                label: "Appointed",
              ),

              DashboardNavLinks(
                icon: SvgPicture.asset(
                  "assets/icons/navigations/confirmed.svg",
                  width: 24,
                  height: 24,
                  colorFilter: const ColorFilter.mode(
                    Colors.white,
                    BlendMode.srcIn,
                  ),
                ),
                label: "Confirmed",
              ),

              DashboardNavLinks(
                icon: SvgPicture.asset(
                  "assets/icons/navigations/cancelled.svg",
                  width: 24,
                  height: 24,
                  colorFilter: const ColorFilter.mode(
                    Colors.white,
                    BlendMode.srcIn,
                  ),
                ),
                label: "Cancelled",
              ),
            ],
          ),
          const SizedBox(height: 20),

          const NoticeSection(),

          const SizedBox(height: 20),

const DashboardCardsSection(),

const SizedBox(height: 20),

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
    );
  }
}
