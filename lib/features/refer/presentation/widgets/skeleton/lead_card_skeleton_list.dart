import 'package:flutter/material.dart';

import 'lead_card_skeleton.dart';

class LeadCardSkeletonList extends StatelessWidget {
  const LeadCardSkeletonList({super.key});

  @override
  Widget build(BuildContext context) {
    return ListView.separated(
      physics: const AlwaysScrollableScrollPhysics(),
      padding: const EdgeInsets.all(12),
      itemCount: 6,
      separatorBuilder: (_, __) => const SizedBox(height: 12),
      itemBuilder: (_, __) => const LeadCardSkeleton(),
    );
  }
}