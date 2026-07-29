import 'package:btcclient/core/config/theme.dart';
import 'package:btcclient/core/widgets/navbar/common_appbar.dart';
import 'package:collection/collection.dart';
import 'package:btcclient/features/auth/data/models/guardian_model.dart';
import 'package:btcclient/features/auth/data/models/tutor_model.dart';
import 'package:btcclient/features/auth/presentation/provider/profile_notifier.dart';
import 'package:btcclient/features/invoices/presentation/provider/invoice_provider.dart';
import 'package:btcclient/features/settings/prersentation/provider/verification_provider.dart';
import 'package:btcclient/features/settings/prersentation/widgets/verification_form.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

class VerificationScreen extends ConsumerStatefulWidget {
  const VerificationScreen({super.key});

  @override
  ConsumerState<VerificationScreen> createState() =>
      _VerificationScreenState();
}

class _VerificationScreenState
    extends ConsumerState<VerificationScreen> {
  @override
  void initState() {
    super.initState();

    Future.microtask(() async {
      await ref.read(profileProvider.notifier).fetchProfile();

      await ref
          .read(verificationProvider.notifier)
          .fetchVerification();
    });
  }

  Future<void> _refresh() async {
    await ref.read(profileProvider.notifier).fetchProfile();

    await ref
        .read(verificationProvider.notifier)
        .fetchVerification();
  }

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);

    final invoiceState = ref.watch(invoiceProvider);

    final verificationInvoice =
        invoiceState.invoices.firstWhereOrNull(
      (invoice) =>
          invoice.invoiceType == "verificationCharge",
    );

    final profile = ref.watch(profileProvider);

    final verification =
        ref.watch(verificationProvider);

    bool isVerified = false;
    bool hasRequested = false;

    if (profile is GuardianProfileModel) {
      isVerified = profile.isVerified;
      hasRequested = profile.hasRequestedToVerify;
    } else if (profile is TutorProfileModel) {
      isVerified = profile.isVerified;
      hasRequested = profile.hasRequestedToVerify;
    }

    return Scaffold(
      backgroundColor: AppColors.neutrals01,
      appBar: const CommonAppBar( title: "Profile Verification",),
      body: SafeArea(
        child: RefreshIndicator(
          onRefresh: _refresh,
          child: SingleChildScrollView(
            physics:
                const AlwaysScrollableScrollPhysics(),
            padding: const EdgeInsets.symmetric(
              horizontal: AppSpacing.lg,
            ),
            child: Column(
              children: [
                const SizedBox(height: AppSpacing.slg),

                verificationForm(
                  context,
                  theme,
                  ref,
                  isVerified,
                  hasRequested,
                  verification.status,
                  verification.addressCode,
                  verificationInvoice,
                ),

                const SizedBox(height: AppSpacing.xl),
              ],
            ),
          ),
        ),
      ),
    );
  }
}