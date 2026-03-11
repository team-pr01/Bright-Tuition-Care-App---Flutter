import 'package:flutter/material.dart';
import 'package:flutter_svg/flutter_svg.dart';
import 'package:btcclient/core/config/theme.dart';

class TutorSearchBar extends StatelessWidget {
  final VoidCallback onTap;

  const TutorSearchBar({
    super.key,
    required this.onTap,
  });

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        height: 41,
        padding: const EdgeInsets.only(left: 15, right: 15 , top: 8, bottom: 8),
        decoration: BoxDecoration(
          boxShadow:[ BoxShadow(
              color: AppColors.primary01.withOpacity(0.15),
              offset: const Offset(0, 2),
              blurRadius: 2,
            )],
          color: AppColors.primary03,
          borderRadius: BorderRadius.circular(30),
        ),
        child: Row(
          crossAxisAlignment: CrossAxisAlignment.center,
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
            Text(
              "Search For Tuition",
                style: Theme.of(context).textTheme.titleSmall!.copyWith(
                      color: AppColors.neutrals03,
                      height: 1.5
                    ),
            ),
          ],
        ),
      ),
    );
  }
}
  