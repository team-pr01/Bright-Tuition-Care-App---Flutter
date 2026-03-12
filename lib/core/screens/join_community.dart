import 'package:btcclient/core/config/theme.dart';
import 'package:btcclient/core/widgets/button/app_button.dart';
import 'package:btcclient/core/widgets/navbar/common_appbar.dart';
import 'package:flutter/material.dart';
import 'package:url_launcher/url_launcher.dart';

class CommunityPage extends StatelessWidget {
  final String title;
  final String description;
  final String buttonText;
  final String link;
  const CommunityPage({
    super.key,
    required this.title,
    required this.description,
    required this.buttonText,
    required this.link,
  });
  Future<void> openLink() async {
    final Uri uri = Uri.parse(link);
    await launchUrl(uri, mode: LaunchMode.inAppBrowserView);
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.neutrals01,
       appBar: const CommonAppBar(),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 24),
          child: Column(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              /// TITLE
              Text(
                title,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                  color: AppColors.neutrals02
                ),
              ),
              const SizedBox(height: 14),

              /// DESCRIPTION
              Text(
                description,
                textAlign: TextAlign.center,
                style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                  color: AppColors.neutrals03
                ),
              ),
              const SizedBox(height: 30),

              /// IMAGE
              Image.asset("assets/images/community.webp", height: 240, fit: BoxFit.contain),
              const SizedBox(height: 40),

               AppButton(
                label: buttonText,
                variant: AppButtonVariant.gradient,
                onPressed: openLink,
                 icon: Icons.north_east,
              ),
            ],
          ),
        ),
      ),
    );
  }
}
