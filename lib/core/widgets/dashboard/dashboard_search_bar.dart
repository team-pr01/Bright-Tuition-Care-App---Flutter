import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:btcclient/core/config/theme.dart';

class DashboardSearchBar extends StatelessWidget {
  final String hint;
  final bool showSearchIcon;
  final bool showAddButton;
  final VoidCallback? onAddTap;

  const DashboardSearchBar({
    super.key,
    required this.hint,
    this.showSearchIcon = false,
    this.showAddButton = false,
    this.onAddTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.symmetric(
        horizontal: 16,
        vertical: 14,
      ),
      decoration: BoxDecoration(
        color: const Color(0xFFE9EFF5),
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: Colors.black.withOpacity(.05),
            blurRadius: 10,
            offset: const Offset(0, 4),
          )
        ],
      ),
      child: Row(
        children: [

          /// SEARCH ICON
          if (showSearchIcon) ...[
            SvgPicture.asset(
              "assets/icons/visual/search.svg",
              width: 20,
              height: 20,
              colorFilter: const ColorFilter.mode(
                AppColors.primary01,
                BlendMode.srcIn,
              ),
            ),
            const SizedBox(width: 10),
          ],

          /// TEXT
          Expanded(
            child: Text(
              hint,
              style: Theme.of(context).textTheme.bodyMedium!.copyWith(
                    color: AppColors.neutrals03,
                  ),
            ),
          ),

          /// ADD BUTTON
          if (showAddButton)
            GestureDetector(
              onTap: onAddTap,
              child: Container(
                padding: const EdgeInsets.all(4),
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: AppColors.primary01.withOpacity(.1),
                ),
                child: const Icon(
                  Icons.add,
                  size: 18,
                  color: AppColors.primary01,
                ),
              ),
            ),
        ],
      ),
    );
  }
}