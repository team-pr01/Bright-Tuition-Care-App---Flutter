import 'package:btcclient/core/config/theme.dart';
import 'package:btcclient/core/pdf/pdf_service.dart';
import 'package:btcclient/core/utils/file_picker_utils.dart';
import 'package:btcclient/features/auth/data/models/tutor_model.dart';
import 'package:btcclient/features/auth/presentation/provider/profile_notifier.dart';
import 'package:btcclient/features/profile/data/requests/update_personal_info_request.dart';
import 'package:btcclient/features/profile/pdf/tutor_resume_pdf.dart';
import 'package:btcclient/features/profile/presentation/screens/edit_education_screen.dart';
import 'package:btcclient/features/profile/presentation/screens/edit_personal_information_screen.dart';
import 'package:btcclient/features/profile/presentation/screens/edit_tuition_related_information_screen.dart';
import 'package:btcclient/features/profile/presentation/widgets/profile_tab_card.dart';
import 'package:btcclient/features/profile/presentation/widgets/shared/delete_education_dialog.dart';
import 'package:btcclient/features/profile/presentation/widgets/tuition_section_card.dart';
import 'package:btcclient/features/profile/presentation/widgets/tutor_profile_card.dart';
import 'package:btcclient/features/profile/presentation/widgets/tutor_sections/credential_section_card.dart';
import 'package:btcclient/features/profile/presentation/widgets/tutor_sections/education_section_card.dart';
import 'package:btcclient/features/profile/presentation/widgets/tutor_sections/personal_section_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:btcclient/core/utils/image_picker_bottom_sheet.dart';

class TutorProfileScreen extends ConsumerStatefulWidget {
  const TutorProfileScreen({super.key});

  @override
  ConsumerState<TutorProfileScreen> createState() => _TutorProfileScreenState();
}

class _TutorProfileScreenState extends ConsumerState<TutorProfileScreen> {
  int selectedTab = 0;

  @override
  void initState() {
    super.initState();

    Future.microtask(() {
      ref.read(profileProvider.notifier).fetchProfile();
    });
  }

  Future<void> _deleteEducation(Education education) async {
    try {
      final id = education.id;

      if (id == null || id.isEmpty) {
        debugPrint('❌ Education ID is missing');
        return;
      }

      debugPrint('🗑️ Deleting education: $id');

      await ref.read(profileProvider.notifier).deleteEducation(id);

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Education deleted successfully')),
      );

      // Refresh profile so the deleted item disappears.
      await ref.read(profileProvider.notifier).refreshProfile();
    } catch (e) {
      debugPrint('❌ Failed to delete education: $e');

      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(SnackBar(content: Text('Failed to delete education')));
    }
  }

  Future<void> _confirmDeleteEducation(Education education) async {
    final shouldDelete = await showDeleteEducationDialog(context);

    if (shouldDelete != true) {
      return;
    }

    await _deleteEducation(education);
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

  Widget _buildBody(TutorProfileModel? profile, ProfileNotifier notifier) {
    if (notifier.isLoading && profile == null) {
      return const Center(child: CircularProgressIndicator());
    }

    if (notifier.error != null && profile == null) {
      return Center(child: Text(notifier.error!));
    }

    if (profile == null) {
      return const Center(child: Text("Profile not found"));
    }

    return Container(
      padding: const EdgeInsets.only(top: 20),
      width: double.infinity,
      height: double.infinity,
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
            TutorProfileCard(
              name: profile.name,
              tutorId: profile.tutorId,
              email: profile.email,
              phone: profile.phoneNumber,
              address: profile.personalInfo.address ?? "Not Provided",
              profileImage: profile.imageUrl ?? "",
              isVerified: profile.isVerified,
              profileCompleted: profile.profileCompleted,
              rating: profile.rating,

              onDownload: () async {
                final pdf = await TutorResumePdf.build(profile: profile);

                await PdfService.download(
                  fileName:
                      "Bright_Tuition_Care_${profile.name.replaceAll(' ', '_')}.pdf",
                  child: pdf,
                );
              },
              onEditImage: () async {
                final image = await ImagePickerBottomSheet.show(context);

                if (image == null) return;

                final success = await ref
                    .read(profileProvider.notifier)
                    .updateProfileImage(image);

                if (!mounted) return;

                if (success) {
                  await ref.read(profileProvider.notifier).refreshProfile();

                  ScaffoldMessenger.of(context).showSnackBar(
                    const SnackBar(
                      content: Text("Profile image updated successfully"),
                    ),
                  );
                }
              },
            ),

            const SizedBox(height: 4),
            Container(
              padding: const EdgeInsets.symmetric(vertical: 12),
              decoration: const BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.only(
                  topLeft: Radius.circular(24),
                  topRight: Radius.circular(24),
                ),
              ),
              child: Column(
                children: [
                  SizedBox(
                    height: 70,
                    child: Row(
                      children: [
                        Expanded(
                          child: ProfileTabCard(
                            title: "Personal",
                            icon: Icons.person,
                            isActive: selectedTab == 0,
                            onTap: () => setState(() => selectedTab = 0),
                          ),
                        ),
                        Expanded(
                          child: ProfileTabCard(
                            title: "Educational",
                            icon: Icons.article_outlined,
                            isActive: selectedTab == 1,
                            onTap: () => setState(() => selectedTab = 1),
                          ),
                        ),
                        Expanded(
                          child: ProfileTabCard(
                            title: "Tuition",
                            icon: Icons.school_outlined,
                            isActive: selectedTab == 2,
                            onTap: () => setState(() => selectedTab = 2),
                          ),
                        ),
                        Expanded(
                          child: ProfileTabCard(
                            title: "Credential",
                            icon: Icons.workspace_premium_outlined,
                            isActive: selectedTab == 3,
                            onTap: () => setState(() => selectedTab = 3),
                          ),
                        ),
                      ],
                    ),
                  ),

                  const Divider(height: 1, thickness: 1),

                  AnimatedSwitcher(
                    duration: const Duration(milliseconds: 300),
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

  Widget _buildSelectedTab(TutorProfileModel profile) {
    switch (selectedTab) {
      case 0:
        return PersonalSectionCard(
          profile: profile,
          onEdit: () async {
            final updated = await Navigator.push<bool>(
              context,
              MaterialPageRoute(
                builder: (_) => const EditPersonalInformationScreen(),
              ),
            );

            if (updated == true && mounted) {
              await ref.read(profileProvider.notifier).refreshProfile();
            }
          },
        );

      case 1:
        return EducationSectionCard(
          educations: profile.education,
          onDelete: (education) {
            _confirmDeleteEducation(education);
          },

          onAdd: () async {
            final added = await Navigator.push<bool>(
              context,
              MaterialPageRoute(builder: (_) => const EditEducationScreen()),
            );

            if (added == true && mounted) {
              await ref.read(profileProvider.notifier).refreshProfile();
            }
          },

          onEdit: (education) async {
            final updated = await Navigator.push<bool>(
              context,
              MaterialPageRoute(
                builder: (_) => EditEducationScreen(education: education),
              ),
            );

            if (updated == true && mounted) {
              await ref.read(profileProvider.notifier).refreshProfile();
            }
          },
        );

      case 2:
        return TuitionSectionCard(
          profile: profile,
          onEdit: () async {
            final updated = await Navigator.push<bool>(
              context,
              MaterialPageRoute(
                builder: (_) => const EditTuitionRelatedInformationScreen(),
              ),
            );

            if (updated == true && mounted) {
              await ref.read(profileProvider.notifier).refreshProfile();
            }
          },
        );

      case 3:
        return CredentialSectionCard(
          identities: profile.identity,
          onEdit: (identity) {
            // TODO
          },
        );

      default:
        return const SizedBox.shrink();
    }
  }
}
