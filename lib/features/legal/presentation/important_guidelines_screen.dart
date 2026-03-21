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
    return Scaffold(
      appBar: AppBar(
        title: Text(document.title),
      ),

      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.md),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [

            /// Main Title
            Text(
              document.title,
              style: Theme.of(context).textTheme.headlineMedium,
            ),

            const SizedBox(height: AppSpacing.lg),

            /// Sections
            ...document.sections.map((section) {
              return Padding(
                padding: const EdgeInsets.only(bottom: AppSpacing.lg),

                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [

                    /// Section Title
                    Text(
                      section.title,
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge!
                          .copyWith(color: AppColors.primary01),
                    ),

                    const SizedBox(height: AppSpacing.sm),

                    /// Description (optional)
                    if (section.description != null)
                      Padding(
                        padding: const EdgeInsets.only(bottom: AppSpacing.sm),
                        child: Text(
                          section.description!,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium!
                              .copyWith(height: 1.6),
                        ),
                      ),

                    /// Bullet Points
                    if (section.points != null)
                      ...section.points!.map(
                        (point) => Padding(
                          padding: const EdgeInsets.only(
                            bottom: 6,
                          ),
                          child: Row(
                            crossAxisAlignment: CrossAxisAlignment.start,
                            children: [

                              const Text("• "),
                              
                              Expanded(
                                child: Text(
                                  point,
                                  style: Theme.of(context)
                                      .textTheme
                                      .bodyMedium!
                                      .copyWith(height: 1.5),
                                ),
                              ),
                            ],
                          ),
                        ),
                      ),

                    /// Note Box
                    if (section.note != null)
                      Container(
                        margin: const EdgeInsets.only(top: AppSpacing.md),
                        padding: const EdgeInsets.all(AppSpacing.md),
                        decoration: BoxDecoration(
                          color: Colors.yellow.shade100,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Text(
                          section.note!,
                          style: Theme.of(context)
                              .textTheme
                              .bodyMedium,
                        ),
                      ),
                  ],
                ),
              );
            }),
          ],
        ),
      ),
    );
  }
}