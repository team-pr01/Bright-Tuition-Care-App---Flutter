import 'package:btcclient/features/auth/data/models/tutor_model.dart';
import 'package:btcclient/features/auth/presentation/provider/profile_notifier.dart';
import 'package:btcclient/features/profile/presentation/widgets/credential_section_card.dart';
import 'package:btcclient/features/profile/presentation/widgets/education_section_card.dart';
import 'package:btcclient/features/profile/presentation/widgets/profile_overview_card.dart';
import 'package:btcclient/features/profile/presentation/widgets/profile_tab_card.dart';
import 'package:btcclient/features/profile/presentation/widgets/tuition_section_card.dart';
import 'package:btcclient/features/profile/presentation/widgets/tutor_profile_card.dart';
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
    final state = ref.watch(profileProvider);
    return Scaffold(
      backgroundColor: const Color(0xffF5F7FB),
      body: RefreshIndicator(
        onRefresh: () async {
          await ref.read(profileProvider.notifier).refreshProfile();
        },
        child: _buildBody(state),
      ),
    );
  }

  Widget _buildBody(dynamic profile) {
    final notifier = ref.read(profileProvider.notifier);
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
          /// ================= PROFILE CARD =================
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

          /// ================= TABS =================
          SizedBox(
            height: 100,
            child: ListView(
              scrollDirection: Axis.horizontal,
              children: [
                ProfileTabCard(
                  title: "Personal",
                  subtitle: "Information",
                  icon: Icons.badge_outlined,
                  isActive: selectedTab == 0,
                  isCompleted: true,
                  onTap: () {
                    setState(() {
                      selectedTab = 0;
                    });
                  },
                ),
                const SizedBox(width: 14),
                ProfileTabCard(
                  title: "Educational",
                  subtitle: "Information",
                  icon: Icons.school_outlined,
                  isActive: selectedTab == 1,
                  isCompleted: false,
                  onTap: () {
                    setState(() {
                      selectedTab = 1;
                    });
                  },
                ),
                const SizedBox(width: 14),
                ProfileTabCard(
                  title: "Tuition Related",
                  subtitle: "Information",
                  icon: Icons.work_outline,
                  isActive: selectedTab == 2,
                  isCompleted: false,
                  onTap: () {
                    setState(() {
                      selectedTab = 2;
                    });
                  },
                ),
                const SizedBox(width: 14),
                ProfileTabCard(
                  title: "Credential",
                  subtitle: "Information",
                  icon: Icons.description_outlined,
                  isActive: selectedTab == 3,
                  isCompleted: false,
                  onTap: () {
                    setState(() {
                      selectedTab = 3;
                    });
                  },
                ),
              ],
            ),
          ),
          const SizedBox(height: 20),
          AnimatedSwitcher(
            duration: const Duration(milliseconds: 250),
            child: Container(
              key: ValueKey(selectedTab),
              child: _buildSelectedTabContent(profile),
            ),
          ),
        ],
      ),
    );
    return const Center(child: Text("Unsupported profile type"));
  }

  Widget _buildSelectedTabContent(dynamic profile) {
    switch (selectedTab) {
      case 0:
        return ProfileOverviewCard(
          title: "Personal Information", //
          icon: Icons.person,
          overview: profile.personalInfo.overview ?? "Tutor profile overview",
          items: [
            ProfileInfoItem("Email", profile.email),
            ProfileInfoItem("Phone Number", profile.phoneNumber),
            ProfileInfoItem(
              "Additional Number",
              profile.personalInfo.additionalPhone,
            ),
            ProfileInfoItem("Area", profile.area),
            ProfileInfoItem("City", profile.city),
            ProfileInfoItem("Present Address", profile.personalInfo.address),
            ProfileInfoItem("Religion", profile.personalInfo.religion),
            ProfileInfoItem("Facebook", profile.socialMedia.facebook),
            ProfileInfoItem(
              "Gender",
              profile.gender.isNotEmpty
                  ? profile.gender[0].toUpperCase() +
                        profile.gender.substring(1)
                  : "",
            ),
            ProfileInfoItem("Date Of Birth", profile.personalInfo.dateOfBirth),
            ProfileInfoItem("Emergency Person", profile.emergencyInfo.name),
            ProfileInfoItem("Emergency Content", profile.emergencyInfo.phone),
          ],
        );
      case 1:
      
        return EducationSectionCard(educations: profile.education);
    case 2:
  return TuitionSectionCard(
    profile: profile,
  );case 3:
  return CredentialSectionCard(
    identities: profile.identity,
  );
      default:
        return const SizedBox.shrink();
    }
  }
}
