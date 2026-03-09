import 'dart:async';

import 'package:btcclient/core/config/theme.dart';
import 'package:btcclient/core/models/notice_model.dart';
import 'package:flutter/material.dart';
import 'notice_bottom_sheet.dart';

class NoticeBoardCard extends StatefulWidget {
  final List<NoticeModel> notices;

  const NoticeBoardCard({super.key, required this.notices});

  @override
  State<NoticeBoardCard> createState() => _NoticeBoardCardState();
}

class _NoticeBoardCardState extends State<NoticeBoardCard> {
  final PageController _controller = PageController();
  int currentIndex = 0;
  Timer? autoScrollTimer;
  bool isTextOverflow(String text, TextStyle style, double maxWidth) {
    final textPainter = TextPainter(
      text: TextSpan(text: text, style: style),
      maxLines: 2,
      textDirection: TextDirection.ltr,
    );

    textPainter.layout(maxWidth: maxWidth);

    return textPainter.didExceedMaxLines;
  }

  void openBottomSheet() {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (_) => NoticeBottomSheet(
        notices: widget.notices,
        initialIndex: currentIndex,
      ),
    );
  }

  @override
  void initState() {
    super.initState();

    autoScrollTimer = Timer.periodic(const Duration(seconds: 4), (timer) {
      if (_controller.hasClients) {
        int nextPage = currentIndex + 1;

        if (nextPage >= widget.notices.length) {
          nextPage = 0;
        }

        _controller.animateToPage(
          nextPage,
          duration: const Duration(milliseconds: 400),
          curve: Curves.easeInOut,
        );
      }
    });
  }

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: openBottomSheet,
      child: Container(
        padding: const EdgeInsets.all(16),
        decoration: BoxDecoration(
          borderRadius: BorderRadius.circular(10),
          border: Border.all(color: AppColors.primary01, width: 1.5),
        ),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// ICON + TITLE (STATIC)
            Row(
              children: [
                Icon(Icons.campaign, color: AppColors.primary01),
                const SizedBox(width: 8),
                Text(
                  "Notice Board",
                  style: Theme.of(context).textTheme.titleLarge!.copyWith(
                        color: AppColors.neutrals02,
                        fontWeight: FontWeight.w400,
                      ),
                ),
              ],
            ),
      
            const SizedBox(height: 10),
      
            /// MESSAGE SWIPE AREA
            SizedBox(
              height: 96,
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
      
                  final textStyle = Theme.of(context).textTheme.bodyMedium!.copyWith(color: AppColors.neutrals03);
      
                  final overflow = isTextOverflow(
                    notice.message,
                    textStyle,
                    MediaQuery.of(context).size.width - 80,
                  );
      
                  return Column(
                    crossAxisAlignment: CrossAxisAlignment.start,
                    children: [
                       Text(
                        notice.title,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: Theme.of(context).textTheme.titleLarge!.copyWith( color: AppColors.neutrals02,),
                      ),
                         const SizedBox(height: 6),
                      Text(
                        notice.message,
                        maxLines: 2,
                        overflow: TextOverflow.ellipsis,
                        style: textStyle.copyWith(height: 1.4),
                      ),
      
                      if (overflow)
                        GestureDetector(
                          onTap: openBottomSheet,
                          child: Text(
                            "Read More",
                            style: TextStyle(
                              color: AppColors.primary01,
                              fontWeight: FontWeight.w500,
                            ),
                          ),
                        ),
                    ],
                  );
                },
              ),
            ),
      
            const SizedBox(height: 4),
      
            /// DOT INDICATOR
            Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: List.generate(
                widget.notices.length,
                (index) => AnimatedContainer(
                  duration: const Duration(milliseconds: 300),
                  margin: const EdgeInsets.symmetric(horizontal: 3),
                  height: 6,
                  width: currentIndex == index ? 20 : 6,
                  decoration: BoxDecoration(
                    color: currentIndex == index
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
    );
  }
}
