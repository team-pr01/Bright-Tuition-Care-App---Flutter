import 'package:btcclient/core/config/theme.dart';
import 'package:btcclient/core/utils/image_picker_bottom_sheet.dart';
import 'package:btcclient/core/utils/notification_service.dart';
import 'package:btcclient/features/auth/data/models/guardian_model.dart';
import 'package:btcclient/features/auth/presentation/provider/profile_notifier.dart';
import 'package:btcclient/features/profile/presentation/widgets/emergency_section_card.dart';
import 'package:btcclient/features/profile/presentation/widgets/guardian_personal_section_card.dart';
import 'package:btcclient/features/profile/presentation/widgets/guardian_profile_card.dart';
import 'package:btcclient/features/profile/presentation/widgets/profile_tab_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import 'edit_personal_information_screen.dart';

class GuardianProfilePage extends ConsumerStatefulWidget {
  const GuardianProfilePage({super.key});

  @override
  ConsumerState<GuardianProfilePage> createState() =>
      _GuardianProfilePageState();
}

class _GuardianProfilePageState
    extends ConsumerState<GuardianProfilePage> {
  int selectedTab = 0;

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      ref.read(profileProvider.notifier).fetchProfile();
    });
  }

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(profileProvider);
    final notifier = ref.read(profileProvider.notifier);

    return Scaffold(
      backgroundColor: const Color(0xffF5F7FB),
      body: RefreshIndicator(
        onRefresh: () async {
          await notifier.refreshProfile();
        },
        child: _buildBody(profile, notifier),
      ),
    );
  }

  Widget _buildBody(
    GuardianProfileModel? profile,
    ProfileNotifier notifier,
  ) {
    if (notifier.isLoading && profile == null) {
      return const Center(
        child: CircularProgressIndicator(),
      );
    }

    if (notifier.error != null && profile == null) {
      return Center(
        child: Text(notifier.error!),
      );
    }

    if (profile == null) {
      return const Center(
        child: Text("Profile not found"),
      );
    }

    return Container(
      width: double.infinity,
      height: double.infinity,
      padding: const EdgeInsets.only(top: 20),
      decoration: const BoxDecoration(
        gradient: LinearGradient(
          begin: Alignment.centerLeft,
          end: Alignment.centerRight,
          colors: [
            AppColors.primaryGradientStart,
            AppColors.primaryGradientEnd,
          ],
          stops: [0.0082, 1],
        ),
      ),
      child: SingleChildScrollView(
        physics: const AlwaysScrollableScrollPhysics(),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // =====================================================
            // GUARDIAN PROFILE HEADER
            // =====================================================

            GuardianProfileCard(
              name: profile.name,
              guardianId: profile.guardianId,
              email: profile.email,
              phone: profile.phoneNumber,
              address: profile.address ?? "Not Provided",
              profileImage: profile.imageUrl,
              rating: profile.rating,
              isVerified: profile.isVerified,

              onEditImage: () async {
                debugPrint("📸 GUARDIAN CAMERA CLICKED");

                try {
                  final result =
                      await ImagePickerBottomSheet.show(context);

                  if (result == null) {
                    debugPrint("📸 No image selected");
                    return;
                  }

                  debugPrint(
                    "📸 Guardian image selected: ${result.path}",
                  );

                  final success = await ref
                      .read(profileProvider.notifier)
                      .updateProfileImage(result);

                  if (!mounted) return;

                  if (success) {
                    await ref
                        .read(profileProvider.notifier)
                        .refreshProfile();

                    if (!mounted) return;

                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          "Profile image updated successfully",
                        ),
                      ),
                    );
                  } else {
                    ScaffoldMessenger.of(context).showSnackBar(
                      const SnackBar(
                        content: Text(
                          "Failed to update profile image",
                        ),
                      ),
                    );
                  }
                } catch (e, stackTrace) {
                  debugPrint(
                    "❌ Guardian profile image error: $e",
                  );

                  debugPrintStack(
                    stackTrace: stackTrace,
                  );

                  if (!mounted) return;

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text(
                        "Unable to change profile image",
                      ),
                    ),
                  );
                }
              },
            ),

            // =====================================================
            // WHITE CONTENT AREA
            // =====================================================

            const SizedBox(height: 4),

            Container(
              width: double.infinity,
              padding: const EdgeInsets.symmetric(
                vertical: 12,
              ),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              child: Column(
                children: [
                  // =================================================
                  // TABS
                  // =================================================

                  SizedBox(
                    height: 70,
                    child: Row(
                      children: [
                        Expanded(
                          child: ProfileTabCard(
                            title: "Personal",
                            icon: Icons.person_outline,
                            isActive: selectedTab == 0,
                            onTap: () {
                              setState(() {
                                selectedTab = 0;
                              });
                            },
                          ),
                        ),

                        Expanded(
                          child: ProfileTabCard(
                            title: "Emergency",
                            icon: Icons.emergency_outlined,
                            isActive: selectedTab == 1,
                            onTap: () {
                              setState(() {
                                selectedTab = 1;
                              });
                            },
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Divider(
                    height: 1,
                    thickness: 1,
                  ),

                  // =================================================
                  // TAB CONTENT
                  // =================================================

                  AnimatedSwitcher(
                    duration: const Duration(
                      milliseconds: 300,
                    ),
                    switchInCurve: Curves.easeInOut,
                    switchOutCurve: Curves.easeInOut,
                    child: Container(
                      key: ValueKey(selectedTab),
                      child: _buildSelectedTab(profile),
                    ),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSelectedTab(
    GuardianProfileModel profile,
  ) {
    switch (selectedTab) {
      case 0:
        return GuardianPersonalSectionCard(
          profile: profile,
          onEdit: () async {
            final updated = await Navigator.push<bool>(
              context,
              MaterialPageRoute(
                builder: (_) =>
                    const EditPersonalInformationScreen(),
              ),
            );

            if (updated == true && mounted) {
              await ref
                  .read(profileProvider.notifier)
                  .refreshProfile();
            }
          },
        );

      case 1:
        return GuardianEmergencySectionCard(
          profile: profile,
          onEdit: () {
            // Add emergency edit navigation here.
          },
        );

      default:
        return const SizedBox.shrink();
    }
  }
}