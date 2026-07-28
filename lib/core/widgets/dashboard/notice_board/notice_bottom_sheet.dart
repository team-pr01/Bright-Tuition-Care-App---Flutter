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
  int currentIndex = 0;
  @override
  void initState() {
    super.initState();
    currentIndex = widget.initialIndex; // 🔥 important
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
    height: 450,
    child: Column(
      children: [
        Expanded(
          child: PageView.builder(
            controller: _controller,
            itemCount: widget.notices.length,
            onPageChanged: (index) {
              setState(() {
                currentIndex = index;
              });
            },
            itemBuilder: (context, index) {
              final notice = widget.notices[index];

              return SingleChildScrollView(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    /// HEADER
                    Row(
                      children: [
                        Icon(Icons.campaign, color: AppColors.primary01),
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

        const SizedBox(height: 16),

        /// PAGE INDICATOR (Always stays at bottom)
        Row(
          mainAxisAlignment: MainAxisAlignment.center,
          children: List.generate(
            widget.notices.length,
            (i) => AnimatedContainer(
              duration: const Duration(milliseconds: 300),
              margin: const EdgeInsets.symmetric(horizontal: 3),
              height: 6,
              width: currentIndex == i ? 20 : 6,
              decoration: BoxDecoration(
                color: currentIndex == i
                    ? AppColors.primary01
                    : Colors.grey.shade300,
                borderRadius: BorderRadius.circular(10),
              ),
            ),
          ),
        ),
      ],
    ),
  ),
); }
}
