import 'package:flutter/material.dart';
import '../../../models/notice_model.dart';
import 'notice_board_card.dart';

class NoticeSection extends StatelessWidget {
  final List<NoticeModel> notices;

  const NoticeSection({
    super.key,
    required this.notices,
  });

  @override
  Widget build(BuildContext context) {
    return NoticeBoardCard(notices: notices);
  }
}