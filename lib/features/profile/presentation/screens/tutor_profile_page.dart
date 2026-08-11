import 'package:btcclient/core/config/theme.dart';
import 'package:btcclient/core/pdf/pdf_service.dart';
import 'package:btcclient/core/utils/file_picker_utils.dart';
import 'package:btcclient/core/widgets/button/app_button.dart';
import 'package:btcclient/features/auth/data/models/tutor_model.dart';
import 'package:btcclient/features/auth/presentation/provider/profile_notifier.dart';
import 'package:btcclient/features/profile/data/requests/update_personal_info_request.dart';
import 'package:btcclient/features/profile/pdf/tutor_resume_pdf.dart';
import 'package:btcclient/features/profile/presentation/screens/add_credential_screen.dart';
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

  Future<void> _deleteCredential(Identity identity) async {
    final id = identity.id;

    if (id == null || id.isEmpty) {
      debugPrint('❌ Credential ID is missing');

      if (!mounted) return;

      ScaffoldMessenger.of(
        context,
      ).showSnackBar(const SnackBar(content: Text('Credential ID is missing')));

      return;
    }

    try {
      debugPrint('🗑️ Deleting credential: $id');

      final success = await ref
          .read(profileProvider.notifier)
          .deleteIdentityInfo(id);

      if (!mounted) return;

      if (!success) {
        ScaffoldMessenger.of(context).showSnackBar(
          SnackBar(
            content: Text(
              ref.read(profileProvider.notifier).error ??
                  'Failed to delete credential',
            ),
          ),
        );

        return;
      }

      await ref.read(profileProvider.notifier).refreshProfile();

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Credential deleted successfully')),
      );
    } catch (e) {
      debugPrint('❌ Failed to delete credential: $e');

      if (!mounted) return;

      ScaffoldMessenger.of(context).showSnackBar(
        const SnackBar(content: Text('Failed to delete credential')),
      );
    }
  }

  Future<void> _confirmDeleteCredential(Identity identity) async {
    final shouldDelete = await showModalBottomSheet<bool>(
      context: context,
      isScrollControlled: true,
      backgroundColor: Colors.transparent,
      builder: (sheetContext) {
        return SafeArea(
          child: Container(
            padding: const EdgeInsets.fromLTRB(24, 24, 24, 32),
            decoration: const BoxDecoration(
              color: Colors.white,
              borderRadius: BorderRadius.vertical(top: Radius.circular(24)),
            ),
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
                Container(
                  width: 40,
                  height: 4,
                  decoration: BoxDecoration(
                    color: Colors.grey.shade300,
                    borderRadius: BorderRadius.circular(10),
                  ),
                ),

                const SizedBox(height: 24),

                Container(
                  width: 52,
                  height: 52,
                  decoration: BoxDecoration(
                    color: Colors.red.withOpacity(0.1),
                    shape: BoxShape.circle,
                  ),
                  child: const Icon(
                    Icons.delete_outline,
                    color: Colors.red,
                    size: 28,
                  ),
                ),

                const SizedBox(height: 16),

                const Text(
                  'Delete Credential',
                  style: TextStyle(fontSize: 20, fontWeight: FontWeight.w700),
                ),

                const SizedBox(height: 10),

                const Text(
                  'Are you sure you want to delete this credential document? '
                  'This action cannot be undone.',
                  textAlign: TextAlign.center,
                  style: TextStyle(
                    fontSize: 14,
                    height: 1.5,
                    color: Colors.black54,
                  ),
                ),

                const SizedBox(height: 24),

                Row(
                  children: [
                    Expanded(
                      child: AppButton(
                        label: 'Cancel',
                        variant: AppButtonVariant.outlineGray,
                        height: 46,
                        onPressed: () {
                          Navigator.pop(sheetContext, false);
                        },
                      ),
                    ),

                    const SizedBox(width: 12),

                    Expanded(
                      child: AppButton(
                        label: 'Delete',
                        icon: Icons.delete_outline,
                        variant: AppButtonVariant.delete,
                        height: 46,
                        onPressed: () {
                          Navigator.pop(sheetContext, true);
                        },
                      ),
                    ),
                  ],
                ),
              ],
            ),
          ),
        );
      },
    );

    if (shouldDelete != true) {
      return;
    }

    await _deleteCredential(identity);
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
              profile: profile,
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

          // ADD / ADD MORE
          onAdd: () async {
            final result = await Navigator.push<bool>(
              context,
              MaterialPageRoute(builder: (_) => const AddCredentialScreen()),
            );

            if (result == true && mounted) {
              await ref.read(profileProvider.notifier).refreshProfile();
            }
          },

          // DELETE
          onDelete: (identity) {
            _confirmDeleteCredential(identity);
          },
        );
      default:
        return const SizedBox.shrink();
    }
  }
}
