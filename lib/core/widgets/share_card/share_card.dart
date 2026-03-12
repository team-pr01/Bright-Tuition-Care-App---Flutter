import 'package:btcclient/core/config/theme.dart';
import 'package:btcclient/core/widgets/snackbar/app_snackbar.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:url_launcher/url_launcher.dart';
import 'package:share_plus/share_plus.dart';

class ShareCard extends StatelessWidget {
  final String title;
  final String description;
  final String link;
  const ShareCard({
    super.key,
    required this.title,
    required this.description,
    required this.link,
  });
  Future<void> openUrl(String url) async {
    final uri = Uri.parse(url);
    if (await canLaunchUrl(uri)) {
      await launchUrl(uri, mode: LaunchMode.externalApplication);
    }
  }

  Future<void> copyLink(BuildContext context) async {
    await Clipboard.setData(ClipboardData(text: link));
   AppSnackbar.show(
  context,
  "Link copied to clipboard",
  SnackType.success,
);
  }

  Future<void> shareTo(String platform) async {
    final message = link;
    final encoded = Uri.encodeComponent(message);
    switch (platform) {
      case "whatsapp":
        openUrl("https://wa.me/?text=$encoded");
        break;
      case "telegram":
        openUrl("https://t.me/share/url?url=$encoded");
        break;
      case "twitter":
        openUrl("https://twitter.com/intent/tweet?url=$encoded");
        break;
      case "linkedin":
        openUrl("https://www.linkedin.com/sharing/share-offsite/?url=$encoded");
        break;
      case "facebook":
        openUrl("https://www.facebook.com/sharer/sharer.php?u=$encoded");
        break;
      default:
        Share.share(encoded);
    }
  }

  Widget socialIcon({
    required String asset,
    required Color bgColor,
    required VoidCallback onTap,
  }) {
    return InkWell(
      onTap: onTap,
      child: CircleAvatar(
        radius: 22,
        backgroundColor: bgColor,
        child: SvgPicture.asset(
          asset,
          width: 20,
          height: 20,
          colorFilter: const ColorFilter.mode(Colors.white, BlendMode.srcIn),
        ),
      ),
    );
  }

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(20),
      margin: const EdgeInsets.all(16),
      decoration: BoxDecoration(
        color: AppColors.primary03,
        borderRadius: BorderRadius.circular(18),
      ),
      child: Center(
        child: Column(
          mainAxisAlignment: MainAxisAlignment.center, crossAxisAlignment: CrossAxisAlignment.center,
          children: [
            Text(
              title,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.headlineMedium!.copyWith(
                color: AppColors.neutrals02
              ),
            ),
            const SizedBox(height: 12),
            Text(
              description,
              textAlign: TextAlign.center,
              style: Theme.of(context).textTheme.bodyLarge!.copyWith(
                color: AppColors.neutrals03
        
              ),
            ),
            const SizedBox(height: 45),
            Wrap(
              spacing: 12,
              runSpacing: 12,
              alignment: WrapAlignment.center,
              children: [
                socialIcon(
                  asset: "assets/icons/social_media/facebook.svg",
                  bgColor: const Color(0xFF1877F2),
                  onTap: () => shareTo("facebook"),
                ),
                socialIcon(
                  asset: "assets/icons/social_media/instagram.svg",
                  bgColor: const Color(0xFFE1306C),
                  onTap: () => Share.share(link),
                ),
                socialIcon(
                  asset: "assets/icons/social_media/twitter.svg",
                  bgColor: const Color(0xFF1DA1F2),
                  onTap: () => shareTo("twitter"),
                ),
                socialIcon(
                  asset: "assets/icons/social_media/linkedin.svg",
                  bgColor: const Color(0xFF0A66C2),
                  onTap: () => shareTo("linkedin"),
                ),
                socialIcon(
                  asset: "assets/icons/social_media/tiktok.svg",
                  bgColor: Colors.black,
                  onTap: () => Share.share(link),
                ),
                socialIcon(
                  asset: "assets/icons/social_media/telegram.svg",
                  bgColor: const Color(0xFF0088CC),
                  onTap: () => shareTo("telegram"),
                ),
                socialIcon(
                  asset: "assets/icons/social_media/whatsapp.svg",
                  bgColor: const Color(0xFF25D366),
                  onTap: () => shareTo("whatsapp"),
                ),
              ],
            ),
            const SizedBox(height: 45),
            Container(
              padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 10),
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(10),
                border: Border.all(color: Colors.grey.shade300),
              ),
              child: Row(
                children: [
                  Expanded(
                    child: Text(link, style: const TextStyle(fontSize: 14)),
                  ),
                  ElevatedButton(
                    onPressed: () => copyLink(context),
                    child: const Text("Copy"),
                  ),
                ],
              ),
            ),
          ],
        ),
      ),
    );
  }
}
