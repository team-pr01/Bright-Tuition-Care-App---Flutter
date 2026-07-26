import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:btcclient/core/config/theme.dart';

class ApplicationSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final Function(String) onChanged;

  const ApplicationSearchBar({
    super.key,
    required this.controller,
    required this.onChanged,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 41,
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        color: AppColors.primary03, // ✅ SAME COLOR FOR WHOLE BAR
        borderRadius: BorderRadius.circular(30),
        boxShadow: [
          BoxShadow(
            color: AppColors.primary01.withOpacity(0.15),
            offset: const Offset(0, 2),
            blurRadius: 2,
          ),
        ],
      ),
      child: Row(
        children: [
          SvgPicture.asset(
            "assets/icons/operations/search.svg",
            width: 16,
            height: 16,
            colorFilter: const ColorFilter.mode(
              AppColors.primary01,
              BlendMode.srcIn,
            ),
          ),

          const SizedBox(width: 10),

          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,

              cursorColor: AppColors.primary01,
              style: Theme.of(context).textTheme.titleSmall,
              decoration: InputDecoration(
                hintText: "Search...",
                border: InputBorder.none,
                isDense: true,
                focusedBorder: InputBorder.none,
                // 🔥 IMPORTANT (prevents white background)
                filled: true,
                fillColor: Colors.transparent,

                hintStyle: Theme.of(context).textTheme.titleSmall!.copyWith(
                  color: AppColors.neutrals03,
                  height: 1.5,
                ),
              ),
            ),
          ),
        ],
      ),
    );
  }
}
