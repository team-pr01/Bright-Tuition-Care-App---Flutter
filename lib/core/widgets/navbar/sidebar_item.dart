import 'package:flutter/material.dart';

class SidebarItem extends StatelessWidget {
  final String label;
  final Widget icon;
  final VoidCallback onTap;
  final bool selected;

  const SidebarItem({
    super.key,
    required this.label,
    required this.icon,
    required this.onTap,
    this.selected = false,
  });

  @override
  Widget build(BuildContext context) {
    return ListTile(
      dense: true,
      minLeadingWidth: 28,
      contentPadding: const EdgeInsets.symmetric(horizontal: 12,vertical: 8),

      leading: icon,

      title: Text(
        label,
        style: Theme.of(context).textTheme.titleLarge!.copyWith(
          fontWeight: FontWeight.w500,
          color: Colors.white,
        ),
      ),

      visualDensity: const VisualDensity(vertical: -2),

      onTap: onTap,
    );
  }
}