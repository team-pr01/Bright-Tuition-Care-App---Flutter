import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:btcclient/core/config/theme.dart';

class ReusableSearchBar extends StatelessWidget {
  final TextEditingController controller;
  final ValueChanged<String>? onChanged;
  final VoidCallback? onTap;

  const ReusableSearchBar({
    super.key,
    required this.controller,
    this.onChanged,
    this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      height: 41,
      padding: const EdgeInsets.symmetric(horizontal: 15),
      decoration: BoxDecoration(
        boxShadow: [
          BoxShadow(
            color: AppColors.primary01.withOpacity(0.15),
            offset: const Offset(0, 2),
            blurRadius: 2,
          )
        ],
        color: AppColors.primary03,
        borderRadius: BorderRadius.circular(30),
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

          /// 🔥 REAL INPUT FIELD
          Expanded(
            child: TextField(
              controller: controller,
              onChanged: onChanged,
              onTap: onTap,
              style: Theme.of(context).textTheme.titleSmall,
              cursorColor: AppColors.primary01,
              decoration: InputDecoration(
                hintText: "Search For Tuition",
                hintStyle: Theme.of(context)
                    .textTheme
                    .titleSmall!
                    .copyWith(
                      color: AppColors.neutrals03,
                      height: 1.5,
                    ),

                /// 🔴 REMOVE DEFAULT BORDERS
                border: InputBorder.none,
                isDense: true,
                contentPadding: EdgeInsets.zero,
              ),
            ),
          ),
        ],
      ),
    );
  }
}