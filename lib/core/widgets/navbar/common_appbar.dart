import 'dart:ui';

import 'package:btcclient/core/config/theme.dart';
import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CommonAppBar extends StatefulWidget
    implements PreferredSizeWidget {
  final String title;

  const CommonAppBar({
    super.key,
    required this.title,
  });

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  State<CommonAppBar> createState() =>
      _CommonAppBarState();
}

class _CommonAppBarState extends State<CommonAppBar> {
  int notificationCount = 0;

  @override
  void initState() {
    super.initState();
    fetchNotifications();
  }

  Future<void> fetchNotifications() async {
    await Future.delayed(const Duration(seconds: 1));

    if (mounted) {
      setState(() {
        notificationCount = 3;
      });
    }
  }

  @override
  Widget build(BuildContext context) {
    return ClipRect(
      child: BackdropFilter(
        filter: ImageFilter.blur(
          sigmaX: 15,
          sigmaY: 15,
        ),
        child: Container(
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.75),
            border: Border(
              bottom: BorderSide(
                color: Colors.grey.shade200,
              ),
            ),
            boxShadow: const [
              BoxShadow(
                color: Color.fromRGBO(0, 0, 0, 0.08),
                blurRadius: 10,
                offset: Offset(0, 2),
              ),
            ],
          ),
          child: SafeArea(
            bottom: false,
            child: SizedBox(
              height: 56,
              child: Stack(
                alignment: Alignment.center,
                children: [
                  /// Back Button
                  Align(
                    alignment: Alignment.centerLeft,
                    child: Padding(
                      padding:
                          const EdgeInsets.only(left: 12),
                      child: IconButton(
                        onPressed: () {
                          Navigator.pop(context);
                        },
                        icon: Container(
                          padding:
                              const EdgeInsets.all(6),
                          decoration: BoxDecoration(
                            borderRadius:
                                BorderRadius.circular(30),
                            border: Border.all(
                              color: Colors.grey.shade300,
                            ),
                          ),
                          child: const Icon(
                            Icons.arrow_back,
                            color: AppColors.primary01,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ),

                  /// Title
                  Text(
                    widget.title,
                    style: AppTextStyles.titleMedium.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  /// Notification
                  Align(
                    alignment: Alignment.centerRight,
                    child: Padding(
                      padding:
                          const EdgeInsets.only(right: 12),
                      child: Stack(
                        children: [
                          IconButton(
                            onPressed: () {},
                            icon: Container(
                              padding:
                                  const EdgeInsets.all(6),
                              decoration: BoxDecoration(
                                borderRadius:
                                    BorderRadius.circular(30),
                                border: Border.all(
                                  color:
                                      Colors.grey.shade300,
                                ),
                              ),
                              child: SvgPicture.asset(
                                "assets/icons/operations/notification.svg",
                                width: 20,
                                height: 20,
                              ),
                            ),
                          ),
                          if (notificationCount > 0)
                            Positioned(
                              right: 5,
                              top: 5,
                              child: Container(
                                width: 16,
                                height: 16,
                                alignment: Alignment.center,
                                decoration:
                                    const BoxDecoration(
                                  color: Colors.red,
                                  shape: BoxShape.circle,
                                ),
                                child: Text(
                                  "$notificationCount",
                                  style:
                                      const TextStyle(
                                    color: Colors.white,
                                    fontSize: 9,
                                    fontWeight:
                                        FontWeight.bold,
                                  ),
                                ),
                              ),
                            ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}