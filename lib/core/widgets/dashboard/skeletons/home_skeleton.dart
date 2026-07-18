import 'package:flutter/material.dart';
import 'dashboard_nav_links_row_skeleton.dart';
import 'notice_board_skeleton.dart';
import 'recognition_card_skeleton.dart';
import 'tutor_cards_section_skeleton.dart';
import 'verify_profile_card_skeleton.dart';

class HomeSkeleton extends StatelessWidget {
  const HomeSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return SingleChildScrollView(
      physics: const NeverScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
      child: const Column(
        children: [
          /// Dashboard Navigation
          DashboardNavLinksRowSkeleton(),

          SizedBox(height: 20),

          /// Notice Board
          NoticeBoardSkeleton(),

          SizedBox(height: 20),

          /// Tutor of the Month
          RecognitionCardSkeleton(),

          SizedBox(height: 20),

          /// Dashboard Cards
          TutorCardsSectionSkeleton(),

          SizedBox(height: 20),

          /// Verify Profile
          VerifyProfileCardSkeleton(),

          SizedBox(height: 20),
        ],
      ),
    );
  }
}