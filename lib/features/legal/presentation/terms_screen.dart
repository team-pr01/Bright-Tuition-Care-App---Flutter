import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';

import '../../../../core/config/theme.dart';
import '../providers/legal_provider.dart';

class TermsScreen extends ConsumerWidget {

  const TermsScreen({super.key});

  @override
  Widget build(BuildContext context, WidgetRef ref) {

    final document = ref.watch(termsProvider);

    return Scaffold(

      appBar: AppBar(
        title: Text(document.title),
      ),

      body: SingleChildScrollView(

        padding: const EdgeInsets.all(AppSpacing.md),

        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,

          children: [

            Text(
              document.title,
              style: Theme.of(context)
                  .textTheme
                  .headlineMedium,
            ),

            const SizedBox(height: AppSpacing.lg),

            ...document.sections.map(

              (section) => Padding(

                padding: const EdgeInsets.only(
                  bottom: AppSpacing.lg,
                ),

                child: Column(
                  crossAxisAlignment:
                      CrossAxisAlignment.start,

                  children: [

                    Text(
                      section.title,
                      style: Theme.of(context)
                          .textTheme
                          .titleLarge!
                          .copyWith(
                            color: AppColors.primary01,
                          ),
                    ),

                    const SizedBox(height: AppSpacing.sm),

                    Text(
                      section.content,
                      style: Theme.of(context)
                          .textTheme
                          .bodyMedium!
                          .copyWith(
                            height: 1.6,
                          ),
                    ),

                  ],
                ),

              ),

            ),

          ],

        ),

      ),

    );

  }

}