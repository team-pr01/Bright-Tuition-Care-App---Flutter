import 'package:btcclient/core/config/theme.dart';
import 'package:btcclient/core/widgets/navbar/common_appbar.dart';
import 'package:btcclient/features/notifications/data/notification_model.dart';
import 'package:btcclient/features/notifications/presentations/provider/notification_notifier.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:intl/intl.dart';

class NotificationScreen extends ConsumerStatefulWidget {
  const NotificationScreen({super.key});

  @override
  ConsumerState<NotificationScreen> createState() => _NotificationScreenState();
}

class _NotificationScreenState extends ConsumerState<NotificationScreen> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      ref.read(notificationNotifierProvider.notifier).loadNotifications();
    });
  }

  @override
  Widget build(BuildContext context) {
    final state = ref.watch(notificationNotifierProvider);

    return Scaffold(
      appBar: const CommonAppBar(title: "Notifications"),
      body: Builder(
        builder: (_) {
          if (state.isLoading) {
            return const Center(child: CircularProgressIndicator());
          }

          if (state.error != null) {
            return Center(
              child: Padding(
                padding: const EdgeInsets.all(AppSpacing.lg),
                child: Text(
                  state.error!,
                  textAlign: TextAlign.center,
                  style: const TextStyle(color: AppColors.error),
                ),
              ),
            );
          }

          if (state.isEmpty) {
            return const _EmptyNotificationView();
          }

          return RefreshIndicator(
            onRefresh: () {
              return ref.read(notificationNotifierProvider.notifier).refresh();
            },
            child: ListView.separated(
              padding: const EdgeInsets.fromLTRB(
                AppSpacing.md,
                AppSpacing.md,
                AppSpacing.md,
                AppSpacing.xl,
              ),
              itemCount: state.notifications.length,
              separatorBuilder: (_, __) =>
                  const SizedBox(height: AppSpacing.sm),
              itemBuilder: (context, index) {
                final notification = state.notifications[index];

                return _NotificationTile(
                  notification: notification,
                  onTap: () {
                    ref
                        .read(notificationNotifierProvider.notifier)
                        .onNotificationTap(notification);
                  },
                );
              },
            ),
          );
        },
      ),
    );
  }
}

// ============================================================
// EMPTY NOTIFICATION VIEW
// ============================================================

class _EmptyNotificationView extends StatelessWidget {
  const _EmptyNotificationView();

  @override
  Widget build(BuildContext context) {
    return Center(
      child: Padding(
        padding: const EdgeInsets.all(AppSpacing.lg),
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center,
          children: [
            Container(
              width: 72,
              height: 72,
              decoration: BoxDecoration(
                color: AppColors.primary03,
                shape: BoxShape.circle,
              ),
              child: const Icon(
                Icons.notifications_none_rounded,
                size: 36,
                color: AppColors.primary01,
              ),
            ),

            const SizedBox(height: AppSpacing.md),

            Text(
              "No Notifications",
              style: Theme.of(
                context,
              ).textTheme.titleLarge?.copyWith(fontWeight: FontWeight.w600),
            ),

            const SizedBox(height: AppSpacing.sm),

            Text(
              " You have no notifications at the moment. Check back later for updates and alerts.",
              textAlign: TextAlign.center,
              style: Theme.of(
                context,
              ).textTheme.bodyMedium?.copyWith(color: AppColors.neutrals03),
            ),
          ],
        ),
      ),
    );
  }
}

// ============================================================
// NOTIFICATION TILE
// ============================================================

class _NotificationTile extends StatelessWidget {
  final NotificationModel notification;
  final VoidCallback onTap;

  const _NotificationTile({required this.notification, required this.onTap});

  // ==========================================================
  // ICON
  // ==========================================================

  String get _iconPath {
    switch (notification.type) {
      case 'new_job_alert':
        return 'assets/icons/navigations/job-board.svg';
      case 'job_details':
        return 'assets/icons/navigations/job-board.svg';

      default:
        return 'assets/icons/operations/notification.svg';
    }
  }

  // ==========================================================
  // BUILD
  // ==========================================================

  @override
  Widget build(BuildContext context) {
    final bool isUnread = !notification.isRead;
    debugPrint(notification.toString());
    return Material(
      color: isUnread ? AppColors.primary03 : AppColors.neutrals01,
      borderRadius: BorderRadius.circular(AppRadius.medium),
      child: InkWell(
        onTap: onTap,
        borderRadius: BorderRadius.circular(AppRadius.medium),
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.sm),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ==================================================
              // ICON + UNREAD INDICATOR
              // ==================================================
              SizedBox(
                width: 44,
                height: 44,
                child: Stack(
                  clipBehavior: Clip.none,
                  children: [
                    Container(
                      width: 44,
                      height: 44,
                      padding: const EdgeInsets.all(11),
                      decoration: BoxDecoration(
                        color: isUnread
                            ? AppColors.primary02
                            : AppColors.neutrals04.withOpacity(0.45),
                        borderRadius: BorderRadius.circular(AppRadius.medium),
                        border: Border.all(
                          color: isUnread
                              ? AppColors.primary01
                              : AppColors.neutrals04.withOpacity(0.45),
                          width: 1.5,
                        ),
                      ),
                      child: SvgPicture.asset(
                        _iconPath,
                        width: 20,
                        height: 20,
                        colorFilter: const ColorFilter.mode(
                          AppColors.primary01,
                          BlendMode.srcIn,
                        ),
                      ),
                    ),

                    // ==================================================
                    // UNREAD YELLOW DOT
                    // ==================================================
                    if (isUnread)
                      Positioned(
                        top: -3,
                        left: -3,
                        child: Container(
                          width: 12,
                          height: 12,
                          decoration: BoxDecoration(
                            color: const Color.fromARGB(255, 244, 213, 161),
                            shape: BoxShape.circle,
                            boxShadow: [
                              BoxShadow(
                                color: const Color.fromARGB(
                                  255,
                                  241,
                                  216,
                                  174,
                                ).withOpacity(0.45),
                                blurRadius: 7,
                                spreadRadius: 2,
                              ),
                            ],
                          ),
                        ),
                      ),
                  ],
                ),
              ),

              const SizedBox(width: AppSpacing.md),

              // ==================================================
              // CONTENT
              // ==================================================
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    // ==================================================
                    // TITLE
                    // ==================================================
                    Text(
                      notification.title,
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.titleMedium?.copyWith(
                        fontWeight: isUnread
                            ? FontWeight.w700
                            : FontWeight.w500,
                        color: AppColors.neutrals02,
                      ),
                    ),

                    const SizedBox(height: 5),

                    // ==================================================
                    // MESSAGE
                    // ==================================================
                    Text(
                      notification.message,
                      maxLines: 3,
                      overflow: TextOverflow.ellipsis,
                      style: Theme.of(context).textTheme.bodyMedium?.copyWith(
                        color: AppColors.neutrals03,
                        height: 1.35,
                      ),
                    ),

                    const SizedBox(height: 9),

                    // ==================================================
                    // DATE
                    // ==================================================
                    Text(
                      DateFormat(
                        'dd MMM yyyy • hh:mm a',
                      ).format(notification.createdAt),
                      style: Theme.of(context).textTheme.bodySmall?.copyWith(
                        color: AppColors.neutrals03,
                      ),
                    ),
                  ],
                ),
              ),
            ],
          ),
        ),
      ),
    );
  }
}
