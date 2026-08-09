import 'dart:ui';

import 'package:btcclient/core/config/theme.dart';
import 'package:btcclient/features/notifications/presentations/provider/notification_notifier.dart';
import 'package:btcclient/features/notifications/presentations/screens/notification_screen.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';

class CommonAppBar extends ConsumerWidget
    implements PreferredSizeWidget {
  final String title;

  const CommonAppBar({
    super.key,
    required this.title,
  });

  @override
  Size get preferredSize => const Size.fromHeight(56);

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final notificationState =
        ref.watch(notificationNotifierProvider);

    final unreadCount = notificationState.unreadCount;

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
                  /// BACK BUTTON
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
                              color:
                                  Colors.grey.shade300,
                            ),
                          ),
                          child: const Icon(
                            Icons.arrow_back,
                            color:
                                AppColors.primary01,
                            size: 20,
                          ),
                        ),
                      ),
                    ),
                  ),

                  /// TITLE
                  Text(
                    title,
                    style:
                        AppTextStyles.titleMedium.copyWith(
                      fontWeight: FontWeight.w600,
                    ),
                  ),

                  /// NOTIFICATION BUTTON
                  Align(
                    alignment:
                        Alignment.centerRight,
                    child: Padding(
                      padding:
                          const EdgeInsets.only(right: 12),
                      child: Stack(
                        clipBehavior: Clip.none,
                        children: [
                          IconButton(
                            onPressed: () {
                              Navigator.push(
                                context,
                                MaterialPageRoute(
                                  builder: (_) =>
                                      const NotificationScreen(),
                                ),
                              );
                            },
                            icon: Container(
                              padding:
                                  const EdgeInsets.all(6),
                              decoration:
                                  BoxDecoration(
                                borderRadius:
                                    BorderRadius.circular(
                                        30),
                                border: Border.all(
                                  color:
                                      Colors.grey.shade300,
                                ),
                              ),
                              child:
                                  SvgPicture.asset(
                                "assets/icons/operations/notification.svg",
                                width: 20,
                                height: 20,
                              ),
                            ),
                          ),

                          /// UNREAD BADGE
                          if (unreadCount > 0)
                            Positioned(
                              right: 3,
                              top: 2,
                              child: Container(
                                constraints:
                                    const BoxConstraints(
                                  minWidth: 16,
                                  minHeight: 16,
                                ),
                                padding:
                                    const EdgeInsets
                                        .symmetric(
                                  horizontal: 4,
                                  vertical: 2,
                                ),
                                alignment:
                                    Alignment.center,
                                decoration:
                                    const BoxDecoration(
                                  color: Colors.red,
                                  shape:
                                      BoxShape.circle,
                                ),
                                child: Text(
                                  unreadCount > 99
                                      ? '99+'
                                      : '$unreadCount',
                                  style:
                                      const TextStyle(
                                    color:
                                        Colors.white,
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