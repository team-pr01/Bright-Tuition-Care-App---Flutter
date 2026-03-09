import 'package:flutter/material.dart';
import '../../../models/notice_model.dart';
import 'notice_board_card.dart';

class NoticeSection extends StatelessWidget {
  const NoticeSection({super.key});

  @override
  Widget build(BuildContext context) {
    final notices = [
      NoticeModel(
        title: "Notice Board",
        message:
            'Our "Tutor of the Month, September 2025" is Tasin Labib (Tutor ID: 234567) and our "Guardian of the month Our "Tutor of the Month, September 2025" is Tasin Labib (Tutor ID: 234567) and our "Guardian of the month Our "Tutor of the Month, September 2025" is Tasin Labib (Tutor ID: 234567) and our "Guardian of the monthOur "Tutor of the Month, September 2025" is Tasin Labib (Tutor ID: 234567) and our "Guardian of the monthOur "Tutor of the Month, September 2025" is Tasin Labib (Tutor ID: 234567) and our "Guardian of the monthOur "Tutor of the Month, September 2025" is Tasin Labib (Tutor ID: 234567) and our "Guardian of the monthOur "Tutor of the Month, September 2025" is Tasin Labib (Tutor ID: 234567) and our "Guardian of the monthOur "Tutor of the Month, September 2025" is Tasin Labib (Tutor ID: 234567) and our "Guardian of the month',
      ),
      NoticeModel(
        title: "Holiday Notice",
        message:
            "Bright Tuition Care will remain closed on Friday due to system maintenance.",
      ),
      NoticeModel(
        title: "New Feature",
        message: "Video tutoring is now available for all premium tutors.",
      ),
    ];

    return NoticeBoardCard(notices: notices);
  }
}
