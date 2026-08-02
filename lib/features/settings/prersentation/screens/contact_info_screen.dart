import 'package:btcclient/core/config/theme.dart';
import 'package:btcclient/core/widgets/navbar/common_appbar.dart';
import 'package:btcclient/features/auth/data/models/guardian_model.dart';
import 'package:btcclient/features/auth/data/models/tutor_model.dart';
import 'package:btcclient/features/auth/presentation/provider/profile_notifier.dart';
import 'package:btcclient/features/settings/prersentation/widgets/contact_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class ContactInfoScreen extends ConsumerStatefulWidget {
  const ContactInfoScreen({super.key});

  @override
  ConsumerState<ContactInfoScreen> createState() => _ContactInfoScreenState();
}

class _ContactInfoScreenState extends ConsumerState<ContactInfoScreen> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      await ref.read(profileProvider.notifier).fetchProfile();
    });
  }

  Future<void> _refresh() async {
    await ref.read(profileProvider.notifier).fetchProfile();
  }

  @override
  Widget build(BuildContext context) {
    final profile = ref.watch(profileProvider);

    bool isProfileLocked = true;

    if (profile is GuardianProfileModel) {
      isProfileLocked = profile.profileStatus == "locked";
    } else if (profile is TutorProfileModel) {
      isProfileLocked = profile.profileStatus == "locked";
    }

    return Scaffold(
      appBar: const CommonAppBar(title: "Contact Information"),
      body: ContactForm(isProfileLocked: isProfileLocked),
    );
  }
}
