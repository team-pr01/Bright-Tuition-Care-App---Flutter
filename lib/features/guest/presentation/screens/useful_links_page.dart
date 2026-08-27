import 'package:btcclient/core/config/theme.dart';
import 'package:btcclient/core/widgets/navbar/common_appbar.dart';
import 'package:btcclient/features/guest/presentation/widgets/overview_bottom_sheets.dart';
import 'package:flutter/material.dart';

class UsefulLinksPage extends StatelessWidget {
  const UsefulLinksPage({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppBar(
        title: 'Useful Links',
        showNotification: false,
      ),
      backgroundColor: AppColors.primary04,
      body: SingleChildScrollView(
        child: Container(
          width: double.infinity,
          constraints: BoxConstraints(
            minHeight: MediaQuery.sizeOf(context).height,
          ),
          padding: const EdgeInsets.symmetric(
            horizontal: 16,
          ),
          color: AppColors.primary04,
          child: Column(
            children: [
              const SizedBox(height: 14),

              AboutUsContent(),

              const SizedBox(height: 14),

              ContactUsContent(),

              const SizedBox(height: 14),

              SocialLinksContent(),
            ],
          ),
        ),
      ),
    );
  }
}