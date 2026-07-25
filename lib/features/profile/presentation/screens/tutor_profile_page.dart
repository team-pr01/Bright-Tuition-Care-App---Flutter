import 'package:btcclient/features/auth/data/models/tutor_model.dart';
import 'package:btcclient/features/auth/presentation/provider/profile_notifier.dart';
import 'package:btcclient/features/profile/presentation/screens/edit_education_screen.dart';
import 'package:btcclient/features/profile/presentation/screens/edit_personal_information_screen.dart';
import 'package:btcclient/features/profile/presentation/widgets/profile_tab_card.dart';
import 'package:btcclient/features/profile/presentation/widgets/tuition_section_card.dart';
import 'package:btcclient/features/profile/presentation/widgets/tutor_profile_card.dart';
import 'package:btcclient/features/profile/presentation/widgets/tutor_sections/credential_section_card.dart';
import 'package:btcclient/features/profile/presentation/widgets/tutor_sections/education_section_card.dart';
import 'package:btcclient/features/profile/presentation/widgets/tutor_sections/personal_section_card.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

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

    return SingleChildScrollView(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(16),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          TutorProfileCard(
            name: profile.name,
            tutorId: profile.tutorId,
            email: profile.email,
            phone: profile.phoneNumber,
            address: profile.personalInfo.address ?? "Not Provided",
            profileImage: profile.imageUrl ?? "https://i.pravatar.cc/300",
            isVerified: profile.isVerified,
            profileCompleted: profile.profileCompleted,
            rating: profile.rating,
          ),

          const SizedBox(height: 20),

          SizedBox(
            height: 100,
            child: Row(
              children: [
                Expanded(
                  child: ProfileTabCard(
                    title: "Personal",
                    subtitle: "Information",
                    icon: Icons.person_outline,
                    isActive: selectedTab == 0,
                    isCompleted: selectedTab == 0,
                    onTap: () {
                      setState(() => selectedTab = 0);
                    },
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: ProfileTabCard(
                    title: "Educational",
                    subtitle: "Information",
                    icon: Icons.school_outlined,
                    isActive: selectedTab == 1,
                    isCompleted: selectedTab == 1,
                    onTap: () {
                      setState(() => selectedTab = 1);
                    },
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: ProfileTabCard(
                    title: "Tuition",
                    subtitle: "Preference",
                    icon: Icons.work_outline,
                    isActive: selectedTab == 2,
                    isCompleted: selectedTab == 2,
                    onTap: () {
                      setState(() => selectedTab = 2);
                    },
                  ),
                ),

                const SizedBox(width: 12),

                Expanded(
                  child: ProfileTabCard(
                    title: "Credential",
                    subtitle: "Information",
                    icon: Icons.description_outlined,
                    isActive: selectedTab == 3,
                    isCompleted: selectedTab == 3,
                    onTap: () {
                      setState(() => selectedTab = 3);
                    },
                  ),
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),

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
        return TuitionSectionCard(profile: profile);

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
