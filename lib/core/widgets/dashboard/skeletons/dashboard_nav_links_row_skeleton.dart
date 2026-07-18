import 'package:flutter/material.dart';
import 'dashboard_nav_link_skeleton.dart';

class DashboardNavLinksRowSkeleton extends StatelessWidget {
  const DashboardNavLinksRowSkeleton({super.key});

  @override
  Widget build(BuildContext context) {
    return Row(
      mainAxisAlignment: MainAxisAlignment.spaceAround,
      children: const [
        DashboardNavLinkSkeleton(),
        DashboardNavLinkSkeleton(),
        DashboardNavLinkSkeleton(),
        DashboardNavLinkSkeleton(),
        DashboardNavLinkSkeleton(),
      ],
    );
  }
}