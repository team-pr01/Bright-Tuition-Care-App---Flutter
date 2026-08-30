import 'package:btcclient/core/widgets/navbar/common_appbar.dart';
import 'package:btcclient/features/legal/data/models/imprtant_guideline.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/config/theme.dart';

class ImportantGuidelinesScreen extends ConsumerWidget {
  final ImportantGuidelinesData document;

  const ImportantGuidelinesScreen({
    super.key,
    required this.document,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    final theme = Theme.of(context);

    return Scaffold(
      appBar: const CommonAppBar(
        title: "Important Guidelines",
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            /// Main Title
            Text(
              document.title,
              style: theme.textTheme.headlineMedium,
            ),

            const SizedBox(height: AppSpacing.lg),

            /// Sections
            ...document.sections.map(
              (section) => _buildSection(
                context,
                section,
              ),
            ),
          ],
        ),
      ),
    );
  }

  Widget _buildSection(
    BuildContext context,
    ImportantGuidelineSection section,
  ) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(
        bottom: AppSpacing.lg,
      ),
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
          if (section.description != null)
            Padding(
              padding: const EdgeInsets.only(
                bottom: AppSpacing.sm,
              ),
              child: Text(
                section.description!,
                style: theme.textTheme.bodyMedium?.copyWith(
                  height: 1.6,
                ),
              ),
            ),

          /// Normal Content
          if (section.content != null)
            ...section.content!.map(
              (text) => Padding(
                padding: const EdgeInsets.only(
                  bottom: AppSpacing.sm,
                ),
                child: Text(
                  text,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    height: 1.6,
                  ),
                ),
              ),
            ),

          /// Bullet Points
          if (section.points != null)
            ...section.points!.map(
              (point) => _buildBulletPoint(
                context,
                point,
              ),
            ),

          /// Nested Subsections
          if (section.subsections != null)
            ...section.subsections!.map(
              (subsection) => _buildSubsection(
                context,
                subsection,
              ),
            ),

          /// Section Note
          if (section.note != null)
            _buildNote(
              context,
              section.note!,
            ),
        ],
      ),
    );
  }

  Widget _buildSubsection(
    BuildContext context,
    ImportantGuidelineSubsection subsection,
  ) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(
        top: AppSpacing.md,
      ),
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

          /// Subsection Content
          if (subsection.content != null)
            ...subsection.content!.map(
              (text) => Padding(
                padding: const EdgeInsets.only(
                  bottom: AppSpacing.sm,
                ),
                child: Text(
                  text,
                  style: theme.textTheme.bodyMedium?.copyWith(
                    height: 1.6,
                  ),
                ),
              ),
            ),

          /// Subsection Note
          if (subsection.note != null)
            _buildNote(
              context,
              subsection.note!,
            ),
        ],
      ),
    );
  }

  Widget _buildBulletPoint(
    BuildContext context,
    String point,
  ) {
    final theme = Theme.of(context);

    return Padding(
      padding: const EdgeInsets.only(
        bottom: 6,
      ),
      child: Row(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          const Padding(
            padding: EdgeInsets.only(
              top: 2,
              right: 8,
            ),
            child: Text("•"),
          ),
          Expanded(
            child: Text(
              point,
              style: theme.textTheme.bodyMedium?.copyWith(
                height: 1.5,
              ),
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildNote(
    BuildContext context,
    String note,
  ) {
    final theme = Theme.of(context);

    return Container(
      margin: const EdgeInsets.only(
        top: AppSpacing.md,
      ),
      padding: const EdgeInsets.all(
        AppSpacing.md,
      ),
      decoration: BoxDecoration(
        color: Colors.yellow.shade100,
        borderRadius: BorderRadius.circular(8),
      ),
      child: Text(
        note,
        style: theme.textTheme.bodyMedium?.copyWith(
          height: 1.5,
        ),
      ),
    );
  }
}