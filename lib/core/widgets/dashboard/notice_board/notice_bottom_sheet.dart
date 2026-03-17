import 'package:btcclient/core/config/theme.dart';
import 'package:btcclient/core/models/notice_model.dart';
import 'package:btcclient/core/widgets/reusable_bottom_sheet/reusable_bottom_sheet.dart';
import 'package:flutter/material.dart';

class NoticeBottomSheet extends StatefulWidget {
  final List<NoticeModel> notices;
  final int initialIndex;

  const NoticeBottomSheet({
    super.key,
    required this.notices,
    required this.initialIndex,
  });

  @override
  State<NoticeBottomSheet> createState() => _NoticeBottomSheetState();
}

class _NoticeBottomSheetState extends State<NoticeBottomSheet> {
  late PageController _controller;

  @override
  void initState() {
    super.initState();
    _controller = PageController(initialPage: widget.initialIndex);
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
   return ReusableBottomSheet(
  child: SizedBox(
    height: 250,
    child: PageView.builder(
      controller: _controller,
      itemCount: widget.notices.length,
      itemBuilder: (context, index) {

        final notice = widget.notices[index];

        return SingleChildScrollView(
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [

              /// HEADER
              Row(
                children: [
                  Icon(
                    Icons.campaign,
                    color: AppColors.primary01,
                  ),
                  const SizedBox(width: 8),
                  Text(
                    "Notice Board",
                    style: Theme.of(context).textTheme.titleLarge,
                  ),
                ],
              ),

              const SizedBox(height: 16),

              Text(
                notice.title,
                style: Theme.of(context)
                    .textTheme
                    .titleLarge!
                    .copyWith(color: AppColors.neutrals02),
              ),

              const SizedBox(height: 6),

              Text(
                notice.message,
                style: Theme.of(context)
                    .textTheme
                    .bodyLarge!
                    .copyWith(height: 1.5),
              ),
            ],
          ),
        );
      },
    ),
  ),
); }
}