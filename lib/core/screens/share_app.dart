import 'package:btcclient/core/widgets/navbar/common_appbar.dart';
import 'package:btcclient/core/widgets/share_card/share_card.dart';
import 'package:flutter/material.dart';

class ShareScreen extends StatelessWidget {
  const ShareScreen({super.key});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      appBar: const CommonAppBar(),

      body: Center(
        child: ShareCard(
          title: "Share with your Friends and Relatives",
          description:
              "Help your friends and relatives to find the right tutor for their children by sharing our platform — and earn exclusive rewards!",
          link: "https://www.brighttuitioncare.com",
        ),
      ),
    );
  }
}