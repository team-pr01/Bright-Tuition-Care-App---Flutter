import 'package:btcclient/core/widgets/navbar/common_appbar.dart';
import 'package:btcclient/features/legal/data/models/legal_document.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/config/theme.dart';// 👈 Ensure this import matches your model location
import '../providers/legal_provider.dart';

class TermsScreen extends ConsumerWidget {
  const TermsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final document = ref.watch(termsProvider);

    return Scaffold(
      appBar: CommonAppBar(
        title: "Terms and Conditions",
        showNotification: false,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            // ...document.sections.map(
            //   (section) => _buildSection(context, section),
            // ),
            for (final section in document.sections)
              _buildSection(context, section),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(BuildContext context, LegalSection section) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: AppSpacing.lg),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Section Title
          Text(
            section.title,
            style: theme.textTheme.titleLarge?.copyWith(
              color: AppColors.primary01,
            ),
          ),

          const SizedBox(height: AppSpacing.sm),

          /// Description
          if (section.description != null && section.description!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: Text(
                section.description!,
                style: theme.textTheme.bodyMedium?.copyWith(height: 1.6),
              ),
            ),

          /// Normal Content
          if (section.content != null)
            ...section.content!.map(
              (text) => Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                child: Text(
                  text,
                  style: theme.textTheme.bodyMedium?.copyWith(height: 1.6),
                ),
              ),
            ),

          /// Bullet Points
          if (section.points != null)
            ...section.points!.map(
              (point) => _buildBulletPoint(context, point),
            ),

          /// Nested Subsections
          if (section.subsections != null)
            ...section.subsections!.map(
              (subsection) => _buildSubsection(context, subsection),
            ),

          /// Section Note
          if (section.note != null && section.note!.isNotEmpty)
            _buildNote(context, section.note!),
        ],
      ),
    );
  }

  Widget _buildSubsection(BuildContext context, LegalSubsection subsection) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(top: AppSpacing.md, left: AppSpacing.sm),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          /// Subsection Heading
          Text(
            subsection.title,
            style: theme.textTheme.titleMedium?.copyWith(
              fontWeight: FontWeight.w600,
            ),
          ),

          const SizedBox(height: AppSpacing.xs),

          /// Subsection Description
          if (subsection.description != null &&
              subsection.description!.isNotEmpty)
            Padding(
              padding: const EdgeInsets.only(bottom: AppSpacing.sm),
              child: Text(
                subsection.description!,
                style: theme.textTheme.bodyMedium?.copyWith(height: 1.6),
              ),
            ),

          /// Subsection Content
          if (subsection.content != null)
            ...subsection.content!.map(
              (text) => Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                child: Text(
                  text,
                  style: theme.textTheme.bodyMedium?.copyWith(height: 1.6),
                ),
              ),
            ),

          /// Subsection Points
          if (subsection.points != null)
            ...subsection.points!.map(
              (point) => _buildBulletPoint(context, point),
            ),

          /// Subsection Note
          if (subsection.note != null && subsection.note!.isNotEmpty)
            _buildNote(context, subsection.note!),
        ],
      ),
    );
  }

  Widget _buildBulletPoint(BuildContext context, String point) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(bottom: 6),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(top: 2, right: 8),
            child: Text("•"),
          ),
          Expanded(
            child: Text(
              point,
              style: theme.textTheme.bodyMedium?.copyWith(height: 1.5),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNote(BuildContext context, String note) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(top: 8),
      decoration: BoxDecoration(
        color: AppColors.warning03,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Container(
        margin: const EdgeInsets.only(left: 8),
        padding: const EdgeInsets.all(12),
        decoration: BoxDecoration(
          color: AppColors.warning02,
          borderRadius: const BorderRadius.only(
            topRight: Radius.circular(8),
            bottomRight: Radius.circular(8),
          ),
        ),
        child: Text(
          note,
          style: theme.textTheme.bodyMedium?.copyWith(height: 1.5),
          textHeightBehavior: const TextHeightBehavior(
            applyHeightToFirstAscent: false,
            applyHeightToLastDescent: false,
          ),
        ),
      ),
    );
  }
}